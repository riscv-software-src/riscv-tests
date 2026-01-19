# See LICENSE for license details.

#*****************************************************************************
# rev8.S
#-----------------------------------------------------------------------------
#
# Test rev8 instruction.
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV32U
RVTEST_CODE_BEGIN

  #-------------------------------------------------------------
  # Arithmetic tests
  #-------------------------------------------------------------

  TEST_R_OP( 2,  rev8, 0x00000000, 0x00000000);
  TEST_R_OP( 3,  rev8, 0x01000000, 0x00000001);
  TEST_R_OP( 4,  rev8, 0x03000000, 0x00000003);

  TEST_R_OP( 5,  rev8, 0x0080ffff, 0xffff8000 );
  TEST_R_OP( 6,  rev8, 0x00008000, 0x00800000 );
  TEST_R_OP( 7,  rev8, 0x0080ffff, 0xffff8000 );

  TEST_R_OP( 8,  rev8, 0xff7f0000, 0x00007fff);
  TEST_R_OP( 9,  rev8, 0xffffff7f, 0x7fffffff);
  TEST_R_OP( 10, rev8, 0xffff0700, 0x0007ffff );

  TEST_R_OP( 11, rev8, 0x00000080, 0x80000000);
  TEST_R_OP( 12, rev8, 0x00501f12, 0x121f5000);

  TEST_R_OP( 13, rev8, 0x00000000, 0x00000000);
  TEST_R_OP( 14, rev8, 0x0e000000, 0x0000000e);
  TEST_R_OP( 15, rev8, 0x41134020, 0x20401341);

  #-------------------------------------------------------------
  # Source/Destination tests
  #-------------------------------------------------------------

  TEST_R_SRC1_EQ_DEST( 16, rev8, 0x0d000000, 13);
  TEST_R_SRC1_EQ_DEST( 17, rev8, 0x0b000000, 11);

  #-------------------------------------------------------------
  # Bypassing tests
  #-------------------------------------------------------------

  TEST_R_DEST_BYPASS( 18, 0, rev8, 0x0d000000, 13);
  TEST_R_DEST_BYPASS( 29, 1, rev8, 0x13000000, 19);
  TEST_R_DEST_BYPASS( 20, 2, rev8, 0x22000000, 34);

  #-------------------------------------------------------------
  # Other tests
  #-------------------------------------------------------------

  TEST_R_OP( 21,  rev8, 0x00807f00, 0x007f8000 );
  TEST_R_OP( 22,  rev8, 0x00808000, 0x00808000 );
  TEST_R_OP( 23,  rev8, 0x00808001, 0x01808000 );

  TEST_R_OP( 24,  rev8, 0xff7f0000, 0x00007fff);
  TEST_R_OP( 25,  rev8, 0xffffff7f, 0x7fffffff);
  TEST_R_OP( 26,  rev8, 0xffff0700, 0x0007ffff);

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END
