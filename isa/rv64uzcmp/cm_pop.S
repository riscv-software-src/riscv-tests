#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV64U
RVTEST_CODE_BEGIN

test_1:
    li TESTNUM, 1

    # Set initial sp
    la sp, tdat_end          # Point sp to end of tdat

    # Prepare data to be pushed
    li x1, 0x123456789ABCDEF0  # Value for ra
    li x8, 0x8888888888888888  # Value for s0
    li x9, 0x9999999999999999  # Value for s1

    li x12, 0x123456789ABCDEF0  # Value for ra
    li x13, 0x8888888888888888  # Value for s0
    li x14, 0x9999999999999999  # Value for s1

    mv x15, sp                # x15 = initial sp

    # Push values onto the stack
    cm.push {ra, s0-s1}, -48

    li x1, 0x0
    li x8, 0x0
    li x9, 0x0

    # Now let's pop values back
    cm.pop {ra, s0-s1}, 48

    # Verify values after pop
    bne sp, x15, fail         # Check sp
    bne x1, x12, fail         # Check ra
    bne x8, x13, fail         # Check s0
    bne x9, x14, fail         # Check s1

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
