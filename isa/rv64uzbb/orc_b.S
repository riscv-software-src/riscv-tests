# See LICENSE for license details.

#*****************************************************************************
# orc.b.S
#-----------------------------------------------------------------------------
#
# Test orc.b instruction.
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV64U
RVTEST_CODE_BEGIN

  #-------------------------------------------------------------
  # Arithmetic tests
  #-------------------------------------------------------------

  TEST_R_OP( 2,  orc.b, 0x0000000000000000, 0x0000000000000000);
  TEST_R_OP( 3,  orc.b, 0x00000000000000ff, 0x0000000000000001);
  TEST_R_OP( 4,  orc.b, 0x00000000000000ff, 0x0000000000000003);

  TEST_R_OP( 5,  orc.b, 0xffffffffffffff00, 0xffffffffffff8000 );
  TEST_R_OP( 6,  orc.b, 0x0000000000ff0000, 0x0000000000800000 );
  TEST_R_OP( 7,  orc.b, 0x00ffffffffffff00, 0x0004ffffffff8000 );

  TEST_R_OP( 8,  orc.b, 0x000000000000ffff, 0x0000000000007fff);
  TEST_R_OP( 9,  orc.b, 0x00000000ffffffff, 0x000000007fffffff);
  TEST_R_OP( 10, orc.b, 0x0000000000ffffff, 0x000000000007ffff );

  TEST_R_OP( 11, orc.b, 0xffffffffff000000, 0xffffffff80000000);
  TEST_R_OP( 12, orc.b, 0x00ffffffffffff00, 0x00ff578f121f5000);

  TEST_R_OP( 13, orc.b, 0xff00000000000000, 0x8000000000000000);
  TEST_R_OP( 14, orc.b, 0x00000000000000ff, 0x000000000000000e);
  TEST_R_OP( 15, orc.b, 0xff0000ffffffffff, 0xa000000320401341);

  #-------------------------------------------------------------
  # Source/Destination tests
  #-------------------------------------------------------------

  TEST_R_SRC1_EQ_DEST( 16, orc.b, 0xff, 13);
  TEST_R_SRC1_EQ_DEST( 17, orc.b, 0xff, 11);

  #-------------------------------------------------------------
  # Bypassing tests
  #-------------------------------------------------------------

  TEST_R_DEST_BYPASS( 18, 0, orc.b, 0xff, 13);
  TEST_R_DEST_BYPASS( 29, 1, orc.b, 0xff, 19);
  TEST_R_DEST_BYPASS( 20, 2, orc.b, 0xff, 34);

  #-------------------------------------------------------------
  # Other tests
  #-------------------------------------------------------------

  TEST_R_OP( 21,  orc.b, 0x0000000000ffff00, 0x00000000007f8000 );
  TEST_R_OP( 22,  orc.b, 0x0000000000ffff00, 0x0000000000808000 );
  TEST_R_OP( 23,  orc.b, 0x00000000ffffff00, 0x0000000001808000 );

  TEST_R_OP( 24,  orc.b, 0x000000ff0000ffff, 0x0000000300007fff);
  TEST_R_OP( 25,  orc.b, 0x000000ffffffffff, 0x000000077fffffff);
  TEST_R_OP( 26,  orc.b, 0x000000ff00ffffff, 0x0000000f0007ffff);

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END
