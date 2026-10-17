# See LICENSE for license details.

#*****************************************************************************
# fmadd.S
#-----------------------------------------------------------------------------
#
# Test f[n]m{add|sub}.s and f[n]m{add|sub}.d instructions.
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV64UF
RVTEST_CODE_BEGIN

  #-------------------------------------------------------------
  # Arithmetic tests
  #-------------------------------------------------------------

  TEST_FP_OP3_S( 2,  fmadd.s, 0,                 3.5,  1.0,        2.5,        1.0 );
  TEST_FP_OP3_S( 3,  fmadd.s, 1,              1236.2, -1.0,    -1235.1,        1.1 );
  TEST_FP_OP3_S( 4,  fmadd.s, 0,               -12.0,  2.0,       -5.0,       -2.0 );

  TEST_FP_OP3_S( 5, fnmadd.s, 0,                -3.5,  1.0,        2.5,        1.0 );
  TEST_FP_OP3_S( 6, fnmadd.s, 1,             -1236.2, -1.0,    -1235.1,        1.1 );
  TEST_FP_OP3_S( 7, fnmadd.s, 0,                12.0,  2.0,       -5.0,       -2.0 );

  TEST_FP_OP3_S( 8,  fmsub.s, 0,                 1.5,  1.0,        2.5,        1.0 );
  TEST_FP_OP3_S( 9,  fmsub.s, 1,                1234, -1.0,    -1235.1,        1.1 );
  TEST_FP_OP3_S(10,  fmsub.s, 0,                -8.0,  2.0,       -5.0,       -2.0 );

  TEST_FP_OP3_S(11, fnmsub.s, 0,                -1.5,  1.0,        2.5,        1.0 );
  TEST_FP_OP3_S(12, fnmsub.s, 1,               -1234, -1.0,    -1235.1,        1.1 );
  TEST_FP_OP3_S(13, fnmsub.s, 0,                 8.0,  2.0,       -5.0,       -2.0 );

  # Under RNE, (1 + 2^-23) * (1 - 2^-23) - 1 is exactly -2^-46.
  TEST_FP_OP3_S(14,  fmadd.s, 0, 0f:a8800000, 0f:3f800001, 0f:3f7ffffe, -1.0 );
  TEST_FP_OP3_S(15, fnmadd.s, 0, 0f:28800000, 0f:3f800001, 0f:3f7ffffe, -1.0 );
  TEST_FP_OP3_S(16,  fmsub.s, 0, 0f:a8800000, 0f:3f800001, 0f:3f7ffffe,  1.0 );
  TEST_FP_OP3_S(17, fnmsub.s, 0, 0f:28800000, 0f:3f800001, 0f:3f7ffffe,  1.0 );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END
