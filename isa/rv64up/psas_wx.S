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

  # psas.wx rd, rs1, rs2 (per P-ext spec)
  # rd[low]  = sat32(rs1[low]  - rs2[high])   (saturating sub)
  # rd[high] = sat32(rs1[high] + rs2[low])    (saturating add)

  # Test case 1: Simple cross saturating add-sub (no saturation)
  # rs1 = 0x0000000800000004, rs2 = 0x0000000400000002
  # low:  sat(0x00000004 - 0x00000004) = 0x00000000
  # high: sat(0x00000008 + 0x00000002) = 0x0000000a
  # Expected: 0x0000000a00000000
  TEST_RR_OP_VXSAT( 2, psas.wx, 0x0000000a00000000, 0x0000000800000004, 0x0000000400000002, 0  );

  # Test case 2: Zero
  TEST_RR_OP_VXSAT( 3, psas.wx, 0x0000000000000000, 0x0000000000000000, 0x0000000000000000, 0  );

  # Test case 3: No saturation (preserves original operand intent at unchanged inputs)
  # rs1 = 0x000000007FFFFFFF, rs2 = 0x0000000100000000
  # low:  sat(0x7FFFFFFF - 0x00000001) = 0x7FFFFFFE
  # high: sat(0x00000000 + 0x00000000) = 0x00000000
  # Expected: 0x000000007FFFFFFE
  TEST_RR_OP_VXSAT( 4, psas.wx, 0x000000007ffffffe, 0x000000007fffffff, 0x0000000100000000, 0  );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END
