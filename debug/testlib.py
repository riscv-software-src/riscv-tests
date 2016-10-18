import os.path
import re
import shlex
import subprocess
import sys
import time
import traceback

import pexpect

# Note that gdb comes with its own testsuite. I was unable to figure out how to
# run that testsuite against the spike simulator.

def find_file(path):
    for directory in (os.getcwd(), os.path.dirname(__file__)):
        fullpath = os.path.join(directory, path)
        if os.path.exists(fullpath):
            return fullpath
    return None

def compile(args, xlen=32): # pylint: disable=redefined-builtin
    cc = os.path.expandvars("$RISCV/bin/riscv%d-unknown-elf-gcc" % xlen)
    cmd = [cc, "-g"]
    for arg in args:
        found = find_file(arg)
        if found:
            cmd.append(found)
        else:
            cmd.append(arg)
    cmd = " ".join(cmd)
    result = os.system(cmd)
    assert result == 0, "%r failed" % cmd

def unused_port():
    # http://stackoverflow.com/questions/2838244/get-open-tcp-port-in-python/2838309#2838309
    import socket
    s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    s.bind(("", 0))
    port = s.getsockname()[1]
    s.close()
    return port

class Spike(object):
    logname = "spike.log"

    def __init__(self, cmd, binary=None, halted=False, with_gdb=True,
            timeout=None, xlen=64):
        """Launch spike. Return tuple of its process and the port it's running
        on."""
        if cmd:
            cmd = shlex.split(cmd)
        else:
            cmd = ["spike"]
        if xlen == 32:
            cmd += ["--isa", "RV32"]

        if timeout:
            cmd = ["timeout", str(timeout)] + cmd

        if halted:
            cmd.append('-H')
        if with_gdb:
            self.port = unused_port()
            cmd += ['--gdb-port', str(self.port)]
        cmd.append("-m32")
        cmd.append('pk')
        if binary:
            cmd.append(binary)
        logfile = open(self.logname, "w")
        logfile.write("+ %s\n" % " ".join(cmd))
        logfile.flush()
        self.process = subprocess.Popen(cmd, stdin=subprocess.PIPE,
                stdout=logfile, stderr=logfile)

    def __del__(self):
        try:
            self.process.kill()
            self.process.wait()
        except OSError:
            pass

    def wait(self, *args, **kwargs):
        return self.process.wait(*args, **kwargs)

class VcsSim(object):
    def __init__(self, simv=None, debug=False):
        if simv:
            cmd = shlex.split(simv)
        else:
            cmd = ["simv"]
        cmd += ["+jtag_vpi_enable"]
        if debug:
            cmd[0] = cmd[0] + "-debug"
            cmd += ["+vcdplusfile=output/gdbserver.vpd"]
        logfile = open("simv.log", "w")
        logfile.write("+ %s\n" % " ".join(cmd))
        logfile.flush()
        listenfile = open("simv.log", "r")
        listenfile.seek(0, 2)
        self.process = subprocess.Popen(cmd, stdin=subprocess.PIPE,
                stdout=logfile, stderr=logfile)
        done = False
        while not done:
            line = listenfile.readline()
            if not line:
                time.sleep(1)
            if "Listening on port 5555" in line:
                done = True

    def __del__(self):
        try:
            self.process.kill()
            self.process.wait()
        except OSError:
            pass

class Openocd(object):
    logname = "openocd.log"

    def __init__(self, cmd=None, config=None, debug=False):
        if cmd:
            cmd = shlex.split(cmd)
        else:
            cmd = ["openocd"]
        if config:
            cmd += ["-f", find_file(config)]
        if debug:
            cmd.append("-d")
        logfile = open(Openocd.logname, "w")
        logfile.write("+ %s\n" % " ".join(cmd))
        logfile.flush()
        self.process = subprocess.Popen(cmd, stdin=subprocess.PIPE,
                stdout=logfile, stderr=logfile)
        # TODO: Pick a random port
        self.port = 3333

        # Wait for OpenOCD to have made it through riscv_examine(). When using
        # OpenOCD to communicate with a simulator this may take a long time,
        # and gdb will time out when trying to connect if we attempt too early.
        start = time.time()
        messaged = False
        while True:
            log = open(Openocd.logname).read()
            if "Examined RISCV core" in log:
                break
            if not self.process.poll() is None:
                raise Exception(
                        "OpenOCD exited before completing riscv_examine()")
            if not messaged and time.time() - start > 1:
                messaged = True
                print "Waiting for OpenOCD to examine RISCV core..."

    def __del__(self):
        try:
            self.process.kill()
            self.process.wait()
        except OSError:
            pass

class OpenocdCli(object):
    def __init__(self, port=4444):
        self.child = pexpect.spawn("sh -c 'telnet localhost %d | tee openocd-cli.log'" % port)
        self.child.expect("> ")

    def command(self, cmd):
        self.child.sendline(cmd)
        self.child.expect("\n")
        self.child.expect("> ")
        return self.child.before.strip()

class CannotAccess(Exception):
    def __init__(self, address):
        Exception.__init__(self)
        self.address = address

class Gdb(object):
    def __init__(self,
            cmd=os.path.expandvars("$RISCV/bin/riscv64-unknown-elf-gdb")):
        self.child = pexpect.spawn(cmd)
        self.child.logfile = open("gdb.log", "w")
        self.child.logfile.write("+ %s\n" % cmd)
        self.wait()
        self.command("set confirm off")
        self.command("set width 0")
        self.command("set height 0")
        # Force consistency.
        self.command("set print entry-values no")

    def wait(self):
        """Wait for prompt."""
        self.child.expect(r"\(gdb\)")

    def command(self, command, timeout=-1):
        self.child.sendline(command)
        self.child.expect("\n", timeout=timeout)
        self.child.expect(r"\(gdb\)", timeout=timeout)
        return self.child.before.strip()

    def c(self, wait=True):
        if wait:
            output = self.command("c")
            assert "Continuing" in output
            return output
        else:
            self.child.sendline("c")
            self.child.expect("Continuing")

    def interrupt(self):
        self.child.send("\003")
        self.child.expect(r"\(gdb\)", timeout=60)
        return self.child.before.strip()

    def x(self, address, size='w'):
        output = self.command("x/%s %s" % (size, address))
        value = int(output.split(':')[1].strip(), 0)
        return value

    def p(self, obj):
        output = self.command("p/x %s" % obj)
        m = re.search("Cannot access memory at address (0x[0-9a-f]+)", output)
        if m:
            raise CannotAccess(int(m.group(1), 0))
        value = int(output.split('=')[-1].strip(), 0)
        return value

    def p_string(self, obj):
        output = self.command("p %s" % obj)
        value = shlex.split(output.split('=')[-1].strip())[1]
        return value

    def stepi(self):
        output = self.command("stepi")
        return output

    def load(self):
        output = self.command("load", timeout=60)
        assert "failed" not in  output
        assert "Transfer rate" in output

    def b(self, location):
        output = self.command("b %s" % location)
        assert "not defined" not in output
        assert "Breakpoint" in output
        return output

    def hbreak(self, location):
        output = self.command("hbreak %s" % location)
        assert "not defined" not in output
        assert "Hardware assisted breakpoint" in output
        return output

def run_all_tests(module, target, tests, fail_fast):
    good_results = set(('pass', 'not_applicable'))

    start = time.time()

    results = {}
    count = 0
    for name in dir(module):
        definition = getattr(module, name)
        if type(definition) == type and hasattr(definition, 'test') and \
                (not tests or any(test in name for test in tests)):
            instance = definition(target)
            result = instance.run()
            results.setdefault(result, []).append(name)
            count += 1
            if result not in good_results and fail_fast:
                break

    header("ran %d tests in %.0fs" % (count, time.time() - start), dash=':')

    result = 0
    for key, value in results.iteritems():
        print "%d tests returned %s" % (len(value), key)
        if key not in good_results:
            result = 1
            for test in value:
                print "   ", test

    return result

def add_test_run_options(parser):
    parser.add_argument("--fail-fast", "-f", action="store_true",
            help="Exit as soon as any test fails.")
    parser.add_argument("test", nargs='*',
            help="Run only tests that are named here.")

def header(title, dash='-'):
    dashes = dash * (36 - len(title))
    before = dashes[:len(dashes)/2]
    after = dashes[len(dashes)/2:]
    print "%s[ %s ]%s" % (before, title, after)

class BaseTest(object):
    compiled = {}
    logs = []

    def __init__(self, target):
        self.target = target
        self.server = None
        self.target_process = None
        self.binary = None
        self.start = 0

    def early_applicable(self):
        """Return a false value if the test has determined it cannot run
        without ever needing to talk to the target or server."""
        # pylint: disable=no-self-use
        return True

    def setup(self):
        pass

    def compile(self):
        compile_args = getattr(self, 'compile_args', None)
        if compile_args:
            if compile_args not in BaseTest.compiled:
                try:
                    # pylint: disable=star-args
                    BaseTest.compiled[compile_args] = \
                            self.target.compile(*compile_args)
                except Exception: # pylint: disable=broad-except
                    print "exception while compiling in %.2fs" % (
                            time.time() - self.start)
                    print "=" * 40
                    header("Traceback")
                    traceback.print_exc(file=sys.stdout)
                    print "/" * 40
                    return "exception"
        self.binary = BaseTest.compiled.get(compile_args)

    def classSetup(self):
        self.compile()
        self.target_process = self.target.target()
        self.server = self.target.server()
        self.logs.append(self.server.logname)

    def classTeardown(self):
        del self.server
        del self.target_process

    def run(self):
        """
        If compile_args is set, compile a program and set self.binary.

        Call setup().

        Then call test() and return the result, displaying relevant information
        if an exception is raised.
        """

        print "Running", type(self).__name__, "...",
        sys.stdout.flush()

        if not self.early_applicable():
            print "not_applicable"
            return "not_applicable"

        self.start = time.time()

        self.classSetup()

        try:
            self.setup()
            result = self.test()    # pylint: disable=no-member
        except Exception as e: # pylint: disable=broad-except
            if isinstance(e, TestFailed):
                result = "fail"
            else:
                result = "exception"
            print "%s in %.2fs" % (result, time.time() - self.start)
            print "=" * 40
            if isinstance(e, TestFailed):
                header("Message")
                print e.message
            header("Traceback")
            traceback.print_exc(file=sys.stdout)
            for log in self.logs:
                header(log)
                print open(log, "r").read()
            print "/" * 40
            return result

        finally:
            self.classTeardown()

        if not result:
            result = 'pass'
        print "%s in %.2fs" % (result, time.time() - self.start)
        return result

class TestFailed(Exception):
    def __init__(self, message):
        Exception.__init__(self)
        self.message = message

def assertEqual(a, b):
    if a != b:
        raise TestFailed("%r != %r" % (a, b))

def assertNotEqual(a, b):
    if a == b:
        raise TestFailed("%r == %r" % (a, b))

def assertIn(a, b):
    if a not in b:
        raise TestFailed("%r not in %r" % (a, b))

def assertNotIn(a, b):
    if a in b:
        raise TestFailed("%r in %r" % (a, b))

def assertGreater(a, b):
    if not a > b:
        raise TestFailed("%r not greater than %r" % (a, b))

def assertTrue(a):
    if not a:
        raise TestFailed("%r is not True" % a)

def assertRegexpMatches(text, regexp):
    if not re.search(regexp, text):
        raise TestFailed("can't find %r in %r" % (regexp, text))
