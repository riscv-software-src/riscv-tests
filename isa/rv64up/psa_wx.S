# See LICENSE for license details.

#*****************************************************************************
# psa_wx.S
#-----------------------------------------------------------------------------
#
# Test psa.wx instruction (packed cross sub-add word, RV64 only).
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV64U
RVTEST_CODE_BEGIN

  #-------------------------------------------------------------
  # Arithmetic tests
  #-------------------------------------------------------------

  # psa.wx rd, rs1, rs2
  # Performs packed cross sub-add on words:
  # rd[0] (low)  = rs1[0] - rs2[1]  (sub)
  # rd[1] (high) = rs1[1] + rs2[0]  (add)

  # Test case 1: Simple cross sub-add
  # rs1 = 0x0000000800000006, rs2 = 0x0000000400000002
  # low:  0x00000006 - 0x00000004 = 0x00000002
  # high: 0x00000008 + 0x00000002 = 0x0000000a
  # Expected: 0x0000000a00000002
  TEST_RR_OP( 2, psa.wx, 0x0000000a00000002, 0x0000000800000006, 0x0000000400000002 );

  # Test case 2: Zero
  TEST_RR_OP( 3, psa.wx, 0x0000000000000000, 0x0000000000000000, 0x0000000000000000 );

  # Test case 3: Same values
  # rs1 = 0x0000000400000004, rs2 = 0x0000000200000002
  # low:  0x00000004 - 0x00000002 = 0x00000002
  # high: 0x00000004 + 0x00000002 = 0x00000006
  # Expected: 0x0000000600000002
  TEST_RR_OP( 4, psa.wx, 0x0000000600000002, 0x0000000400000004, 0x0000000200000002 );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END

