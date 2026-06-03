# See LICENSE for license details.

#*****************************************************************************
# psll_ws.S
#-----------------------------------------------------------------------------
#
# Test psll.ws instruction (packed shift left logical word scalar, RV64 only).
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV64U
RVTEST_CODE_BEGIN

  # psll.ws rd, rs1, rs2
  # Performs packed word shift left logical by scalar amount (rs2 & 31)

  # Test case 1: Shift left by 1
  TEST_RR_OP( 2, psll.ws, 0x0000000400000002, 0x0000000200000001, 0x0000000000000001 );

  # Test case 2: Shift left by 0 (no change)
  TEST_RR_OP( 3, psll.ws, 0x0000000200000001, 0x0000000200000001, 0x0000000000000000 );

  # Test case 3: Shift left by 4
  TEST_RR_OP( 4, psll.ws, 0x0000002000000010, 0x0000000200000001, 0x0000000000000004 );

  # Test case 4: Shift left by 31
  TEST_RR_OP( 5, psll.ws, 0x8000000080000000, 0x0000000100000001, 0x000000000000001f );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN
  TEST_DATA
RVTEST_DATA_END

