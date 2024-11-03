#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV64U
RVTEST_CODE_BEGIN

    # Test cm.push {ra}, -32
test_1:
    li TESTNUM, 1

    # Set initial sp
    la sp, tdat_end          # Point sp to end of tdat

    # Set ra to a known 64-bit value
    li x1, 0x123456789ABCDEF0  # ra (x1)

    # Record initial sp
    mv x5, sp                # x5 = initial sp

    # Execute cm.push {ra}, -32
    cm.push {ra}, -16

    # Calculate expected sp
    li x6, 16
    sub x7, x5, x6           # x7 = x5 - 32

    # Check sp
    bne sp, x7, fail

    # Load ra from [sp]
    ld x8, 8(sp)             # x8 = [sp] (ra)

    # Check ra value
    bne x8, x1, fail

    # Test cm.push {ra, s0}, -48
test_2:
    li TESTNUM, 2

    # Restore sp to initial value
    mv sp, x5                # sp = initial sp

    # Set ra and s0 to known 64-bit values
    li x1, 0x1111111111111111  # ra (x1)
    li x8, 0x8888888888888888  # s0 (x8)

    # Record initial sp
    mv x5, sp                # x5 = initial sp

    # Execute cm.push {ra, s0}, -48
    cm.push {ra, s0}, -16

    # Calculate expected sp
    li x6, 16
    sub x7, x5, x6           # x7 = x5 - 48

    # Check sp
    bne sp, x7, fail

    # Load ra from [sp]
    ld x9, 8(sp)             # x9 = [sp] (ra)
    bne x9, x8, fail

    # Load s0 from [sp + 8]
    ld x10, 0(sp)            # x10 = [sp + 8] (s0)
    bne x10, x1, fail

    # Test cm.push {ra, s0-s1}, -64
test_3:
    li TESTNUM, 3

    # Restore sp to initial value
    mv sp, x5                # sp = initial sp

    # Set ra, s0, s1 to known 64-bit values
    li x1, 0x1111111111111111  # ra (x1)
    li x8, 0x8888888888888888  # s0 (x8)
    li x9, 0x9999999999999999  # s1 (x9)

    # Record initial sp
    mv x5, sp                # x5 = initial sp

    # Execute cm.push {ra, s0-s1}, -64
    cm.push {ra, s0-s1}, -48

    # Calculate expected sp
    li x6, 48
    sub x7, x5, x6

    # Check sp
    bne sp, x7, fail

    # Load ra from [sp]
    ld x11, 40(sp)
    bne x11, x9, fail

    # Load s0 from [sp + 8]
    ld x12, 32(sp)
    bne x12, x8, fail

    # Load s1 from [sp + 16]
    ld x13, 24(sp)
    bne x13, x1, fail

test_4:
    li TESTNUM, 4

    # Restore sp to initial value
    mv sp, x5                # sp = initial sp

    # Set ra, s0, s1 to known 64-bit values
    li x1, 0x1111111111111111  # ra (x1)
    li x8, 0x8888888888888888  # s0 (x8)
    li x9, 0x9999999999999999  # s1 (x9)
    li x18, 0xAAAAAAAAAAAAAAA0  # s2 (x10)
    li x19, 0xBBBBBBBBBBBBBBB0  # s3 (x11)
    li x20, 0xCCCCCCCCCCCCCCC0  # s4 (x12)
    li x21, 0xDDDDDDDDDDDDDDD0  # s5 (x13)
    li x22, 0xEEEEEEEEEEEEEEE0  # s6 (x14)
    li x23, 0xFFFFFFFFFFFFFFF0  # s7 (x15)
    li x24, 0x0000000000000000  # s8 (x16)
    li x25, 0x1111111111111110  # s9 (x17)
    li x26, 0x2222222222222220  # s10 (x18)
    li x27, 0x3333333333333330  # s11 (x19)

    # Record initial sp
    mv x5, sp

    cm.push {ra, s0-s11}, -128

    # Calculate expected sp
    li x6, 128
    sub x7, x5, x6

    # Check sp
    bne sp, x7, fail

    ld x11, 120(sp)
    bne x11, x27, fail

    ld x11, 112(sp)
    bne x11, x26, fail

    ld x11, 104(sp)
    bne x11, x25, fail

    ld x11, 96(sp)
    bne x11, x24, fail

    ld x11, 88(sp)
    bne x11, x23, fail

    ld x11, 80(sp)
    bne x11, x22, fail

    ld x11, 72(sp)
    bne x11, x21, fail

    ld x11, 64(sp)
    bne x11, x20, fail

    ld x11, 56(sp)
    bne x11, x19, fail

    ld x11, 48(sp)
    bne x11, x18, fail

    ld x11, 40(sp)
    bne x11, x9, fail

    ld x11, 32(sp)
    bne x11, x8, fail

    ld x11, 24(sp)
    bne x11, x1, fail

    # All tests passed
    RVTEST_PASS

fail:
    RVTEST_FAIL

RVTEST_CODE_END

    .data
RVTEST_DATA_BEGIN

    .align 8
tdat:
    .space 256               # Reserve 256 bytes
tdat_end:

RVTEST_DATA_END
