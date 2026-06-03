# See LICENSE for license details.

#*****************************************************************************
# pasa_wx.S
#-----------------------------------------------------------------------------
#
# Test pasa.wx instruction (packed cross averaging sub-add word, RV64 only).
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV64U
RVTEST_CODE_BEGIN

  #-------------------------------------------------------------
  # Arithmetic tests
  #-------------------------------------------------------------

  # pasa.wx rd, rs1, rs2 (per P-ext spec)
  # rd[low]  = (rs1[low]  + rs2[high]) >> 1   (avg add)
  # rd[high] = (rs1[high] - rs2[low])  >> 1   (avg sub)

  # Test case 1: Simple cross averaging sub-add
  # rs1 = 0x0000000800000006, rs2 = 0x0000000400000002
  # low:  (0x00000006 + 0x00000004) >> 1 = 0x00000005
  # high: (0x00000008 - 0x00000002) >> 1 = 0x00000003
  # Expected: 0x0000000300000005
  TEST_RR_OP( 2, pasa.wx, 0x0000000300000005, 0x0000000800000006, 0x0000000400000002 );

  # Test case 2: Zero
  TEST_RR_OP( 3, pasa.wx, 0x0000000000000000, 0x0000000000000000, 0x0000000000000000 );

  # Test case 3: Same values
  # rs1 = 0x0000000400000004, rs2 = 0x0000000200000002
  # low:  (0x00000004 + 0x00000002) >> 1 = 0x00000003
  # high: (0x00000004 - 0x00000002) >> 1 = 0x00000001
  # Expected: 0x0000000100000003
  TEST_RR_OP( 4, pasa.wx, 0x0000000100000003, 0x0000000400000004, 0x0000000200000002 );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END
