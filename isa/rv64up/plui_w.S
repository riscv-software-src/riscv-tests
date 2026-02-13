# See LICENSE for license details.

#*****************************************************************************
# plui_w.S
#-----------------------------------------------------------------------------
#
# Test plui.w instruction (packed load upper immediate word, RV64 only).
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV64U
RVTEST_CODE_BEGIN

  #-------------------------------------------------------------
  # Basic tests - plui.w loads upper immediate to all word elements
  #-------------------------------------------------------------

  # plui.w rd, imm10
  # Load upper immediate to both 32-bit word elements

  TEST_CASE( 2, x14, 0x0040000000400000, li x14, 0; plui.w x14, 1 );
  TEST_CASE( 3, x14, 0x0000000000000000, li x14, -1; plui.w x14, 0 );
  TEST_CASE( 4, x14, 0x7fc000007fc00000, li x14, 0; plui.w x14, 511 );
  TEST_CASE( 5, x14, 0xffc00000ffc00000, li x14, 0; plui.w x14, -1 );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END

