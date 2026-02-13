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

  # pasa.wx rd, rs1, rs2
  # Performs packed cross averaging sub-add on words (unsigned):
  # rd[0] (low)  = (rs1[0] - rs2[1]) >> 1  (avg sub)
  # rd[1] (high) = (rs1[1] + rs2[0]) >> 1  (avg add)

  # Test case 1: Simple cross averaging sub-add
  # rs1 = 0x0000000800000006, rs2 = 0x0000000400000002
  # low:  (0x00000006 - 0x00000004) >> 1 = 0x00000001
  # high: (0x00000008 + 0x00000002) >> 1 = 0x00000005
  # Expected: 0x0000000500000001
  TEST_RR_OP( 2, pasa.wx, 0x0000000500000001, 0x0000000800000006, 0x0000000400000002 );

  # Test case 2: Zero
  TEST_RR_OP( 3, pasa.wx, 0x0000000000000000, 0x0000000000000000, 0x0000000000000000 );

  # Test case 3: Same values
  # rs1 = 0x0000000400000004, rs2 = 0x0000000200000002
  # low:  (0x00000004 - 0x00000002) >> 1 = 0x00000001
  # high: (0x00000004 + 0x00000002) >> 1 = 0x00000003
  # Expected: 0x0000000300000001
  TEST_RR_OP( 4, pasa.wx, 0x0000000300000001, 0x0000000400000004, 0x0000000200000002 );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END

