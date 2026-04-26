# See LICENSE for license details.

#*****************************************************************************
# paas_wx.S
#-----------------------------------------------------------------------------
#
# Test paas.wx instruction (packed cross averaging add-sub word, RV64 only).
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV64U
RVTEST_CODE_BEGIN

  #-------------------------------------------------------------
  # Arithmetic tests
  #-------------------------------------------------------------

  # paas.wx rd, rs1, rs2
  # Performs packed cross averaging add-sub on words:
  # rd[0] (low)  = (rs1[0] + rs2[1]) >> 1  (avg add)
  # rd[1] (high) = (rs1[1] - rs2[0]) >> 1  (avg sub)

  # Test case 1: Simple cross averaging add-sub
  # rs1 = 0x0000000800000004, rs2 = 0x0000000400000002
  # low:  (0x00000004 + 0x00000004) >> 1 = 0x00000004
  # high: (0x00000008 - 0x00000002) >> 1 = 0x00000003
  # Expected: 0x0000000300000004
  TEST_RR_OP( 2, paas.wx, 0x0000000300000004, 0x0000000800000004, 0x0000000400000002 );

  # Test case 2: Zero + Zero = Zero
  TEST_RR_OP( 3, paas.wx, 0x0000000000000000, 0x0000000000000000, 0x0000000000000000 );

  # Test case 3: Same values in rs1 and rs2
  # rs1 = 0x0000000400000004, rs2 = 0x0000000200000002
  # low:  (0x00000004 + 0x00000002) >> 1 = 0x00000003
  # high: (0x00000004 - 0x00000002) >> 1 = 0x00000001
  # Expected: 0x0000000100000003
  TEST_RR_OP( 4, paas.wx, 0x0000000100000003, 0x0000000400000004, 0x0000000200000002 );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END

