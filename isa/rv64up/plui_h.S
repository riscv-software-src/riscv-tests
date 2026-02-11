# See LICENSE for license details.

#*****************************************************************************
# plui_h.S
#-----------------------------------------------------------------------------
#
# Test plui.h instruction (packed load upper immediate halfword).
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV64U
RVTEST_CODE_BEGIN

  #-------------------------------------------------------------
  # Basic tests - plui.h loads 10-bit immediate to upper bits of halfword elements
  #-------------------------------------------------------------

  # plui.h rd, imm10 (signed -512 to 511)
  TEST_CASE( 2, x14, 0x0040004000400040, li x14, 0; plui.h x14, 1 );
  TEST_CASE( 3, x14, 0x0000000000000000, li x14, -1; plui.h x14, 0 );
  TEST_CASE( 4, x14, 0x7fc07fc07fc07fc0, li x14, 0; plui.h x14, 511 );
  TEST_CASE( 5, x14, 0x8000800080008000, li x14, 0; plui.h x14, -512 );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END

