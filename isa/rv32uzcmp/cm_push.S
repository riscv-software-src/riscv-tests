#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV32U
RVTEST_CODE_BEGIN

    # Test cm.push {ra}, -16
test_1:
    li TESTNUM, 1

    # Set initial sp
    la sp, tdat_end          # Point sp to end of tdat

    # Set ra to a known value
    li x1, 0x12345678        # ra (x1)

    # Record initial sp
    mv x5, sp                # x5 = initial sp

    # Execute cm.push {ra}, -16
    cm.push {ra}, -16

    # Calculate expected sp
    li x6, 16
    sub x7, x5, x6           # x7 = x5 - 16

    # Check sp
    bne sp, x7, fail

    # Load ra from [sp + 12] (since ra is stored at the top of the stack frame)
    lw x8, 12(sp)            # x8 = [sp + 12] (ra)

    # Check ra value
    bne x8, x1, fail

    # Test cm.push {ra, s0}, -32
test_2:
    li TESTNUM, 2

    # Restore sp to initial value
    mv sp, x5                # sp = initial sp

    # Set ra and s0 to known values
    li x1, 0x11111111        # ra (x1)
    li x8, 0x88888888        # s0 (x8)

    # Record initial sp
    mv x5, sp                # x5 = initial sp

    # Execute cm.push {ra, s0}, -32
    cm.push {ra, s0}, -32

    # Calculate expected sp
    li x6, 32
    sub x7, x5, x6           # x7 = x5 - 32

    # Check sp
    bne sp, x7, fail

    # Load ra from [sp + 28]
    lw x9, 28(sp)            # x9 = [sp + 28] (ra)
    bne x9, x8, fail

    # Load s0 from [sp + 24]
    lw x10, 24(sp)           # x10 = [sp + 24] (s0)
    bne x10, x1, fail

    # Test cm.push {ra, s0-s1}, -48
test_3:
    li TESTNUM, 3

    # Restore sp to initial value
    mv sp, x5                # sp = initial sp

    # Set ra, s0, s1 to known values
    li x1, 0x11111111        # ra (x1)
    li x8, 0x88888888        # s0 (x8)
    li x9, 0x99999999        # s1 (x9)

    # Record initial sp
    mv x5, sp                # x5 = initial sp

    # Execute cm.push {ra, s0-s1}, -48
    cm.push {ra, s0-s1}, -48

    # Calculate expected sp
    li x6, 48
    sub x7, x5, x6           # x7 = x5 - 48

    # Check sp
    bne sp, x7, fail

    # Load ra from [sp + 44]
    lw x11, 44(sp)           # x11 = [sp + 44] (ra)
    bne x11, x9, fail

    # Load s0 from [sp + 40]
    lw x12, 40(sp)           # x12 = [sp + 40] (s0)
    bne x12, x8, fail

    # Load s1 from [sp + 36]
    lw x13, 36(sp)           # x13 = [sp + 36] (s1)
    bne x13, x1, fail

    # All tests passed
    RVTEST_PASS

fail:
    RVTEST_FAIL

RVTEST_CODE_END

    .data
RVTEST_DATA_BEGIN

    .align 4
tdat:
    .space 256               # Reserve 256 bytes
tdat_end:

RVTEST_DATA_END
