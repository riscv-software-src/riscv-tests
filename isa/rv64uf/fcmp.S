# See LICENSE for license details.

#*****************************************************************************
# fcmp.S
#-----------------------------------------------------------------------------
#
# Test f{eq|lt|le}.{s|d} instructions.
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV64UF
RVTEST_CODE_BEGIN

  #-------------------------------------------------------------
  # Arithmetic tests
  #-------------------------------------------------------------

  TEST_FP_CMP_OP_S( 2, feq.s, 1, -1.36, -1.36)
  TEST_FP_CMP_OP_S( 3, fle.s, 1, -1.36, -1.36)
  TEST_FP_CMP_OP_S( 4, flt.s, 0, -1.36, -1.36)

  TEST_FP_CMP_OP_S( 5, feq.s, 0, -1.37, -1.36)
  TEST_FP_CMP_OP_S( 6, fle.s, 1, -1.37, -1.36)
  TEST_FP_CMP_OP_S( 7, flt.s, 1, -1.37, -1.36)

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END
