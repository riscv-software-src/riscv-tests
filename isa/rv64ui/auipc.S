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

  TEST_CASE(2, a0, -4096+8, \
    auipc a0, 0x00001; \
    jal 1f; \
    1: sub a0, ra, a0; \
  )

  TEST_CASE(3, a0, 4096+8, \
    auipc a0, 0xfffff; \
    jal 1f; \
    1: sub a0, ra, a0; \
  )

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END
