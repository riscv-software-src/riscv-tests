# See LICENSE for license details.

#*****************************************************************************
# psas_wx.S
#-----------------------------------------------------------------------------
#
# Test psas.wx instruction (packed cross saturating add-sub word, RV64 only).
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV64U
RVTEST_CODE_BEGIN

  #-------------------------------------------------------------
  # Arithmetic tests
  #-------------------------------------------------------------

  # psas.wx rd, rs1, rs2
  # Performs packed cross saturating add-sub on words (signed):
  # rd[0] (low)  = sat_add(rs1[0], rs2[1])  (saturating add)
  # rd[1] (high) = sat_sub(rs1[1], rs2[0])  (saturating sub)

  # Test case 1: Simple cross saturating add-sub (no saturation)
  # rs1 = 0x0000000800000004, rs2 = 0x0000000400000002
  # low:  sat_add(0x00000004, 0x00000004) = 0x00000008
  # high: sat_sub(0x00000008, 0x00000002) = 0x00000006
  # Expected: 0x0000000600000008
  TEST_RR_OP( 2, psas.wx, 0x0000000600000008, 0x0000000800000004, 0x0000000400000002 );

  # Test case 2: Zero
  TEST_RR_OP( 3, psas.wx, 0x0000000000000000, 0x0000000000000000, 0x0000000000000000 );

  # Test case 3: Positive saturation on add
  # rs1 = 0x000000007FFFFFFF, rs2 = 0x0000000100000000
  # low:  sat_add(0x7FFFFFFF, 0x00000001) = 0x7FFFFFFF (saturated)
  # high: sat_sub(0x00000000, 0x00000000) = 0x00000000
  # Expected: 0x000000007FFFFFFF
  TEST_RR_OP( 4, psas.wx, 0x000000007fffffff, 0x000000007fffffff, 0x0000000100000000 );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END

