#*****************************************************************************
# auipc.S
#-----------------------------------------------------------------------------
#
# Test auipc instruction.
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV64U
RVTEST_CODE_BEGIN

  TEST_CASE(2, a0, 1<<12, \
    .align 3; \
    auipc a0, 0x00001; \
    jal a1, 1f; \
    1: srl a1, a1, 12; \
    sll a1, a1, 12; \
    sub a0, a0, a1; \
  )

  TEST_CASE(3, a0, -1<<12, \
    .align 3; \
    auipc a0, 0xfffff; \
    jal a1, 1f; \
    1: srl a1, a1, 12; \
    sll a1, a1, 12; \
    sub a0, a0, a1; \
  )

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END
