# See LICENSE for license details.

#*****************************************************************************
# rev8.S
#-----------------------------------------------------------------------------
#
# Test rev8 instruction.
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV64U
RVTEST_CODE_BEGIN

  #-------------------------------------------------------------
  # Arithmetic tests
  #-------------------------------------------------------------

  TEST_R_OP( 2,  rev8, 0x0000000000000000, 0x0000000000000000);
  TEST_R_OP( 3,  rev8, 0x0100000000000000, 0x0000000000000001);
  TEST_R_OP( 4,  rev8, 0x0300000000000000, 0x0000000000000003);

  TEST_R_OP( 5,  rev8, 0x0080ffffffffffff, 0xffffffffffff8000 );
  TEST_R_OP( 6,  rev8, 0x0000800000000000, 0x0000000000800000 );
  TEST_R_OP( 7,  rev8, 0x0080ffffffff0400, 0x0004ffffffff8000 );

  TEST_R_OP( 8,  rev8, 0xff7f000000000000, 0x0000000000007fff);
  TEST_R_OP( 9,  rev8, 0xffffff7f00000000, 0x000000007fffffff);
  TEST_R_OP( 10, rev8, 0xffff070000000000, 0x000000000007ffff );

  TEST_R_OP( 11, rev8, 0x00000080ffffffff, 0xffffffff80000000);
  TEST_R_OP( 12, rev8, 0x00501f128f57ff00, 0x00ff578f121f5000);

  TEST_R_OP( 13, rev8, 0x0000000000000080, 0x8000000000000000);
  TEST_R_OP( 14, rev8, 0x0e00000000000000, 0x000000000000000e);
  TEST_R_OP( 15, rev8, 0x41134020030000a0, 0xa000000320401341);

  #-------------------------------------------------------------
  # Source/Destination tests
  #-------------------------------------------------------------

  TEST_R_SRC1_EQ_DEST( 16, rev8, 0x0d00000000000000, 13);
  TEST_R_SRC1_EQ_DEST( 17, rev8, 0x0b00000000000000, 11);

  #-------------------------------------------------------------
  # Bypassing tests
  #-------------------------------------------------------------

  TEST_R_DEST_BYPASS( 18, 0, rev8, 0x0d00000000000000, 13);
  TEST_R_DEST_BYPASS( 29, 1, rev8, 0x1300000000000000, 19);
  TEST_R_DEST_BYPASS( 20, 2, rev8, 0x2200000000000000, 34);

  #-------------------------------------------------------------
  # Other tests
  #-------------------------------------------------------------

  TEST_R_OP( 21,  rev8, 0x00807f0000000000, 0x00000000007f8000 );
  TEST_R_OP( 22,  rev8, 0x0080800000000000, 0x0000000000808000 );
  TEST_R_OP( 23,  rev8, 0x0080800100000000, 0x0000000001808000 );

  TEST_R_OP( 24,  rev8, 0xff7f000003000000, 0x0000000300007fff);
  TEST_R_OP( 25,  rev8, 0xffffff7f07000000, 0x000000077fffffff);
  TEST_R_OP( 26,  rev8, 0xffff07000f000000, 0x0000000f0007ffff);

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END
