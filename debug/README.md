Debug Tests
===========

Debugging requires many system components to all work together. The tests here
perform an end-to-end test, communicating only with gdb. If a simulator or
hardware passes all these tests, then you can be pretty confident that the
actual debug interface is functioning correctly.

Targets
=======

64-bit Spike
------------

`./gdbserver.py --spike64 --cmd $RISCV/bin/spike`

32-bit Spike
------------

`./gdbserver.py --spike32 --cmd $RISCV/bin/spike`

32-bit SiFive Core on Supported FPGA Boards &  Hardware
-------------------------------------

`./gdbserver.py --freedom-e300`

32-bit rocket-chip core in Simulation
-------------------------------------

`./gdbserver.py --freedom-e300-sim`


Debug Tips
==========

You can run just a single test by specifying <class>.<function> on the command
line, eg: `./gdbserver.py --spike64 --cmd $RISCV/bin/spike
SimpleRegisterTest.test_s0`.
Once that test has failed, you can look at gdb.log and (in this case) spike.log
to get an idea of what might have gone wrong.

You can see what spike is doing by add `-l` to the spike command, eg.:
`./gdbserver.py --spike32 --cmd "$RISCV/bin/spike -l"
DebugTest.test_breakpoint`. (Then look at spike.log.)

You can run gdb under valgrind by passing --gdb, eg.: `./gdbserver.py --spike64
--gdb "valgrind riscv64-unknown-elf-gdb" -- -v DownloadTest`.
