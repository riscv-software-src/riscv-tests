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

test_4:
    li TESTNUM, 4

    # Restore sp to initial value
    mv sp, x5                # sp = initial sp

    # Set ra, s0, s1 to known values
    li x1,  0x11111111  # ra (x1)
    li x5,  0x88888888  # s0 (x8)
    li x6,  0x99999999  # s1 (x9)
    li x7,  0xAAAAAAAA  # s2 (x10)
    li x10, 0xBBBBBBBB  # s3 (x11)
    li x11, 0xCCCCCCCC  # s4 (x12)
    li x12, 0xDDDDDDDD  # s5 (x13)
    li x13, 0xEEEEEEEE  # s6 (x14)
    li x14, 0xFFFFFFFF  # s7 (x15)
    li x15, 0x00000000  # s8 (x16)
    li x16, 0x11111111  # s9 (x17)
    li x17, 0x22222222  # s10 (x18)
    li x28, 0x33333333  # s11 (x19)

    # Record initial sp
    mv x5, sp                # x5 = initial sp

    cm.push {ra, s0-s11}, -64

    # Calculate expected sp
    li x6, 64
    sub x7, x5, x6

    # Check sp
    bne sp, x7, fail

    lw x11, 60(sp)
    bne x11, x28, fail

    lw x11, 56(sp)
    bne x11, x17, fail

    lw x11, 52(sp)
    bne x11, x16, fail

    lw x11, 48(sp)
    bne x11, x15, fail

    lw x11, 44(sp)
    bne x11, x14, fail

    lw x11, 40(sp)
    bne x11, x13, fail

    lw x11, 36(sp)
    bne x11, x12, fail

    lw x11, 32(sp)
    bne x11, x11, fail

    lw x11, 28(sp)
    bne x11, x10, fail

    lw x11, 24(sp)
    bne x11, x7, fail

    lw x11, 20(sp)
    bne x11, x6, fail

    lw x11, 16(sp)
    bne x11, x5, fail

    lw x11, 12(sp)
    bne x11, x1, fail

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
