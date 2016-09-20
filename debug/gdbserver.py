#!/usr/bin/env python

import argparse
import binascii
import os
import random
import re
import sys
import tempfile
import time
import traceback

import testlib

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

# pylint: disable=abstract-method

def gdb(
        target=None,
        port=None,
        binary=None
        ):

    g = None
    if parsed.gdb:
        g = testlib.Gdb(parsed.gdb)
    else:
        g = testlib.Gdb()

    if binary:
        g.command("file %s" % binary)
    if target:
        g.command("set arch riscv:rv%d" % target.xlen)
        g.command("set remotetimeout %d" % target.timeout_sec)
    if port:
        g.command("target extended-remote localhost:%d" % port)

    g.p("$priv=3")

    return g

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

def readable_binary_string(s):
    return "".join("%02x" % ord(c) for c in s)

def header(title):
    dashes = '-' * (36 - len(title))
    before = dashes[:len(dashes)/2]
    after = dashes[len(dashes)/2:]
    print "%s[ %s ]%s" % (before, title, after)

class GdbTest(object):
    compiled = {}

    def __init__(self, target):
        self.target = target
        self.server = None
        self.binary = None
        self.gdb = None

    def setUp(self):
        pass

    def run(self):
        """
        If compile_args is set, compile a program and set self.binary.

        Call setUp().

        Then call test() and return the result, displaying relevant information
        if an exception is raised.
        """
        self.server = self.target.server()

        print "Running", type(self).__name__, "...",
        sys.stdout.flush()

        start = time.time()

        compile_args = getattr(self, 'compile_args', None)
        if compile_args:
            if compile_args not in GdbTest.compiled:
                try:
                    # pylint: disable=star-args
                    GdbTest.compiled[compile_args] = \
                            self.target.compile(*compile_args)
                except Exception: # pylint: disable=broad-except
                    print "exception while compiling in %.2fs" % (
                            time.time() - start)
                    print "=" * 40
                    header("Traceback")
                    traceback.print_exc(file=sys.stdout)
                    print "/" * 40
                    return "exception"
        self.binary = GdbTest.compiled.get(compile_args)

        self.gdb = gdb(self.target, self.server.port, self.binary)

        try:
            self.setUp()
            result = self.test()    # pylint: disable=no-member
        except Exception as e: # pylint: disable=broad-except
            if isinstance(e, TestFailed):
                result = "fail"
            else:
                result = "exception"
            print "%s in %.2fs" % (result, time.time() - start)
            print "=" * 40
            if isinstance(e, TestFailed):
                header("Message")
                print e.message
            header("Traceback")
            traceback.print_exc(file=sys.stdout)
            header("gdb.log")
            print open("gdb.log", "r").read()
            header(self.server.logname)
            print open(self.server.logname, "r").read()
            print "/" * 40
            return result

        finally:
            del self.server
            del self.gdb

        if not result:
            result = 'pass'
        print "%s in %.2fs" % (result, time.time() - start)
        return result

class TestFailed(Exception):
    def __init__(self, message):
        Exception.__init__(self)
        self.message = message

def run_all_tests(target, tests):
    results = {}
    module = sys.modules[__name__]
    for name in dir(module):
        definition = getattr(module, name)
        if type(definition) == type and hasattr(definition, 'test') and \
                (not tests or any(test in name for test in tests)):
            instance = definition(target)
            result = instance.run()
            results.setdefault(result, []).append(name)

    print ":" * 40

    good_results = set(('pass', 'not_applicable'))

    result = 0
    for key, value in results.iteritems():
        print "%d tests returned %s" % (len(value), key)
        if key not in good_results:
            result = 1
            for test in value:
                print "   ", test

    return result

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

class SimpleRegisterTest(GdbTest):
    def check_reg(self, name):
        a = random.randrange(1<<self.target.xlen)
        b = random.randrange(1<<self.target.xlen)
        self.gdb.p("$%s=0x%x" % (name, a))
        self.gdb.stepi()
        assertEqual(self.gdb.p("$%s" % name), a)
        self.gdb.p("$%s=0x%x" % (name, b))
        self.gdb.stepi()
        assertEqual(self.gdb.p("$%s" % name), b)

    def setUp(self):
        # 0x13 is nop
        self.gdb.command("p *((int*) 0x%x)=0x13" % self.target.ram)
        self.gdb.command("p *((int*) 0x%x)=0x13" % (self.target.ram + 4))
        self.gdb.command("p *((int*) 0x%x)=0x13" % (self.target.ram + 8))
        self.gdb.p("$pc=0x%x" % self.target.ram)

class SimpleS0Test(SimpleRegisterTest):
    def test(self):
        self.check_reg("s0")

class SimpleS1Test(SimpleRegisterTest):
    def test(self):
        self.check_reg("s1")

class SimpleT0Test(SimpleRegisterTest):
    def test(self):
        self.check_reg("t0")

class SimpleT1Test(SimpleRegisterTest):
    def test(self):
        self.check_reg("t1")

class SimpleMemoryTest(GdbTest):
    def access_test(self, size, data_type):
        assertEqual(self.gdb.p("sizeof(%s)" % data_type), size)
        a = 0x86753095555aaaa & ((1<<(size*8))-1)
        b = 0xdeadbeef12345678 & ((1<<(size*8))-1)
        self.gdb.p("*((%s*)0x%x) = 0x%x" % (data_type, self.target.ram, a))
        self.gdb.p("*((%s*)0x%x) = 0x%x" % (data_type, self.target.ram + size,
            b))
        assertEqual(self.gdb.p("*((%s*)0x%x)" % (data_type, self.target.ram)),
                a)
        assertEqual(self.gdb.p("*((%s*)0x%x)" % (
            data_type, self.target.ram + size)), b)

class MemTest8(SimpleMemoryTest):
    def test(self):
        self.access_test(1, 'char')

class MemTest16(SimpleMemoryTest):
    def test(self):
        self.access_test(2, 'short')

class MemTest32(SimpleMemoryTest):
    def test(self):
        self.access_test(4, 'int')

class MemTest64(SimpleMemoryTest):
    def test(self):
        self.access_test(8, 'long long')

class MemTestBlock(GdbTest):
    def test(self):
        length = 1024
        line_length = 16
        a = tempfile.NamedTemporaryFile(suffix=".ihex")
        data = ""
        for i in range(length / line_length):
            line_data = "".join(["%c" % random.randrange(256)
                for _ in range(line_length)])
            data += line_data
            a.write(ihex_line(i * line_length, 0, line_data))
        a.flush()

        self.gdb.command("restore %s 0x%x" % (a.name, self.target.ram))
        for offset in range(0, length, 19*4) + [length-4]:
            value = self.gdb.p("*((int*)0x%x)" % (self.target.ram + offset))
            written = ord(data[offset]) | \
                    (ord(data[offset+1]) << 8) | \
                    (ord(data[offset+2]) << 16) | \
                    (ord(data[offset+3]) << 24)
            assertEqual(value, written)

        b = tempfile.NamedTemporaryFile(suffix=".ihex")
        self.gdb.command("dump ihex memory %s 0x%x 0x%x" % (b.name,
            self.target.ram, self.target.ram + length))
        for line in b:
            record_type, address, line_data = ihex_parse(line)
            if record_type == 0:
                assertEqual(readable_binary_string(line_data),
                        readable_binary_string(
                            data[address:address+len(line_data)]))

class InstantHaltTest(GdbTest):
    def test(self):
        assertEqual(self.target.reset_vector, self.gdb.p("$pc"))
        # mcycle and minstret have no defined reset value.
        mstatus = self.gdb.p("$mstatus")
        assertEqual(mstatus & (MSTATUS_MIE | MSTATUS_MPRV |
            MSTATUS_VM), 0)

class InstantChangePc(GdbTest):
    def test(self):
        """Change the PC right as we come out of reset."""
        # 0x13 is nop
        self.gdb.command("p *((int*) 0x%x)=0x13" % self.target.ram)
        self.gdb.command("p *((int*) 0x%x)=0x13" % (self.target.ram + 4))
        self.gdb.command("p *((int*) 0x%x)=0x13" % (self.target.ram + 8))
        self.gdb.p("$pc=0x%x" % self.target.ram)
        self.gdb.stepi()
        assertEqual((self.target.ram + 4), self.gdb.p("$pc"))
        self.gdb.stepi()
        assertEqual((self.target.ram + 8), self.gdb.p("$pc"))

class DebugTest(GdbTest):
    # Include malloc so that gdb can make function calls. I suspect this malloc
    # will silently blow through the memory set aside for it, so be careful.
    compile_args = ("programs/debug.c", "programs/checksum.c",
            "programs/tiny-malloc.c", "-DDEFINE_MALLOC", "-DDEFINE_FREE")

    def setUp(self):
        self.gdb.load()
        self.gdb.b("_exit")

    def exit(self, expected_result=0xc86455d4):
        output = self.gdb.c()
        assertIn("Breakpoint", output)
        assertIn("_exit", output)
        assertEqual(self.gdb.p("status"), expected_result)

class DebugFunctionCall(DebugTest):
    def test(self):
        self.gdb.b("main:start")
        self.gdb.c()
        assertEqual(self.gdb.p('fib(6)'), 8)
        assertEqual(self.gdb.p('fib(7)'), 13)
        self.exit()

class DebugChangeString(DebugTest):
    def test(self):
        text = "This little piggy went to the market."
        self.gdb.b("main:start")
        self.gdb.c()
        self.gdb.p('fox = "%s"' % text)
        self.exit(0x43b497b8)

class DebugTurbostep(DebugTest):
    def test(self):
        """Single step a bunch of times."""
        self.gdb.b("main:start")
        self.gdb.c()
        self.gdb.command("p i=0")
        last_pc = None
        advances = 0
        jumps = 0
        for _ in range(100):
            self.gdb.stepi()
            pc = self.gdb.p("$pc")
            assertNotEqual(last_pc, pc)
            if last_pc and pc > last_pc and pc - last_pc <= 4:
                advances += 1
            else:
                jumps += 1
            last_pc = pc
        # Some basic sanity that we're not running between breakpoints or
        # something.
        assertGreater(jumps, 10)
        assertGreater(advances, 50)

class DebugExit(DebugTest):
    def test(self):
        self.exit()

class DebugSymbols(DebugTest):
    def test(self):
        self.gdb.b("main")
        self.gdb.b("rot13")
        output = self.gdb.c()
        assertIn(", main ", output)
        output = self.gdb.c()
        assertIn(", rot13 ", output)

class DebugBreakpoint(DebugTest):
    def test(self):
        self.gdb.b("rot13")
        # The breakpoint should be hit exactly 2 times.
        for _ in range(2):
            output = self.gdb.c()
            self.gdb.p("$pc")
            assertIn("Breakpoint ", output)
            assertIn("rot13 ", output)
        self.exit()

class Hwbp1(DebugTest):
    def test(self):
        if self.target.instruction_hardware_breakpoint_count < 1:
            return 'not_applicable'

        self.gdb.hbreak("rot13")
        # The breakpoint should be hit exactly 2 times.
        for _ in range(2):
            output = self.gdb.c()
            self.gdb.p("$pc")
            assertRegexpMatches(output, r"[bB]reakpoint")
            assertIn("rot13 ", output)
        self.exit()

class Hwbp2(DebugTest):
    def test(self):
        if self.target.instruction_hardware_breakpoint_count < 2:
            return 'not_applicable'

        self.gdb.hbreak("main")
        self.gdb.hbreak("rot13")
        # We should hit 3 breakpoints.
        for expected in ("main", "rot13", "rot13"):
            output = self.gdb.c()
            self.gdb.p("$pc")
            assertRegexpMatches(output, r"[bB]reakpoint")
            assertIn("%s " % expected, output)
        self.exit()

class TooManyHwbp(DebugTest):
    def run(self):
        for i in range(30):
            self.gdb.hbreak("*rot13 + %d" % (i * 4))

        output = self.gdb.c()
        assertIn("Cannot insert hardware breakpoint", output)
        # Clean up, otherwise the hardware breakpoints stay set and future
        # tests may fail.
        self.gdb.command("D")

class Registers(DebugTest):
    def test(self):
        # Get to a point in the code where some registers have actually been
        # used.
        self.gdb.b("rot13")
        self.gdb.c()
        self.gdb.c()
        # Try both forms to test gdb.
        for cmd in ("info all-registers", "info registers all"):
            output = self.gdb.command(cmd)
            assertNotIn("Could not", output)
            for reg in ('zero', 'ra', 'sp', 'gp', 'tp'):
                assertIn(reg, output)

        #TODO
        # mcpuid is one of the few registers that should have the high bit set
        # (for rv64).
        # Leave this commented out until gdb and spike agree on the encoding of
        # mcpuid (which is going to be renamed to misa in any case).
        #assertRegexpMatches(output, ".*mcpuid *0x80")

        #TODO:
        # The instret register should always be changing.
        #last_instret = None
        #for _ in range(5):
        #    instret = self.gdb.p("$instret")
        #    assertNotEqual(instret, last_instret)
        #    last_instret = instret
        #    self.gdb.stepi()

        self.exit()

class UserInterrupt(DebugTest):
    def test(self):
        """Sending gdb ^C while the program is running should cause it to
        halt."""
        self.gdb.b("main:start")
        self.gdb.c()
        self.gdb.p("i=123")
        self.gdb.c(wait=False)
        time.sleep(0.1)
        output = self.gdb.interrupt()
        assert "main" in output
        assertGreater(self.gdb.p("j"), 10)
        self.gdb.p("i=0")
        self.exit()

class StepTest(GdbTest):
    compile_args = ("programs/step.S", )

    def setUp(self):
        self.gdb.load()
        self.gdb.b("main")
        self.gdb.c()

    def test(self):
        main_address = self.gdb.p("$pc")
        for expected in (4, 8, 0xc, 0x10, 0x18, 0x1c, 0x28, 0x20, 0x2c, 0x2c):
            self.gdb.stepi()
            pc = self.gdb.p("$pc")
            assertEqual("%x" % pc, "%x" % (expected + main_address))

class TriggerTest(GdbTest):
    compile_args = ("programs/trigger.S", )
    def setUp(self):
        self.gdb.load()
        self.gdb.b("_exit")
        self.gdb.b("main")
        self.gdb.c()

    def exit(self):
        output = self.gdb.c()
        assertIn("Breakpoint", output)
        assertIn("_exit", output)

class TriggerExecuteInstant(TriggerTest):
    """Test an execute breakpoint on the first instruction executed out of
    debug mode."""
    def test(self):
        main_address = self.gdb.p("$pc")
        self.gdb.command("hbreak *0x%x" % (main_address + 4))
        self.gdb.c()
        assertEqual(self.gdb.p("$pc"), main_address+4)

class TriggerLoadAddress(TriggerTest):
    def test(self):
        self.gdb.command("rwatch *((&data)+1)")
        output = self.gdb.c()
        assertIn("read_loop", output)
        assertEqual(self.gdb.p("$a0"),
                self.gdb.p("(&data)+1"))
        self.exit()

class TriggerLoadAddressInstant(TriggerTest):
    """Test a load address breakpoint on the first instruction executed out of
    debug mode."""
    def test(self):
        self.gdb.command("b just_before_read_loop")
        self.gdb.c()
        read_loop = self.gdb.p("&read_loop")
        self.gdb.command("rwatch data")
        self.gdb.c()
        # Accept hitting the breakpoint before or after the load instruction.
        assertIn(self.gdb.p("$pc"), [read_loop, read_loop + 4])
        assertEqual(self.gdb.p("$a0"), self.gdb.p("&data"))

class TriggerStoreAddress(TriggerTest):
    def test(self):
        self.gdb.command("watch *((&data)+3)")
        output = self.gdb.c()
        assertIn("write_loop", output)
        assertEqual(self.gdb.p("$a0"),
                self.gdb.p("(&data)+3"))
        self.exit()

class TriggerStoreAddressInstant(TriggerTest):
    def test(self):
        """Test a store address breakpoint on the first instruction executed out
        of debug mode."""
        self.gdb.command("b just_before_write_loop")
        self.gdb.c()
        write_loop = self.gdb.p("&write_loop")
        self.gdb.command("watch data")
        self.gdb.c()
        # Accept hitting the breakpoint before or after the store instruction.
        assertIn(self.gdb.p("$pc"), [write_loop, write_loop + 4])
        assertEqual(self.gdb.p("$a0"), self.gdb.p("&data"))

class TriggerDmode(TriggerTest):
    def test(self):
        self.gdb.command("hbreak handle_trap")
        self.gdb.p("$pc=write_valid")
        output = self.gdb.c()
        assertIn("handle_trap", output)
        assertIn("mcause=2", output)
        assertIn("mepc=%d" % self.gdb.p("&write_invalid_illegal"), output)

class RegsTest(GdbTest):
    compile_args = ("programs/regs.S", )
    def setUp(self):
        self.gdb.load()
        self.gdb.b("main")
        self.gdb.b("handle_trap")
        self.gdb.c()

class WriteGprs(RegsTest):
    def test(self):
        regs = [("x%d" % n) for n in range(2, 32)]

        self.gdb.p("$pc=write_regs")
        for i, r in enumerate(regs):
            self.gdb.p("$%s=%d" % (r, (0xdeadbeef<<i)+17))
        self.gdb.p("$x1=data")
        self.gdb.command("b all_done")
        output = self.gdb.c()
        assertIn("Breakpoint ", output)

        # Just to get this data in the log.
        self.gdb.command("x/30gx data")
        self.gdb.command("info registers")
        for n in range(len(regs)):
            assertEqual(self.gdb.x("data+%d" % (8*n), 'g'),
                    ((0xdeadbeef<<n)+17) & ((1<<self.target.xlen)-1))

class WriteCsrs(RegsTest):
    def test(self):
        # As much a test of gdb as of the simulator.
        self.gdb.p("$mscratch=0")
        self.gdb.stepi()
        assertEqual(self.gdb.p("$mscratch"), 0)
        self.gdb.p("$mscratch=123")
        self.gdb.stepi()
        assertEqual(self.gdb.p("$mscratch"), 123)

        self.gdb.command("p $pc=write_regs")
        self.gdb.command("p $a0=data")
        self.gdb.command("b all_done")
        self.gdb.command("c")

        assertEqual(123, self.gdb.p("$mscratch"))
        assertEqual(123, self.gdb.p("$x1"))
        assertEqual(123, self.gdb.p("$csr832"))

class DownloadTest(GdbTest):
    def setUp(self):
        length = min(2**20, self.target.ram_size - 2048)
        download_c = tempfile.NamedTemporaryFile(prefix="download_",
                suffix=".c")
        download_c.write("#include <stdint.h>\n")
        download_c.write(
                "unsigned int crc32a(uint8_t *message, unsigned int size);\n")
        download_c.write("uint32_t length = %d;\n" % length)
        download_c.write("uint8_t d[%d] = {\n" % length)
        self.crc = 0
        for i in range(length / 16):
            download_c.write("  /* 0x%04x */ " % (i * 16))
            for _ in range(16):
                value = random.randrange(1<<8)
                download_c.write("%d, " % value)
                self.crc = binascii.crc32("%c" % value, self.crc)
            download_c.write("\n")
        download_c.write("};\n")
        download_c.write("uint8_t *data = &d[0];\n")
        download_c.write("uint32_t main() { return crc32a(data, length); }\n")
        download_c.flush()

        if self.crc < 0:
            self.crc += 2**32

        self.binary = self.target.compile(download_c.name,
                "programs/checksum.c")
        self.gdb.command("file %s" % self.binary)

    def test(self):
        self.gdb.load()
        self.gdb.command("b _exit")
        self.gdb.c()
        assertEqual(self.gdb.p("status"), self.crc)

class MprvTest(GdbTest):
    compile_args = ("programs/mprv.S", )
    def setUp(self):
        self.gdb.load()

    def test(self):
        """Test that the debugger can access memory when MPRV is set."""
        self.gdb.c(wait=False)
        time.sleep(0.5)
        self.gdb.interrupt()
        output = self.gdb.command("p/x *(int*)(((char*)&data)-0x80000000)")
        assertIn("0xbead", output)

class PrivTest(GdbTest):
    compile_args = ("programs/priv.S", )
    def setUp(self):
        self.gdb.load()

        misa = self.gdb.p("$misa")
        self.supported = set()
        if misa & (1<<20):
            self.supported.add(0)
        if misa & (1<<18):
            self.supported.add(1)
        if misa & (1<<7):
            self.supported.add(2)
        self.supported.add(3)

class PrivRw(PrivTest):
    def test(self):
        """Test reading/writing priv."""
        for privilege in range(4):
            self.gdb.p("$priv=%d" % privilege)
            self.gdb.stepi()
            actual = self.gdb.p("$priv")
            assertIn(actual, self.supported)
            if privilege in self.supported:
                assertEqual(actual, privilege)

class PrivChange(PrivTest):
    def test(self):
        """Test that the core's privilege level actually changes."""

        if 0 not in self.supported:
            return 'not_applicable'

        self.gdb.b("main")
        self.gdb.c()

        # Machine mode
        self.gdb.p("$priv=3")
        main_address = self.gdb.p("$pc")
        self.gdb.stepi()
        assertEqual("%x" % self.gdb.p("$pc"), "%x" % (main_address+4))

        # User mode
        self.gdb.p("$priv=0")
        self.gdb.stepi()
        # Should have taken an exception, so be nowhere near main.
        pc = self.gdb.p("$pc")
        assertTrue(pc < main_address or pc > main_address + 0x100)

class Target(object):
    name = "name"
    xlen = 0
    directory = None
    timeout_sec = 2
    temporary_files = []
    temporary_binary = None

    def server(self):
        raise NotImplementedError

    def compile(self, *sources):
        binary_name = "%s_%s-%d" % (
                self.name,
                os.path.basename(os.path.splitext(sources[0])[0]),
                self.xlen)
        if parsed.isolate:
            self.temporary_binary = tempfile.NamedTemporaryFile(
                    prefix=binary_name + "_")
            binary_name = self.temporary_binary.name
            Target.temporary_files.append(self.temporary_binary)
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
    instruction_hardware_breakpoint_count = 4
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

class FreedomE300SimTarget(Target):
    name = "freedom-e300-sim"
    xlen = 32
    timeout_sec = 240
    ram = 0x80000000
    ram_size = 256 * 1024 * 1024
    instruction_hardware_breakpoint_count = 2

    def server(self):
        sim = testlib.VcsSim(simv=parsed.run, debug=False)
        openocd = testlib.Openocd(cmd=parsed.cmd,
                            config="targets/%s/openocd.cfg" % self.name,
                            otherProcess=sim)
        time.sleep(20)
        return openocd

class FreedomU500Target(Target):
    name = "freedom-u500"
    xlen = 64
    ram = 0x80000000
    ram_size = 16 * 1024
    instruction_hardware_breakpoint_count = 2

    def server(self):
        return testlib.Openocd(cmd=parsed.cmd,
                config="targets/%s/openocd.cfg" % self.name)

class FreedomU500SimTarget(Target):
    name = "freedom-u500-sim"
    xlen = 64
    timeout_sec = 240
    ram = 0x80000000
    ram_size = 256 * 1024 * 1024
    instruction_hardware_breakpoint_count = 2

    def server(self):
        sim = testlib.VcsSim(simv=parsed.run, debug=False)
        openocd = testlib.Openocd(cmd=parsed.cmd,
                            config="targets/%s/openocd.cfg" % self.name,
                            otherProcess=sim)
        time.sleep(20)
        return openocd

targets = [
        Spike32Target,
        Spike64Target,
        FreedomE300Target,
        FreedomU500Target,
        FreedomE300SimTarget,
        FreedomU500SimTarget]

parsed = None
def main():
    parser = argparse.ArgumentParser(
            epilog="""
            Example command line from the real world:
            Run all RegsTest cases against a physical FPGA, with custom openocd command:
            ./gdbserver.py --freedom-e300 --cmd "$HOME/SiFive/openocd/src/openocd -s $HOME/SiFive/openocd/tcl -d" RegsTest
            """)
    group = parser.add_mutually_exclusive_group(required=True)
    for t in targets:
        group.add_argument("--%s" % t.name, action="store_const", const=t,
                dest="target")
    parser.add_argument("--run",
            help="The command to use to start the actual target (e.g. "
            "simulation)")
    parser.add_argument("--cmd",
            help="The command to use to start the debug server.")
    parser.add_argument("--gdb",
            help="The command to use to start gdb.")

    xlen_group = parser.add_mutually_exclusive_group()
    xlen_group.add_argument("--32", action="store_const", const=32, dest="xlen",
            help="Force the target to be 32-bit.")
    xlen_group.add_argument("--64", action="store_const", const=64, dest="xlen",
            help="Force the target to be 64-bit.")

    parser.add_argument("--isolate", action="store_true",
            help="Try to run in such a way that multiple instances can run at "
            "the same time. This may make it harder to debug a failure if it "
            "does occur.")

    parser.add_argument("test", nargs='*',
            help="Run only tests that are named here.")

    # TODO: remove global
    global parsed   # pylint: disable=global-statement
    parsed = parser.parse_args()

    target = parsed.target()
    if parsed.xlen:
        target.xlen = parsed.xlen

    return run_all_tests(target, parsed.test)

# TROUBLESHOOTING TIPS
# If a particular test fails, run just that one test, eg.:
# ./gdbserver.py MprvTest.test_mprv
# Then inspect gdb.log and spike.log to see what happened in more detail.

if __name__ == '__main__':
    sys.exit(main())
