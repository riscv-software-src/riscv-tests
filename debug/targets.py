import os.path
import tempfile

import testlib

class Target(object):
    name = "name"
    xlen = 0
    directory = None
    timeout_sec = 2
    temporary_files = []
    temporary_binary = None
    openocd_config = []
    use_fpu = False
    misa = None

    def __init__(self, cmd, run, isolate):
        self.cmd = cmd
        self.run = run
        self.isolate = isolate

    def target(self):
        """Start the target, eg. a simulator."""
        pass

    def server(self):
        """Start the debug server that gdb connects to, eg. OpenOCD."""
        if self.openocd_config:
            return testlib.Openocd(cmd=self.cmd, config=self.openocd_config)
        else:
            raise NotImplementedError

    def compile(self, *sources):
        binary_name = "%s_%s-%d" % (
                self.name,
                os.path.basename(os.path.splitext(sources[0])[0]),
                self.xlen)
        if self.isolate:
            self.temporary_binary = tempfile.NamedTemporaryFile(
                    prefix=binary_name + "_")
            binary_name = self.temporary_binary.name
            Target.temporary_files.append(self.temporary_binary)
        march = "rv%dima" % self.xlen
        if self.use_fpu:
            march += "fd"
        if self.extensionSupported("c"):
            march += "c"
        testlib.compile(sources +
                ("programs/entry.S", "programs/init.c",
                    "-I", "../env",
                    "-march=%s" % march,
                    "-T", "targets/%s/link.lds" % (self.directory or self.name),
                    "-nostartfiles",
                    "-mcmodel=medany",
                    "-DXLEN=%d" % self.xlen,
                    "-o", binary_name),
                xlen=self.xlen)
        return binary_name

    def extensionSupported(self, letter):
        # target.misa is set by testlib.ExamineTarget
        return self.misa & (1 << (ord(letter.upper()) - ord('A')))

class SpikeTarget(Target):
    # pylint: disable=abstract-method
    directory = "spike"
    ram = 0x80010000
    ram_size = 5 * 1024 * 1024
    instruction_hardware_breakpoint_count = 4
    reset_vector = 0x1000

class Spike64Target(SpikeTarget):
    name = "spike64"
    xlen = 64
    use_fpu = True

    def server(self):
        return testlib.Spike(self.cmd, halted=True)

class Spike32Target(SpikeTarget):
    name = "spike32"
    xlen = 32

    def server(self):
        return testlib.Spike(self.cmd, halted=True, xlen=32)

class FreedomE300Target(Target):
    name = "freedom-e300"
    xlen = 32
    ram = 0x80000000
    ram_size = 16 * 1024
    instruction_hardware_breakpoint_count = 2
    openocd_config = "targets/%s/openocd.cfg" % name

class FreedomE300SimTarget(Target):
    name = "freedom-e300-sim"
    xlen = 32
    timeout_sec = 240
    ram = 0x80000000
    ram_size = 256 * 1024 * 1024
    instruction_hardware_breakpoint_count = 2
    openocd_config = "targets/%s/openocd.cfg" % name

    def target(self):
        return testlib.VcsSim(simv=self.run, debug=False)

class FreedomU500Target(Target):
    name = "freedom-u500"
    xlen = 64
    ram = 0x80000000
    ram_size = 16 * 1024
    instruction_hardware_breakpoint_count = 2
    openocd_config = "targets/%s/openocd.cfg" % name

class FreedomU500SimTarget(Target):
    name = "freedom-u500-sim"
    xlen = 64
    timeout_sec = 240
    ram = 0x80000000
    ram_size = 256 * 1024 * 1024
    instruction_hardware_breakpoint_count = 2
    openocd_config = "targets/%s/openocd.cfg" % name

    def target(self):
        return testlib.VcsSim(simv=self.run, debug=False)

targets = [
        Spike32Target,
        Spike64Target,
        FreedomE300Target,
        FreedomU500Target,
        FreedomE300SimTarget,
        FreedomU500SimTarget]

def add_target_options(parser):
    group = parser.add_mutually_exclusive_group(required=True)
    for t in targets:
        group.add_argument("--%s" % t.name, action="store_const", const=t,
                dest="target")
    parser.add_argument("--run",
            help="The command to use to start the actual target (e.g. "
            "simulation)")
    parser.add_argument("--cmd",
            help="The command to use to start the debug server.")

    xlen_group = parser.add_mutually_exclusive_group()
    xlen_group.add_argument("--32", action="store_const", const=32, dest="xlen",
            help="Force the target to be 32-bit.")
    xlen_group.add_argument("--64", action="store_const", const=64, dest="xlen",
            help="Force the target to be 64-bit.")

    parser.add_argument("--isolate", action="store_true",
            help="Try to run in such a way that multiple instances can run at "
            "the same time. This may make it harder to debug a failure if it "
            "does occur.")
