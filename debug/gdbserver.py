#!/usr/bin/python

import os
import sys
import argparse
import testlib
import unittest
import tempfile
import time
import random
import binascii

MSTATUS_UIE = 0x00000001
MSTATUS_SIE = 0x00000002
MSTATUS_HIE = 0x00000004
MSTATUS_MIE = 0x00000008
MSTATUS_UPIE = 0x00000010
MSTATUS_SPIE = 0x00000020
MSTATUS_HPIE = 0x00000040
MSTATUS_MPIE = 0x00000080
MSTATUS_SPP = 0x00000100
MSTATUS_HPP = 0x00000600
MSTATUS_MPP = 0x00001800
MSTATUS_FS = 0x00006000
MSTATUS_XS = 0x00018000
MSTATUS_MPRV = 0x00020000
MSTATUS_PUM = 0x00040000
MSTATUS_MXR = 0x00080000
MSTATUS_VM = 0x1F000000
MSTATUS32_SD = 0x80000000
MSTATUS64_SD = 0x8000000000000000

def ihex_line(address, record_type, data):
    assert len(data) < 128
    line = ":%02X%04X%02X" % (len(data), address, record_type)
    check = len(data)
    check += address % 256
    check += address >> 8
    check += record_type
    for char in data:
        value = ord(char)
        check += value
        line += "%02X" % value
    line += "%02X\n" % ((256-check)%256)
    return line

def ihex_parse(line):
    assert line.startswith(":")
    line = line[1:]
    data_len = int(line[:2], 16)
    address = int(line[2:6], 16)
    record_type = int(line[6:8], 16)
    data = ""
    for i in range(data_len):
        data += "%c" % int(line[8+2*i:10+2*i], 16)
    return record_type, address, data

class DeleteServer(unittest.TestCase):
    def tearDown(self):
        del self.server

class SimpleRegisterTest(DeleteServer):
    def setUp(self):
        self.server = target.server()
        self.gdb = testlib.Gdb()
        # For now gdb has to be told what the architecture is when it's not
        # given an ELF file.
        self.gdb.command("set arch riscv:rv%d" % target.xlen)

        self.gdb.command("target extended-remote localhost:%d" % self.server.port)

        # 0x13 is nop
        self.gdb.command("p *((int*) 0x%x)=0x13" % target.ram)
        self.gdb.command("p *((int*) 0x%x)=0x13" % (target.ram + 4))
        self.gdb.command("p *((int*) 0x%x)=0x13" % (target.ram + 8))
        self.gdb.p("$pc=0x%x" % target.ram)

    def check_reg(self, name):
        a = random.randrange(1<<target.xlen)
        b = random.randrange(1<<target.xlen)
        self.gdb.p("$%s=0x%x" % (name, a))
        self.gdb.stepi()
        self.assertEqual(self.gdb.p("$%s" % name), a)
        self.gdb.p("$%s=0x%x" % (name, b))
        self.gdb.stepi()
        self.assertEqual(self.gdb.p("$%s" % name), b)

    def test_s0(self):
        # S0 is saved/restored in DSCRATCH
        self.check_reg("s0")

    def test_s1(self):
        # S1 is saved/restored in Debug RAM
        self.check_reg("s1")

    def test_t0(self):
        # T0 is not saved/restored at all
        self.check_reg("t2")

    def test_t2(self):
        # T2 is not saved/restored at all
        self.check_reg("t2")

class SimpleMemoryTest(DeleteServer):
    def setUp(self):
        self.server = target.server()
        self.gdb = testlib.Gdb()
        self.gdb.command("set arch riscv:rv%d" % target.xlen)
        self.gdb.command("target extended-remote localhost:%d" % self.server.port)

    def access_test(self, size, data_type):
        self.assertEqual(self.gdb.p("sizeof(%s)" % data_type),
                size)
        a = 0x86753095555aaaa & ((1<<(size*8))-1)
        b = 0xdeadbeef12345678 & ((1<<(size*8))-1)
        self.gdb.p("*((%s*)0x%x) = 0x%x" % (data_type, target.ram, a))
        self.gdb.p("*((%s*)0x%x) = 0x%x" % (data_type, target.ram + size, b))
        self.assertEqual(self.gdb.p("*((%s*)0x%x)" % (data_type, target.ram)), a)
        self.assertEqual(self.gdb.p("*((%s*)0x%x)" % (data_type, target.ram + size)), b)

    def test_8(self):
        self.access_test(1, 'char')

    def test_16(self):
        self.access_test(2, 'short')

    def test_32(self):
        self.access_test(4, 'int')

    def test_64(self):
        self.access_test(8, 'long long')

    def test_block(self):
        length = 1024
        line_length = 16
        a = tempfile.NamedTemporaryFile(suffix=".ihex")
        data = ""
        for i in range(length / line_length):
            line_data = "".join(["%c" % random.randrange(256) for _ in range(line_length)])
            data += line_data
            a.write(ihex_line(i * line_length, 0, line_data))
        a.flush()

        self.gdb.command("restore %s 0x%x" % (a.name, target.ram))
        for offset in range(0, length, 19*4) + [length-4]:
            value = self.gdb.p("*((int*)0x%x)" % (target.ram + offset))
            written = ord(data[offset]) | \
                    (ord(data[offset+1]) << 8) | \
                    (ord(data[offset+2]) << 16) | \
                    (ord(data[offset+3]) << 24)
            self.assertEqual(value, written)

        b = tempfile.NamedTemporaryFile(suffix=".ihex")
        self.gdb.command("dump ihex memory %s 0x%x 0x%x" % (b.name, target.ram,
            target.ram + length))
        for line in b:
            record_type, address, line_data = ihex_parse(line)
            if (record_type == 0):
                self.assertEqual(line_data, data[address:address+len(line_data)])

class InstantHaltTest(DeleteServer):
    def setUp(self):
        self.server = target.server()
        self.gdb = testlib.Gdb()
        self.gdb.command("set arch riscv:rv%d" % target.xlen)
        self.gdb.command("target extended-remote localhost:%d" % self.server.port)

    def test_instant_halt(self):
        self.assertEqual(target.reset_vector, self.gdb.p("$pc"))
        # mcycle and minstret have no defined reset value.
        mstatus = self.gdb.p("$mstatus")
        self.assertEqual(mstatus & (MSTATUS_MIE | MSTATUS_MPRV |
            MSTATUS_VM), 0)

    def test_change_pc(self):
        """Change the PC right as we come out of reset."""
        # 0x13 is nop
        self.gdb.command("p *((int*) 0x%x)=0x13" % target.ram)
        self.gdb.command("p *((int*) 0x%x)=0x13" % (target.ram + 4))
        self.gdb.command("p *((int*) 0x%x)=0x13" % (target.ram + 8))
        self.gdb.p("$pc=0x%x" % target.ram)
        self.gdb.stepi()
        self.assertEqual((target.ram + 4), self.gdb.p("$pc"))
        self.gdb.stepi()
        self.assertEqual((target.ram + 8), self.gdb.p("$pc"))

class DebugTest(DeleteServer):
    def setUp(self):
        # Include malloc so that gdb can make function calls. I suspect this
        # malloc will silently blow through the memory set aside for it, so be
        # careful.
        self.binary = target.compile("programs/debug.c", "programs/checksum.c",
                "programs/tiny-malloc.c", "-DDEFINE_MALLOC", "-DDEFINE_FREE")
        self.server = target.server()
        self.gdb = testlib.Gdb()
        self.gdb.command("file %s" % self.binary)
        self.gdb.command("target extended-remote localhost:%d" % self.server.port)
        self.gdb.load()
        self.gdb.b("_exit")

    def exit(self, expected_result = 0xc86455d4):
        output = self.gdb.c()
        self.assertIn("Breakpoint", output)
        self.assertIn("_exit", output)
        self.assertEqual(self.gdb.p("status"), expected_result)

    def test_function_call(self):
        self.gdb.b("main:start")
        self.gdb.c()
        text = "Howdy, Earth!"
        gdb_length = self.gdb.p('strlen("%s")' % text)
        self.assertEqual(gdb_length, len(text))
        self.exit()

    def test_change_string(self):
        text = "This little piggy went to the market."
        self.gdb.b("main:start")
        self.gdb.c()
        self.gdb.p('fox = "%s"' % text)
        self.exit(0x43b497b8)

    def test_turbostep(self):
        """Single step a bunch of times."""
        self.gdb.command("p i=0");
        last_pc = None
        advances = 0
        jumps = 0
        for _ in range(100):
            self.gdb.stepi()
            pc = self.gdb.p("$pc")
            self.assertNotEqual(last_pc, pc)
            if (last_pc and pc > last_pc and pc - last_pc <= 4):
                advances += 1
            else:
                jumps += 1
            last_pc = pc
        # Some basic sanity that we're not running between breakpoints or
        # something.
        self.assertGreater(jumps, 10)
        self.assertGreater(advances, 50)

    def test_exit(self):
        self.exit()

    def test_symbols(self):
        self.gdb.b("main")
        self.gdb.b("rot13")
        output = self.gdb.c()
        self.assertIn(", main ", output)
        output = self.gdb.c()
        self.assertIn(", rot13 ", output)

    def test_breakpoint(self):
        self.gdb.b("rot13")
        # The breakpoint should be hit exactly 2 times.
        for i in range(2):
            output = self.gdb.c()
            self.gdb.p("$pc")
            self.assertIn("Breakpoint ", output)
            #TODO self.assertIn("rot13 ", output)
        self.exit()

    def test_hwbp_1(self):
        if target.instruction_hardware_breakpoint_count < 1:
            return

        self.gdb.hbreak("rot13")
        # The breakpoint should be hit exactly 2 times.
        for i in range(2):
            output = self.gdb.c()
            self.gdb.p("$pc")
            self.assertIn("Breakpoint ", output)
            #TODO self.assertIn("rot13 ", output)
        self.exit()

    def test_hwbp_2(self):
        if target.instruction_hardware_breakpoint_count < 2:
            return

        self.gdb.hbreak("main")
        self.gdb.hbreak("rot13")
        # We should hit 3 breakpoints.
        for i in range(3):
            output = self.gdb.c()
            self.gdb.p("$pc")
            self.assertIn("Breakpoint ", output)
            #TODO self.assertIn("rot13 ", output)
        self.exit()

    def test_too_many_hwbp(self):
        for i in range(30):
            self.gdb.hbreak("*rot13 + %d" % (i * 4))

        output = self.gdb.c()
        self.assertIn("Cannot insert hardware breakpoint", output)
        # Clean up, otherwise the hardware breakpoints stay set and future
        # tests may fail.
        self.gdb.command("D")

    def test_registers(self):
        # Get to a point in the code where some registers have actually been
        # used.
        self.gdb.b("rot13")
        self.gdb.c()
        self.gdb.c()
        # Try both forms to test gdb.
        for cmd in ("info all-registers", "info registers all"):
            output = self.gdb.command(cmd)
            self.assertNotIn("Could not", output)
            for reg in ('zero', 'ra', 'sp', 'gp', 'tp'):
                self.assertIn(reg, output)

        #TODO
        # mcpuid is one of the few registers that should have the high bit set
        # (for rv64).
        # Leave this commented out until gdb and spike agree on the encoding of
        # mcpuid (which is going to be renamed to misa in any case).
        #self.assertRegexpMatches(output, ".*mcpuid *0x80")

        #TODO:
        # The instret register should always be changing.
        #last_instret = None
        #for _ in range(5):
        #    instret = self.gdb.p("$instret")
        #    self.assertNotEqual(instret, last_instret)
        #    last_instret = instret
        #    self.gdb.stepi()

        self.exit()

    def test_interrupt(self):
        """Sending gdb ^C while the program is running should cause it to halt."""
        self.gdb.b("main:start")
        self.gdb.c()
        self.gdb.p("i=123");
        self.gdb.c(wait=False)
        time.sleep(0.1)
        output = self.gdb.interrupt()
        #TODO: assert "main" in output
        self.assertGreater(self.gdb.p("j"), 10)
        self.gdb.p("i=0");
        self.exit()

class StepTest(DeleteServer):
    def setUp(self):
        self.binary = target.compile("programs/step.S")
        self.server = target.server()
        self.gdb = testlib.Gdb()
        self.gdb.command("file %s" % self.binary)
        self.gdb.command("target extended-remote localhost:%d" % self.server.port)
        self.gdb.load()
        self.gdb.b("main")
        self.gdb.c()

    def test_step(self):
        main = self.gdb.p("$pc")
        for expected in (4, 8, 0xc, 0x10, 0x18, 0x1c, 0x28, 0x20, 0x2c, 0x2c):
            self.gdb.stepi()
            pc = self.gdb.p("$pc")
            self.assertEqual("%x" % pc, "%x" % (expected + main))

class RegsTest(DeleteServer):
    def setUp(self):
        self.binary = target.compile("programs/regs.S")
        self.server = target.server()
        self.gdb = testlib.Gdb()
        self.gdb.command("file %s" % self.binary)
        self.gdb.command("target extended-remote localhost:%d" % self.server.port)
        self.gdb.load()
        self.gdb.b("main")
        self.gdb.b("handle_trap")
        self.gdb.c()

    def test_write_gprs(self):
        regs = [("x%d" % n) for n in range(2, 32)]

        self.gdb.p("$pc=write_regs")
        for i, r in enumerate(regs):
            self.gdb.command("p $%s=%d" % (r, (0xdeadbeef<<i)+17))
        self.gdb.command("p $x1=data")
        self.gdb.command("b all_done")
        output = self.gdb.c()
        self.assertIn("Breakpoint ", output)

        # Just to get this data in the log.
        self.gdb.command("x/30gx data")
        self.gdb.command("info registers")
        for n in range(len(regs)):
            self.assertEqual(self.gdb.x("data+%d" % (8*n), 'g'),
                    ((0xdeadbeef<<n)+17) & ((1<<target.xlen)-1))

    def test_write_csrs(self):
        # As much a test of gdb as of the simulator.
        self.gdb.p("$mscratch=0")
        self.gdb.stepi()
        self.assertEqual(self.gdb.p("$mscratch"), 0)
        self.gdb.p("$mscratch=123")
        self.gdb.stepi()
        self.assertEqual(self.gdb.p("$mscratch"), 123)

        self.gdb.command("p $pc=write_regs")
        self.gdb.command("p $a0=data")
        self.gdb.command("b all_done")
        self.gdb.command("c")

        self.assertEqual(123, self.gdb.p("$mscratch"))
        self.assertEqual(123, self.gdb.p("$x1"))
        self.assertEqual(123, self.gdb.p("$csr832"))

class DownloadTest(DeleteServer):
    def setUp(self):
        length = min(2**20, target.ram_size - 2048)
        download_c = tempfile.NamedTemporaryFile(prefix="download_", suffix=".c")
        download_c.write("#include <stdint.h>\n")
        download_c.write("unsigned int crc32a(uint8_t *message, unsigned int size);\n")
        download_c.write("uint32_t length = %d;\n" % length)
        download_c.write("uint8_t d[%d] = {\n" % length)
        self.crc = 0
        for i in range(length / 16):
            download_c.write("  /* 0x%04x */ " % (i * 16));
            for _ in range(16):
                value = random.randrange(1<<8)
                download_c.write("%d, " % value)
                self.crc = binascii.crc32("%c" % value, self.crc)
            download_c.write("\n");
        download_c.write("};\n");
        download_c.write("uint8_t *data = &d[0];\n");
        download_c.write("uint32_t main() { return crc32a(data, length); }\n")
        download_c.flush()

        if self.crc < 0:
            self.crc += 2**32

        self.binary = target.compile(download_c.name, "programs/checksum.c")
        self.server = target.server()
        self.gdb = testlib.Gdb()
        self.gdb.command("file %s" % self.binary)
        self.gdb.command("target extended-remote localhost:%d" % self.server.port)

    def test_download(self):
        output = self.gdb.load()
        self.gdb.command("b _exit")
        self.gdb.c()
        self.assertEqual(self.gdb.p("status"), self.crc)

class MprvTest(DeleteServer):
    def setUp(self):
        self.binary = target.compile("programs/mprv.S")
        self.server = target.server()
        self.gdb = testlib.Gdb()
        self.gdb.command("file %s" % self.binary)
        self.gdb.command("target extended-remote localhost:%d" % self.server.port)
        self.gdb.load()

    def test_mprv(self):
        """Test that the debugger can access memory when MPRV is set."""
        self.gdb.c(wait=False)
        time.sleep(0.5)
        self.gdb.interrupt()
        output = self.gdb.command("p/x *(int*)(((char*)&data)-0x80000000)")
        self.assertIn("0xbead", output)

class Target(object):
    directory = None

    def server(self):
        raise NotImplementedError

    def compile(self, *sources):
        binary_name = "%s_%s" % (
                self.name,
                os.path.basename(os.path.splitext(sources[0])[0]))
        if parsed.isolate:
            self.temporary_binary = tempfile.NamedTemporaryFile(
                    prefix=binary_name + "_")
            binary_name = self.temporary_binary.name
        testlib.compile(sources +
                ("programs/entry.S", "programs/init.c",
                    "-I", "../env",
                    "-T", "targets/%s/link.lds" % (self.directory or self.name),
                    "-nostartfiles",
                    "-mcmodel=medany",
                    "-o", binary_name),
                xlen=self.xlen)
        return binary_name

class SpikeTarget(Target):
    directory = "spike"
    ram = 0x80010000
    ram_size = 5 * 1024 * 1024
    instruction_hardware_breakpoint_count = 0
    reset_vector = 0x1000

class Spike64Target(SpikeTarget):
    name = "spike64"
    xlen = 64

    def server(self):
        return testlib.Spike(parsed.cmd, halted=True)

class Spike32Target(SpikeTarget):
    name = "spike32"
    xlen = 32

    def server(self):
        return testlib.Spike(parsed.cmd, halted=True, xlen=32)

class FreedomE300Target(Target):
    name = "freedom-e300"
    xlen = 32
    ram = 0x80000000
    ram_size = 16 * 1024
    instruction_hardware_breakpoint_count = 2

    def server(self):
        return testlib.Openocd(cmd=parsed.cmd,
                config="targets/%s/openocd.cfg" % self.name)

targets = [
        Spike32Target,
        Spike64Target,
        FreedomE300Target
        ]

def main():
    parser = argparse.ArgumentParser(
            epilog="""
            Example command line from the real world:
            Run all RegsTest cases against a MicroSemi m2gl_m2s board, with custom openocd command:
            ./gdbserver.py --m2gl_m2s --cmd "$HOME/SiFive/openocd/src/openocd -s $HOME/SiFive/openocd/tcl -d" -- -vf RegsTest
            """)
    group = parser.add_mutually_exclusive_group(required=True)
    for t in targets:
        group.add_argument("--%s" % t.name, action="store_const", const=t,
                dest="target")
    parser.add_argument("--cmd",
            help="The command to use to start the debug server.")
    parser.add_argument("--isolate", action="store_true",
            help="Try to run in such a way that multiple instances can run at "
            "the same time. This may make it harder to debug a failure if it "
            "does occur.")
    parser.add_argument("unittest", nargs="*")
    global parsed
    parsed = parser.parse_args()

    global target
    target = parsed.target()
    unittest.main(argv=[sys.argv[0]] + parsed.unittest)

# TROUBLESHOOTING TIPS
# If a particular test fails, run just that one test, eg.:
# ./tests/gdbserver.py MprvTest.test_mprv
# Then inspect gdb.log and spike.log to see what happened in more detail.

if __name__ == '__main__':
    sys.exit(main())
