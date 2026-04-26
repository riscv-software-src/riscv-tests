# See LICENSE for license details.

#*****************************************************************************
# psrl_ws.S
#-----------------------------------------------------------------------------
#
# Test psrl.ws instruction (packed shift right logical word scalar, RV64 only).
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV64U
RVTEST_CODE_BEGIN

  # psrl.ws rd, rs1, rs2
  # Performs packed word shift right logical by scalar amount (rs2 & 31)

  # Test case 1: Shift right by 1
  TEST_RR_OP( 2, psrl.ws, 0x0000000100000000, 0x0000000200000001, 0x0000000000000001 );

  # Test case 2: Shift right by 0 (no change)
  TEST_RR_OP( 3, psrl.ws, 0x0000000200000001, 0x0000000200000001, 0x0000000000000000 );

  # Test case 3: Shift right by 4 (no sign extension)
  TEST_RR_OP( 4, psrl.ws, 0x0800000008000000, 0x8000000080000000, 0x0000000000000004 );

  # Test case 4: Shift right by 31
  TEST_RR_OP( 5, psrl.ws, 0x0000000100000001, 0x8000000080000000, 0x000000000000001f );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN
  TEST_DATA
RVTEST_DATA_END

