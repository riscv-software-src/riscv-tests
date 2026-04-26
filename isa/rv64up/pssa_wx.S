# See LICENSE for license details.

#*****************************************************************************
# pssa_wx.S
#-----------------------------------------------------------------------------
#
# Test pssa.wx instruction (packed cross saturating sub-add word, RV64 only).
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV64U
RVTEST_CODE_BEGIN

  #-------------------------------------------------------------
  # Arithmetic tests
  #-------------------------------------------------------------

  # pssa.wx rd, rs1, rs2
  # Performs packed cross saturating sub-add on words (signed):
  # rd[0] (low)  = sat_sub(rs1[0], rs2[1])  (saturating sub)
  # rd[1] (high) = sat_add(rs1[1], rs2[0])  (saturating add)

  # Test case 1: Simple cross saturating sub-add (no saturation)
  # rs1 = 0x0000000800000006, rs2 = 0x0000000400000002
  # low:  sat_sub(0x00000006, 0x00000004) = 0x00000002
  # high: sat_add(0x00000008, 0x00000002) = 0x0000000a
  # Expected: 0x0000000a00000002
  TEST_RR_OP( 2, pssa.wx, 0x0000000a00000002, 0x0000000800000006, 0x0000000400000002 );

  # Test case 2: Zero
  TEST_RR_OP( 3, pssa.wx, 0x0000000000000000, 0x0000000000000000, 0x0000000000000000 );

  # Test case 3: Positive saturation on add
  # rs1 = 0x7FFFFFFF00000008, rs2 = 0x0000000100000000
  # low:  sat_sub(0x00000008, 0x00000000) = 0x00000008
  # high: sat_add(0x7FFFFFFF, 0x00000001) = 0x7FFFFFFF (saturated)
  # Expected: 0x7FFFFFFF00000008
  TEST_RR_OP( 4, pssa.wx, 0x7fffffff00000008, 0x7fffffff00000008, 0x0000000100000000 );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END

