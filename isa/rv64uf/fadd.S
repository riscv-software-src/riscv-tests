# See LICENSE for license details.

#*****************************************************************************
# fadd.S
#-----------------------------------------------------------------------------
#
# Test f{add|sub|mul}.{s|d} instructions.
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV64UF
RVTEST_CODE_BEGIN

  #-------------------------------------------------------------
  # Arithmetic tests
  #-------------------------------------------------------------

  TEST_FP_OP2_S( 2,  fadd.s, 0,                3.5,        2.5,        1.0 );
  TEST_FP_OP2_S( 3,  fadd.s, 1,              -1234,    -1235.1,        1.1 );
  TEST_FP_OP2_S( 4,  fadd.s, 1,         3.14159265, 3.14159265, 0.00000001 );

  TEST_FP_OP2_D( 5,  fadd.d, 0,                3.5,        2.5,        1.0 );
  TEST_FP_OP2_D( 6,  fadd.d, 1,              -1234,    -1235.1,        1.1 );
  TEST_FP_OP2_D( 7,  fadd.d, 1,         3.14159266, 3.14159265, 0.00000001 );

  TEST_FP_OP2_S(12,  fsub.s, 0,                1.5,        2.5,        1.0 );
  TEST_FP_OP2_S(13,  fsub.s, 1,              -1234,    -1235.1,       -1.1 );
  TEST_FP_OP2_S(14,  fsub.s, 1,         3.14159265, 3.14159265, 0.00000001 );

  TEST_FP_OP2_D(15,  fsub.d, 0,                1.5,        2.5,        1.0 );
  TEST_FP_OP2_D(16,  fsub.d, 1,              -1234,    -1235.1,       -1.1 );
  TEST_FP_OP2_D(17,  fsub.d, 1, 3.1415926400000001, 3.14159265, 0.00000001 );

  TEST_FP_OP2_S(22,  fmul.s, 0,                2.5,        2.5,        1.0 );
  TEST_FP_OP2_S(23,  fmul.s, 1,            1358.61,    -1235.1,       -1.1 );
  TEST_FP_OP2_S(24,  fmul.s, 1,      3.14159265e-8, 3.14159265, 0.00000001 );

  TEST_FP_OP2_D(25,  fmul.d, 0,                2.5,        2.5,        1.0 );
  TEST_FP_OP2_D(26,  fmul.d, 1,            1358.61,    -1235.1,       -1.1 );
  TEST_FP_OP2_D(27,  fmul.d, 1,      3.14159265e-8, 3.14159265, 0.00000001 );

  # Is the canonical NaN generated for Inf - Inf?
  TEST_FP_OP2_S(28,  fsub.s, 0x10,         0f:7fc00000, Inf, Inf);
  TEST_FP_OP2_D(29,  fsub.d, 0x10, 0d:7ff8000000000000, Inf, Inf);

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END
