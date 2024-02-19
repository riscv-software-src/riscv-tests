# See LICENSE for license details.

#*****************************************************************************
# cpop.S
#-----------------------------------------------------------------------------
#
# Test cpop instruction.
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV32U
RVTEST_CODE_BEGIN

  #-------------------------------------------------------------
  # Arithmetic tests
  #-------------------------------------------------------------

  TEST_R_OP( 2,  cpop, 0, 0x00000000);
  TEST_R_OP( 3,  cpop, 1, 0x00000001);
  TEST_R_OP( 4,  cpop, 2, 0x00000003);

  TEST_R_OP( 5,  cpop, 17, 0xffff8000 );
  TEST_R_OP( 6,  cpop, 1, 0x00800000 );
  TEST_R_OP( 7,  cpop, 18, 0xffff6000 );

  TEST_R_OP( 8,  cpop, 15, 0x00007fff);
  TEST_R_OP( 9,  cpop, 31, 0x7fffffff);
  TEST_R_OP( 10, cpop, 19, 0x0007ffff );

  TEST_R_OP( 11, cpop, 1, 0x80000000);
  TEST_R_OP( 12, cpop, 9, 0x121f5000);

  TEST_R_OP( 13, cpop, 0, 0x00000000);
  TEST_R_OP( 14, cpop, 3, 0x0000000e);
  TEST_R_OP( 15, cpop, 7, 0x20401341);

  #-------------------------------------------------------------
  # Source/Destination tests
  #-------------------------------------------------------------

  TEST_R_SRC1_EQ_DEST( 16, cpop, 3, 13);
  TEST_R_SRC1_EQ_DEST( 17, cpop, 3, 11);

  #-------------------------------------------------------------
  # Bypassing tests
  #-------------------------------------------------------------

  TEST_R_DEST_BYPASS( 18, 0, cpop, 3, 13);
  TEST_R_DEST_BYPASS( 29, 1, cpop, 3, 19);
  TEST_R_DEST_BYPASS( 20, 2, cpop, 2, 34);

  #-------------------------------------------------------------
  # Other tests
  #-------------------------------------------------------------

  TEST_R_OP( 21,  cpop, 8, 0x007f8000 );
  TEST_R_OP( 22,  cpop, 2, 0x00808000 );
  TEST_R_OP( 23,  cpop, 3, 0x01808000 );

  TEST_R_OP( 24,  cpop, 17, 0x30007fff);
  TEST_R_OP( 25,  cpop, 30, 0x77ffffff);
  TEST_R_OP( 26,  cpop, 19, 0x0007ffff);

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END
