# See LICENSE for license details.

#*****************************************************************************
# sext_h.S
#-----------------------------------------------------------------------------
#
# Test sext.h instruction.
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV64U
RVTEST_CODE_BEGIN

  #-------------------------------------------------------------
  # Arithmetic tests
  #-------------------------------------------------------------

  TEST_R_OP( 2,  sext.h, 0x0000000000000000, 0x0000000000000000);
  TEST_R_OP( 3,  sext.h, 0x0000000000000001, 0x0000000000000001);
  TEST_R_OP( 4,  sext.h, 0x0000000000000003, 0x0000000000000003);

  TEST_R_OP( 5,  sext.h, 0xffffffffffff8000, 0xffffffffffff8000 );
  TEST_R_OP( 6,  sext.h, 0x0000000000000000, 0x0000000000800000 );
  TEST_R_OP( 7,  sext.h, 0xffffffffffff8000, 0x0004ffffffff8000 );

  TEST_R_OP( 8,  sext.h, 0x0000000000007fff, 0x0000000000007fff);
  TEST_R_OP( 9,  sext.h, 0xffffffffffffffff, 0x000000007fffffff);
  TEST_R_OP( 10, sext.h, 0xffffffffffffffff, 0x000000000007ffff );

  TEST_R_OP( 11, sext.h, 0x0000000000000000, 0xffffffff80000000);
  TEST_R_OP( 12, sext.h, 0x0000000000005000, 0x00ff578f121f5000);

  TEST_R_OP( 13, sext.h, 0x0000000000000000, 0x8000000000000000);
  TEST_R_OP( 14, sext.h, 0x000000000000000e, 0x000000000000000e);
  TEST_R_OP( 15, sext.h, 0x0000000000001341, 0xa000000320401341);

  #-------------------------------------------------------------
  # Source/Destination tests
  #-------------------------------------------------------------

  TEST_R_SRC1_EQ_DEST( 16, sext.h, 0x000000000000000d, 13);
  TEST_R_SRC1_EQ_DEST( 17, sext.h, 0x000000000000000b, 11);

  #-------------------------------------------------------------
  # Bypassing tests
  #-------------------------------------------------------------

  TEST_R_DEST_BYPASS( 18, 0, sext.h, 0x000000000000000d, 13);
  TEST_R_DEST_BYPASS( 29, 1, sext.h, 0x0000000000000013, 19);
  TEST_R_DEST_BYPASS( 20, 2, sext.h, 0x0000000000000022, 34);

  #-------------------------------------------------------------
  # Other tests
  #-------------------------------------------------------------

  TEST_R_OP( 21,  sext.h, 0xffffffffffff8000, 0x00000000007f8000 );
  TEST_R_OP( 22,  sext.h, 0xffffffffffff8000, 0x0000000000808000 );
  TEST_R_OP( 23,  sext.h, 0xffffffffffff8000, 0x0000000001808000 );

  TEST_R_OP( 24,  sext.h, 0x0000000000007fff, 0x0000000300007fff);
  TEST_R_OP( 25,  sext.h, 0xffffffffffffffff, 0x000000077fffffff);
  TEST_R_OP( 26,  sext.h, 0xffffffffffffffff, 0x0000000f0007ffff);

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END
