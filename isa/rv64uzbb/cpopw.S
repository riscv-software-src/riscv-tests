# See LICENSE for license details.

#*****************************************************************************
# cpopw.S
#-----------------------------------------------------------------------------
#
# Test cpopw instruction.
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV64U
RVTEST_CODE_BEGIN

  #-------------------------------------------------------------
  # Arithmetic tests
  #-------------------------------------------------------------

  TEST_R_OP( 2,  cpopw, 0, 0x00000000);
  TEST_R_OP( 3,  cpopw, 1, 0x00000001);
  TEST_R_OP( 4,  cpopw, 2, 0x00000003);

  TEST_R_OP( 5,  cpopw, 17, 0xffff8000 );
  TEST_R_OP( 6,  cpopw, 1, 0x00800000 );
  TEST_R_OP( 7,  cpopw, 18, 0xffff6000 );

  TEST_R_OP( 8,  cpopw, 15, 0x00007fff);
  TEST_R_OP( 9,  cpopw, 31, 0x7fffffff);
  TEST_R_OP( 10, cpopw, 19, 0x0007ffff );

  TEST_R_OP( 11, cpopw, 1, 0x80000000);
  TEST_R_OP( 12, cpopw, 9, 0x121f5000);

  TEST_R_OP( 13, cpopw, 0, 0x00000000);
  TEST_R_OP( 14, cpopw, 3, 0x0000000e);
  TEST_R_OP( 15, cpopw, 7, 0x20401341);

  #-------------------------------------------------------------
  # Source/Destination tests
  #-------------------------------------------------------------

  TEST_R_SRC1_EQ_DEST( 16, cpopw, 3, 13);
  TEST_R_SRC1_EQ_DEST( 17, cpopw, 3, 11);

  #-------------------------------------------------------------
  # Bypassing tests
  #-------------------------------------------------------------

  TEST_R_DEST_BYPASS( 18, 0, cpopw, 3, 13);
  TEST_R_DEST_BYPASS( 29, 1, cpopw, 3, 19);
  TEST_R_DEST_BYPASS( 20, 2, cpopw, 2, 34);

  #-------------------------------------------------------------
  # Other tests
  #-------------------------------------------------------------

  TEST_R_OP( 21,  cpopw, 8, 0x007f8000 );
  TEST_R_OP( 22,  cpopw, 2, 0x00808000 );
  TEST_R_OP( 23,  cpopw, 3, 0x01808000 );

  TEST_R_OP( 24,  cpopw, 17, 0x30007fff);
  TEST_R_OP( 25,  cpopw, 30, 0x77ffffff);
  TEST_R_OP( 26,  cpopw, 19, 0x0007ffff);

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END
