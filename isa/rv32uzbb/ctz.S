# See LICENSE for license details.

#*****************************************************************************
# ctz.S
#-----------------------------------------------------------------------------
#
# Test ctz instruction.
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV32U
RVTEST_CODE_BEGIN

  #-------------------------------------------------------------
  # Arithmetic tests
  #-------------------------------------------------------------

  TEST_R_OP( 2,  ctz, 32, 0x00000000);
  TEST_R_OP( 3,  ctz, 0, 0x00000001);
  TEST_R_OP( 4,  ctz, 0, 0x00000003);

  TEST_R_OP( 5,  ctz, 15, 0xffff8000 );
  TEST_R_OP( 6,  ctz, 23, 0x00800000 );
  TEST_R_OP( 7,  ctz, 15, 0xffff8000 );

  TEST_R_OP( 8,  ctz, 0, 0x00007fff);
  TEST_R_OP( 9,  ctz, 0, 0x7fffffff);
  TEST_R_OP( 10, ctz, 0, 0x0007ffff );

  TEST_R_OP( 11, ctz, 31, 0x80000000);
  TEST_R_OP( 12, ctz, 12, 0x121f5000);

  TEST_R_OP( 13, ctz, 30, 0xc0000000);
  TEST_R_OP( 14, ctz, 1, 0x0000000e);
  TEST_R_OP( 15, ctz, 0, 0x20401341);

  #-------------------------------------------------------------
  # Source/Destination tests
  #-------------------------------------------------------------

  TEST_R_SRC1_EQ_DEST( 16, ctz, 0, 13);
  TEST_R_SRC1_EQ_DEST( 17, ctz, 0, 11);

  #-------------------------------------------------------------
  # Bypassing tests
  #-------------------------------------------------------------

  TEST_R_DEST_BYPASS( 18, 0, ctz, 0, 13);
  TEST_R_DEST_BYPASS( 29, 1, ctz, 0, 19);
  TEST_R_DEST_BYPASS( 20, 2, ctz, 1, 34);

  #-------------------------------------------------------------
  # Other tests
  #-------------------------------------------------------------

  TEST_R_OP( 21,  ctz, 15, 0x007f8000 );
  TEST_R_OP( 22,  ctz, 15, 0x00808000 );
  TEST_R_OP( 23,  ctz, 12, 0x01809000 );

  TEST_R_OP( 24,  ctz, 0, 0x00007fff);
  TEST_R_OP( 25,  ctz, 0, 0x7fffffff);
  TEST_R_OP( 26,  ctz, 0, 0x0007ffff);

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END
