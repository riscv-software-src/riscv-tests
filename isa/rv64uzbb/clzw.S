# See LICENSE for license details.

#*****************************************************************************
# clzw.S
#-----------------------------------------------------------------------------
#
# Test clzw instruction.
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV64U
RVTEST_CODE_BEGIN

  #-------------------------------------------------------------
  # Arithmetic tests
  #-------------------------------------------------------------

  TEST_R_OP( 2,  clzw, 32, 0x00000000);
  TEST_R_OP( 3,  clzw, 31, 0x00000001);
  TEST_R_OP( 4,  clzw, 30, 0x00000003);

  TEST_R_OP( 5,  clzw, 0, 0xffff8000 );
  TEST_R_OP( 6,  clzw, 8, 0x00800000 );
  TEST_R_OP( 7,  clzw, 0, 0xffff8000 );

  TEST_R_OP( 8,  clzw, 17, 0x00007fff);
  TEST_R_OP( 9,  clzw, 1, 0x7fffffff);
  TEST_R_OP( 10, clzw, 13, 0x0007ffff );

  TEST_R_OP( 11, clzw, 0, 0x80000000);
  TEST_R_OP( 12, clzw, 3, 0x121f5000);

  TEST_R_OP( 13, clzw, 5, 0x04000000);
  TEST_R_OP( 14, clzw, 28, 0x0000000e);
  TEST_R_OP( 15, clzw, 2, 0x20401341);

  #-------------------------------------------------------------
  # Source/Destination tests
  #-------------------------------------------------------------

  TEST_R_SRC1_EQ_DEST( 16, clzw, 28, 13);
  TEST_R_SRC1_EQ_DEST( 17, clzw, 28, 11);

  #-------------------------------------------------------------
  # Bypassing tests
  #-------------------------------------------------------------

  TEST_R_DEST_BYPASS( 18, 0, clzw, 28, 13);
  TEST_R_DEST_BYPASS( 29, 1, clzw, 27, 19);
  TEST_R_DEST_BYPASS( 20, 2, clzw, 26, 34);

  #-------------------------------------------------------------
  # Other tests
  #-------------------------------------------------------------


  TEST_R_OP( 21, clzw, 5, 0x070f8000 );
  TEST_R_OP( 22, clzw, 4, 0x08008000 );
  TEST_R_OP( 23, clzw, 3, 0x18008000 );

  TEST_R_OP( 24, clzw, 17, 0x00007fff);
  TEST_R_OP( 25, clzw, 1, 0x7fffffff);
  TEST_R_OP( 26, clzw, 13, 0x0007ffff);

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END
