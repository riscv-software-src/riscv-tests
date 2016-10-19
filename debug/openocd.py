#!/usr/bin/env python

"""Test that OpenOCD can talk to a RISC-V target."""

import argparse
import sys

import targets
import testlib
from testlib import assertRegexpMatches

class OpenOcdTest(testlib.BaseTest):
    def __init__(self, target):
        testlib.BaseTest.__init__(self, target)
        self.gdb = None

    def early_applicable(self):
        return self.target.openocd_config

    def setup(self):
        # pylint: disable=attribute-defined-outside-init
        self.cli = testlib.OpenocdCli()

class RegTest(OpenOcdTest):
    def test(self):
        self.cli.command("halt")
        output = self.cli.command("reg")
        assertRegexpMatches(output, r"x18 \(/%d\): 0x[0-9A-F]+" %
                self.target.xlen)

def main():
    parser = argparse.ArgumentParser(
            description="Test that OpenOCD can talk to a RISC-V target.")
    targets.add_target_options(parser)
    testlib.add_test_run_options(parser)

    parsed = parser.parse_args()

    target = parsed.target(parsed.cmd, parsed.run, parsed.isolate)
    if parsed.xlen:
        target.xlen = parsed.xlen

    module = sys.modules[__name__]

    return testlib.run_all_tests(module, target, parsed.test, parsed.fail_fast)

if __name__ == '__main__':
    sys.exit(main())
