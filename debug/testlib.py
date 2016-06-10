import os.path
import pexpect
import shlex
import subprocess
import tempfile
import testlib
import unittest

# Note that gdb comes with its own testsuite. I was unable to figure out how to
# run that testsuite against the spike simulator.

def find_file(path):
    for directory in (os.getcwd(), os.path.dirname(testlib.__file__)):
        fullpath = os.path.join(directory, path)
        if os.path.exists(fullpath):
            return fullpath
    return None

def compile(args, xlen=32):
    """Compile a single .c file into a binary."""
    dst = os.path.splitext(args[0])[0]
    cc = os.path.expandvars("$RISCV/bin/riscv%d-unknown-elf-gcc" % xlen)
    cmd = [cc, "-g", "-o", dst]
    for arg in args:
        found = find_file(arg)
        if found:
            cmd.append(found)
        else:
            cmd.append(arg)
    cmd = " ".join(cmd)
    result = os.system(cmd)
    assert result == 0, "%r failed" % cmd
    return dst

def unused_port():
    # http://stackoverflow.com/questions/2838244/get-open-tcp-port-in-python/2838309#2838309
    import socket
    s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    s.bind(("",0))
    port = s.getsockname()[1]
    s.close()
    return port

class Spike(object):
    def __init__(self, cmd, binary=None, halted=False, with_gdb=True, timeout=None,
            xlen=64):
        """Launch spike. Return tuple of its process and the port it's running on."""
        if cmd:
            cmd = shlex.split(cmd)
        else:
            cmd = ["spike"]
        if (xlen == 32):
            cmd += ["--isa", "RV32"]

        if timeout:
            cmd = ["timeout", str(timeout)] + cmd

        if halted:
            cmd.append('-H')
        if with_gdb:
            self.port = unused_port()
            cmd += ['--gdb-port', str(self.port)]
        cmd.append('pk')
        if binary:
            cmd.append(binary)
        logfile = open("spike.log", "w")
        logfile.write("+ %s\n" % " ".join(cmd))
        self.process = subprocess.Popen(cmd, stdin=subprocess.PIPE, stdout=logfile,
                stderr=logfile)

    def __del__(self):
        try:
            self.process.kill()
            self.process.wait()
        except OSError:
            pass

    def wait(self, *args, **kwargs):
        return self.process.wait(*args, **kwargs)

class Openocd(object):
    def __init__(self, cmd=None, config=None, debug=True):
        if cmd:
            cmd = shlex.split(cmd)
        else:
            cmd = ["openocd"]
        if config:
            cmd += ["-f", find_file(config)]
        if debug:
            cmd.append("-d")
        logfile = open("openocd.log", "w")
        self.process = subprocess.Popen(cmd, stdin=subprocess.PIPE, stdout=logfile,
                stderr=logfile)
        # TODO: Pick a random port
        self.port = 3333

    def __del__(self):
        try:
            self.process.kill()
            self.process.wait()
        except OSError:
            pass

class Gdb(object):
    def __init__(self):
        path = os.path.expandvars("$RISCV/bin/riscv64-unknown-elf-gdb")
        self.child = pexpect.spawn(path)
        self.child.logfile = file("gdb.log", "w")
        self.wait()
        self.command("set confirm off")
        self.command("set width 0")
        self.command("set height 0")
        # Force consistency.
        self.command("set print entry-values no")

    def wait(self):
        """Wait for prompt."""
        self.child.expect("\(gdb\)")

    def command(self, command, timeout=-1):
        self.child.sendline(command)
        self.child.expect("\n", timeout=timeout)
        self.child.expect("\(gdb\)", timeout=timeout)
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
        self.child.send("\003");
        self.child.expect("\(gdb\)")
        return self.child.before.strip()

    def x(self, address, size='w'):
        output = self.command("x/%s %s" % (size, address))
        value = int(output.split(':')[1].strip(), 0)
        return value

    def p(self, obj):
        output = self.command("p/x %s" % obj)
        value = int(output.split('=')[-1].strip(), 0)
        return value

    def stepi(self):
        output = self.command("stepi")
        assert "Cannot" not in output
        return output

    def load(self):
        output = self.command("load")
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
        assert "Breakpoint" in output
        return output
