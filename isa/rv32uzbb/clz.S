# See LICENSE for license details.

#*****************************************************************************
# clz.S
#-----------------------------------------------------------------------------
#
# Test clz instruction.
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV32U
RVTEST_CODE_BEGIN

  #-------------------------------------------------------------
  # Arithmetic tests
  #-------------------------------------------------------------

  TEST_R_OP( 2,  clz, 32, 0x00000000);
  TEST_R_OP( 3,  clz, 31, 0x00000001);
  TEST_R_OP( 4,  clz, 30, 0x00000003);

  TEST_R_OP( 5,  clz, 0, 0xffff8000 );
  TEST_R_OP( 6,  clz, 8, 0x00800000 );
  TEST_R_OP( 7,  clz, 0, 0xffff8000 );

  TEST_R_OP( 8,  clz, 17, 0x00007fff);
  TEST_R_OP( 9,  clz, 1, 0x7fffffff);
  TEST_R_OP( 10, clz, 13, 0x0007ffff );

  TEST_R_OP( 11, clz, 0, 0x80000000);
  TEST_R_OP( 12, clz, 3, 0x121f5000);

  TEST_R_OP( 13, clz, 5, 0x04000000);
  TEST_R_OP( 14, clz, 28, 0x0000000e);
  TEST_R_OP( 15, clz, 2, 0x20401341);

  #-------------------------------------------------------------
  # Source/Destination tests
  #-------------------------------------------------------------

  TEST_R_SRC1_EQ_DEST( 16, clz, 28, 13);
  TEST_R_SRC1_EQ_DEST( 17, clz, 28, 11);

  #-------------------------------------------------------------
  # Bypassing tests
  #-------------------------------------------------------------

  TEST_R_DEST_BYPASS( 18, 0, clz, 28, 13);
  TEST_R_DEST_BYPASS( 29, 1, clz, 27, 19);
  TEST_R_DEST_BYPASS( 20, 2, clz, 26, 34);

  #-------------------------------------------------------------
  # Other tests
  #-------------------------------------------------------------


  TEST_R_OP( 21, clz, 5, 0x070f8000 );
  TEST_R_OP( 22, clz, 4, 0x08008000 );
  TEST_R_OP( 23, clz, 3, 0x18008000 );

  TEST_R_OP( 24, clz, 17, 0x00007fff);
  TEST_R_OP( 25, clz, 1, 0x7fffffff);
  TEST_R_OP( 26, clz, 13, 0x0007ffff);

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END
