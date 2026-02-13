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

  # pssa.wx rd, rs1, rs2 (per P-ext spec)
  # rd[low]  = sat32(rs1[low]  + rs2[high])   (saturating add)
  # rd[high] = sat32(rs1[high] - rs2[low])    (saturating sub)

  # Test case 1: Simple cross saturating sub-add (no saturation)
  # rs1 = 0x0000000800000006, rs2 = 0x0000000400000002
  # low:  sat(0x00000006 + 0x00000004) = 0x0000000a
  # high: sat(0x00000008 - 0x00000002) = 0x00000006
  # Expected: 0x000000060000000a
  TEST_RR_OP_VXSAT( 2, pssa.wx, 0x000000060000000a, 0x0000000800000006, 0x0000000400000002, 0  );

  # Test case 2: Zero
  TEST_RR_OP_VXSAT( 3, pssa.wx, 0x0000000000000000, 0x0000000000000000, 0x0000000000000000, 0  );

  # Test case 3: No saturation (preserves original operands)
  # rs1 = 0x7FFFFFFF00000008, rs2 = 0x0000000100000000
  # low:  sat(0x00000008 + 0x00000001) = 0x00000009
  # high: sat(0x7FFFFFFF - 0x00000000) = 0x7FFFFFFF
  # Expected: 0x7FFFFFFF00000009
  TEST_RR_OP_VXSAT( 4, pssa.wx, 0x7fffffff00000009, 0x7fffffff00000008, 0x0000000100000000, 0  );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END
