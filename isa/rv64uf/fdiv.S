# See LICENSE for license details.

#*****************************************************************************
# fdiv.S
#-----------------------------------------------------------------------------
#
# Test f{div|sqrt}.{s|d} instructions.
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV64UF
RVTEST_CODE_BEGIN

  #-------------------------------------------------------------
  # Arithmetic tests
  #-------------------------------------------------------------

  TEST_FP_OP2_S( 2,  fdiv.s, 1, 1.1557273520668288, 3.14159265, 2.71828182 );
  TEST_FP_OP2_S( 3,  fdiv.s, 1,-0.9991093838555584,      -1234,     1235.1 );
  TEST_FP_OP2_S( 4,  fdiv.s, 0,         3.14159265, 3.14159265,        1.0 );

  TEST_FP_OP2_D( 5,  fdiv.d, 1, 1.1557273520668288, 3.14159265, 2.71828182 );
  TEST_FP_OP2_D( 6,  fdiv.d, 1,-0.9991093838555584,      -1234,     1235.1 );
  TEST_FP_OP2_D( 7,  fdiv.d, 0,         3.14159265, 3.14159265,        1.0 );

  TEST_FP_OP1_S(11,  fsqrt.s, 1, 1.7724538498928541, 3.14159265 );
  TEST_FP_OP1_S(12,  fsqrt.s, 0,                100,      10000 );

  TEST_FP_OP1_D(13,  fsqrt.d, 1, 1.7724538498928541, 3.14159265 );
  TEST_FP_OP1_D(14,  fsqrt.d, 0,                100,      10000 );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END
