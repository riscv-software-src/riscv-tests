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

  TEST_FP_OP3_D( 5,  fmadd.d, 0,                 3.5,  1.0,        2.5,        1.0 );
  TEST_FP_OP3_D( 6,  fmadd.d, 1,  1236.1999999999999, -1.0,    -1235.1,        1.1 );
  TEST_FP_OP3_D( 7,  fmadd.d, 0,               -12.0,  2.0,       -5.0,       -2.0 );

  TEST_FP_OP3_S( 8, fnmadd.s, 0,                -3.5,  1.0,        2.5,        1.0 );
  TEST_FP_OP3_S( 9, fnmadd.s, 1,             -1236.2, -1.0,    -1235.1,        1.1 );
  TEST_FP_OP3_S(10, fnmadd.s, 0,                12.0,  2.0,       -5.0,       -2.0 );

  TEST_FP_OP3_D(11, fnmadd.d, 0,                -3.5,  1.0,        2.5,        1.0 );
  TEST_FP_OP3_D(12, fnmadd.d, 1, -1236.1999999999999, -1.0,    -1235.1,        1.1 );
  TEST_FP_OP3_D(13, fnmadd.d, 0,                12.0,  2.0,       -5.0,       -2.0 );

  TEST_FP_OP3_S(14,  fmsub.s, 0,                 1.5,  1.0,        2.5,        1.0 );
  TEST_FP_OP3_S(15,  fmsub.s, 1,                1234, -1.0,    -1235.1,        1.1 );
  TEST_FP_OP3_S(16,  fmsub.s, 0,                -8.0,  2.0,       -5.0,       -2.0 );

  TEST_FP_OP3_D(17,  fmsub.d, 0,                 1.5,  1.0,        2.5,        1.0 );
  TEST_FP_OP3_D(18,  fmsub.d, 1,                1234, -1.0,    -1235.1,        1.1 );
  TEST_FP_OP3_D(19,  fmsub.d, 0,                -8.0,  2.0,       -5.0,       -2.0 );

  TEST_FP_OP3_S(20, fnmsub.s, 0,                -1.5,  1.0,        2.5,        1.0 );
  TEST_FP_OP3_S(21, fnmsub.s, 1,               -1234, -1.0,    -1235.1,        1.1 );
  TEST_FP_OP3_S(22, fnmsub.s, 0,                 8.0,  2.0,       -5.0,       -2.0 );

  TEST_FP_OP3_D(23, fnmsub.d, 0,                -1.5,  1.0,        2.5,        1.0 );
  TEST_FP_OP3_D(24, fnmsub.d, 1,               -1234, -1.0,    -1235.1,        1.1 );
  TEST_FP_OP3_D(25, fnmsub.d, 0,                 8.0,  2.0,       -5.0,       -2.0 );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END
