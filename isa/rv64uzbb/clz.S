# See LICENSE for license details.

#*****************************************************************************
# clz.S
#-----------------------------------------------------------------------------
#
# Test clz instruction.
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV64U
RVTEST_CODE_BEGIN

  #-------------------------------------------------------------
  # Arithmetic tests
  #-------------------------------------------------------------

  TEST_R_OP( 2,  clz, 64, 0x0000000000000000);
  TEST_R_OP( 3,  clz, 63, 0x0000000000000001);
  TEST_R_OP( 4,  clz, 62, 0x0000000000000003);

  TEST_R_OP( 5,  clz, 0, 0xffffffffffff8000 );
  TEST_R_OP( 6,  clz, 40, 0x0000000000800000 );
  TEST_R_OP( 7,  clz, 13, 0x0004ffffffff8000 );

  TEST_R_OP( 8,  clz, 49, 0x0000000000007fff);
  TEST_R_OP( 9,  clz, 33, 0x000000007fffffff);
  TEST_R_OP( 10, clz, 45, 0x000000000007ffff );

  TEST_R_OP( 11, clz, 0, 0xffffffff80000000);
  TEST_R_OP( 12, clz, 8, 0x00ff578f121f5000);

  TEST_R_OP( 13, clz, 0, 0x8000000000000000);
  TEST_R_OP( 14, clz, 60, 0x000000000000000e);
  TEST_R_OP( 15, clz, 0, 0xa000000320401341);

  #-------------------------------------------------------------
  # Source/Destination tests
  #-------------------------------------------------------------

  TEST_R_SRC1_EQ_DEST( 16, clz, 60, 13);
  TEST_R_SRC1_EQ_DEST( 17, clz, 60, 11);

  #-------------------------------------------------------------
  # Bypassing tests
  #-------------------------------------------------------------

  TEST_R_DEST_BYPASS( 18, 0, clz, 60, 13);
  TEST_R_DEST_BYPASS( 29, 1, clz, 59, 19);
  TEST_R_DEST_BYPASS( 20, 2, clz, 58, 34);

  #-------------------------------------------------------------
  # Other tests
  #-------------------------------------------------------------

  TEST_R_OP( 21, clz, 37, 0x00000000070f8000 );
  TEST_R_OP( 22, clz, 36, 0x0000000008008000 );
  TEST_R_OP( 23, clz, 35, 0x0000000018008000 );

  TEST_R_OP( 24, clz, 30, 0x0000000300007fff);
  TEST_R_OP( 25, clz, 29, 0x000000077fffffff);
  TEST_R_OP( 26, clz, 28, 0x0000000f0007ffff);
  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END
