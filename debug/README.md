Debugging requires many of a system components to all work together.  The goal
is to collect some tests that test gdb with spike, and gdb talking to real
hardware through openocd.

Debug Tips

You can run just a single test by specifying <class>.<function> on the command
line, eg: `./gdbserver.py --spike --cmd $RISCV/bin/spike
SimpleRegisterTest.test_s0`.
Once that test has failed, you can look at gdb.log and (in this case) spike.log
to get an idea of what might have gone wrong.

You can see what spike is doing by add `-l` to the spike command, eg.:
`./gdbserver.py --spike32 --cmd "$RISCV/bin/spike -l"
DebugTest.test_breakpoint`. (Then look at spike.log.)
