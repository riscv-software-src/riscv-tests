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
    process = subprocess.Popen(cmd, stdout=subprocess.PIPE,
            stderr=subprocess.PIPE)
    stdout, stderr = process.communicate()
    if process.returncode:
        print
        header("Compile failed")
        print "+", " ".join(cmd)
        print stdout,
        print stderr,
        header("")
        raise Exception("Compile failed!")

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

    def __init__(self, cmd, binary=None, halted=False, with_jtag_gdb=True,
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
        if with_jtag_gdb:
            cmd += ['--rbb-port', '0']
            os.environ['REMOTE_BITBANG_HOST'] = 'localhost'
        cmd.append("-m32")
        cmd.append('pk')
        if binary:
            cmd.append(binary)
        logfile = open(self.logname, "w")
        logfile.write("+ %s\n" % " ".join(cmd))
        logfile.flush()
        self.process = subprocess.Popen(cmd, stdin=subprocess.PIPE,
                stdout=logfile, stderr=logfile)

        if with_jtag_gdb:
            self.port = None
            for _ in range(30):
                m = re.search(r"Listening for remote bitbang connection on "
                        r"port (\d+).", open(self.logname).read())
                if m:
                    self.port = int(m.group(1))
                    os.environ['REMOTE_BITBANG_PORT'] = m.group(1)
                    break
                time.sleep(0.11)
            assert self.port, "Didn't get spike message about bitbang " \
                    "connection"

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
            match = re.match(r"^Listening on port (\d+)$", line)
            if match:
                done = True
                self.port = int(match.group(1))
                os.environ['JTAG_VPI_PORT'] = str(self.port)

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
            cmd = ["openocd", "-d"]

        # This command needs to come before any config scripts on the command
        # line, since they are executed in order.
        cmd += [
            # Tell OpenOCD to bind gdb to an unused, ephemeral port.
            "--command",
            "gdb_port 0",
            # Disable tcl and telnet servers, since they are unused and because
            # the port numbers will conflict if multiple OpenOCD processes are
            # running on the same server.
            "--command",
            "tcl_port disabled",
            "--command",
            "telnet_port disabled",
        ]

        if config:
            f = find_file(config)
            if f is None:
                print("Unable to read file " + config)
                exit(1)

            cmd += ["-f", f]
        if debug:
            cmd.append("-d")

        logfile = open(Openocd.logname, "w")
        logfile.write("+ %s\n" % " ".join(cmd))
        logfile.flush()
        self.process = subprocess.Popen(cmd, stdin=subprocess.PIPE,
                stdout=logfile, stderr=logfile)

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

        self.port = self._get_gdb_server_port()

    def _get_gdb_server_port(self):
        """Get port that OpenOCD's gdb server is listening on."""
        MAX_ATTEMPTS = 50
        PORT_REGEX = re.compile(r'(?P<port>\d+) \(LISTEN\)')
        for _ in range(MAX_ATTEMPTS):
            with open(os.devnull, 'w') as devnull:
                try:
                    output = subprocess.check_output([
                        'lsof',
                        '-a',  # Take the AND of the following selectors
                        '-p{}'.format(self.process.pid),  # Filter on PID
                        '-iTCP',  # Filter only TCP sockets
                    ], stderr=devnull)
                except subprocess.CalledProcessError:
                    output = ""
            matches = list(PORT_REGEX.finditer(output))
            matches = [m for m in matches
                    if m.group('port') not in ('6666', '4444')]
            if len(matches) > 1:
                print output
                raise Exception(
                    "OpenOCD listening on multiple ports. Cannot uniquely "
                    "identify gdb server port.")
            elif matches:
                [match] = matches
                return int(match.group('port'))
            time.sleep(0.1)
        raise Exception("Timed out waiting for gdb server to obtain port.")

    def __del__(self):
        try:
            self.process.kill()
            self.process.wait()
        except OSError:
            pass

class OpenocdCli(object):
    def __init__(self, port=4444):
        self.child = pexpect.spawn(
                "sh -c 'telnet localhost %d | tee openocd-cli.log'" % port)
        self.child.expect("> ")

    def command(self, cmd):
        self.child.sendline(cmd)
        self.child.expect(cmd)
        self.child.expect("\n")
        self.child.expect("> ")
        return self.child.before.strip("\t\r\n \0")

    def reg(self, reg=''):
        output = self.command("reg %s" % reg)
        matches = re.findall(r"(\w+) \(/\d+\): (0x[0-9A-F]+)", output)
        values = {r: int(v, 0) for r, v in matches}
        if reg:
            return values[reg]
        return values

    def load_image(self, image):
        output = self.command("load_image %s" % image)
        if 'invalid ELF file, only 32bits files are supported' in output:
            raise TestNotApplicable(output)

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

    def c(self, wait=True, timeout=-1):
        if wait:
            output = self.command("c", timeout=timeout)
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

    def p_raw(self, obj):
        output = self.command("p %s" % obj)
        m = re.search("Cannot access memory at address (0x[0-9a-f]+)", output)
        if m:
            raise CannotAccess(int(m.group(1), 0))
        return output.split('=')[-1].strip()

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

def run_all_tests(module, target, parsed):
    good_results = set(('pass', 'not_applicable'))

    start = time.time()

    results = {}
    count = 0

    global gdb_cmd  # pylint: disable=global-statement
    gdb_cmd = parsed.gdb

    todo = [("ExamineTarget", ExamineTarget)]
    for name in dir(module):
        definition = getattr(module, name)
        if type(definition) == type and hasattr(definition, 'test') and \
                (not parsed.test or any(test in name for test in parsed.test)):
            todo.append((name, definition))

    for name, definition in todo:
        instance = definition(target)
        result = instance.run()
        results.setdefault(result, []).append(name)
        count += 1
        if result not in good_results and parsed.fail_fast:
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
    parser.add_argument("--gdb",
            help="The command to use to start gdb.")

def header(title, dash='-'):
    if title:
        dashes = dash * (36 - len(title))
        before = dashes[:len(dashes)/2]
        after = dashes[len(dashes)/2:]
        print "%s[ %s ]%s" % (before, title, after)
    else:
        print dash * 40

def print_log(path):
    header(path)
    lines = open(path, "r").readlines()
    if len(lines) > 1000:
        for l in lines[:500]:
            sys.stdout.write(l)
        print "..."
        for l in lines[-500:]:
            sys.stdout.write(l)
    else:
        for l in lines:
            sys.stdout.write(l)

class BaseTest(object):
    compiled = {}

    def __init__(self, target):
        self.target = target
        self.server = None
        self.target_process = None
        self.binary = None
        self.start = 0
        self.logs = []

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
                # pylint: disable=star-args
                BaseTest.compiled[compile_args] = \
                        self.target.compile(*compile_args)
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
        except TestNotApplicable:
            result = "not_applicable"
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
                print_log(log)
            print "/" * 40
            return result

        finally:
            self.classTeardown()

        if not result:
            result = 'pass'
        print "%s in %.2fs" % (result, time.time() - self.start)
        return result

gdb_cmd = None
class GdbTest(BaseTest):
    def __init__(self, target):
        BaseTest.__init__(self, target)
        self.gdb = None

    def classSetup(self):
        BaseTest.classSetup(self)
        self.logs.append("gdb.log")

        if gdb_cmd:
            self.gdb = Gdb(gdb_cmd)
        else:
            self.gdb = Gdb()

        if self.binary:
            self.gdb.command("file %s" % self.binary)
        if self.target:
            self.gdb.command("set arch riscv:rv%d" % self.target.xlen)
            self.gdb.command("set remotetimeout %d" % self.target.timeout_sec)
        if self.server.port:
            self.gdb.command(
                    "target extended-remote localhost:%d" % self.server.port)

        self.gdb.p("$priv=3")

    def classTeardown(self):
        del self.gdb
        BaseTest.classTeardown(self)

class ExamineTarget(GdbTest):
    def test(self):
        self.target.misa = self.gdb.p("$misa")

        txt = "RV"
        if (self.target.misa >> 30) == 1:
            txt += "32"
        elif (self.target.misa >> 62) == 2:
            txt += "64"
        elif (self.target.misa >> 126) == 3:
            txt += "128"
        else:
            txt += "??"

        for i in range(26):
            if self.target.misa & (1<<i):
                txt += chr(i + ord('A'))
        print txt,

class TestFailed(Exception):
    def __init__(self, message):
        Exception.__init__(self)
        self.message = message

class TestNotApplicable(Exception):
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

def assertLess(a, b):
    if not a < b:
        raise TestFailed("%r not less than %r" % (a, b))

def assertTrue(a):
    if not a:
        raise TestFailed("%r is not True" % a)

def assertRegexpMatches(text, regexp):
    if not re.search(regexp, text):
        raise TestFailed("can't find %r in %r" % (regexp, text))
