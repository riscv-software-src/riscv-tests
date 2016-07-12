# See LICENSE for license details.

#*****************************************************************************
# fcmp.S
#-----------------------------------------------------------------------------
#
# Test f{eq|lt|le}.d instructions.
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV64UF
RVTEST_CODE_BEGIN

  #-------------------------------------------------------------
  # Arithmetic tests
  #-------------------------------------------------------------

  TEST_FP_CMP_OP_D( 2, feq.d, 1, -1.36, -1.36)
  TEST_FP_CMP_OP_D( 3, fle.d, 1, -1.36, -1.36)
  TEST_FP_CMP_OP_D( 4, flt.d, 0, -1.36, -1.36)

  TEST_FP_CMP_OP_D( 5, feq.d, 0, -1.37, -1.36)
  TEST_FP_CMP_OP_D( 6, fle.d, 1, -1.37, -1.36)
  TEST_FP_CMP_OP_D( 7, flt.d, 1, -1.37, -1.36)

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END
