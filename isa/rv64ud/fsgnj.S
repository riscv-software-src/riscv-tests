# See LICENSE for license details.

#*****************************************************************************
# fsgnj.S
#-----------------------------------------------------------------------------
#
# Test fsgn{j|jn|x}.d instructions.
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV64UF
RVTEST_CODE_BEGIN

  #-------------------------------------------------------------
  # Arithmetic tests
  #-------------------------------------------------------------

  TEST_FP_OP2_D( 2,  fsgnj.d, 0, -6.3,  6.3, -1.0 );
  TEST_FP_OP2_D( 3,  fsgnj.d, 0,  7.3,  7.3,  2.0 );
  TEST_FP_OP2_D( 4,  fsgnj.d, 0, -8.3, -8.3, -3.0 );
  TEST_FP_OP2_D( 5,  fsgnj.d, 0,  9.3, -9.3,  4.0 );

  TEST_FP_OP2_D(12, fsgnjn.d, 0,  6.3,  6.3, -1.0 );
  TEST_FP_OP2_D(13, fsgnjn.d, 0, -7.3,  7.3,  2.0 );
  TEST_FP_OP2_D(14, fsgnjn.d, 0,  8.3, -8.3, -3.0 );
  TEST_FP_OP2_D(15, fsgnjn.d, 0, -9.3, -9.3,  4.0 );

  TEST_FP_OP2_D(22, fsgnjx.d, 0, -6.3,  6.3, -1.0 );
  TEST_FP_OP2_D(23, fsgnjx.d, 0,  7.3,  7.3,  2.0 );
  TEST_FP_OP2_D(24, fsgnjx.d, 0,  8.3, -8.3, -3.0 );
  TEST_FP_OP2_D(25, fsgnjx.d, 0, -9.3, -9.3,  4.0 );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END
