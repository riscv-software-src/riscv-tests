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
    sub x7, x5, x6           # x7 = x5 - 64

    # Check sp
    bne sp, x7, fail

    # Load ra from [sp]
    ld x11, 40(sp)            # x11 = [sp] (ra)
    bne x11, x9, fail

    # Load s0 from [sp + 8]
    ld x12, 32(sp)            # x12 = [sp + 8] (s0)
    bne x12, x8, fail

    # Load s1 from [sp + 16]
    ld x13, 24(sp)           # x13 = [sp + 16] (s1)
    bne x13, x1, fail

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
