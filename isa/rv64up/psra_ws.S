# See LICENSE for license details.

#*****************************************************************************
# psra_ws.S
#-----------------------------------------------------------------------------
#
# Test psra.ws instruction (packed shift right arithmetic word scalar, RV64 only).
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV64U
RVTEST_CODE_BEGIN

  # psra.ws rd, rs1, rs2
  # Performs packed word shift right arithmetic by scalar amount (rs2 & 31)

  # Test case 1: Shift right by 1
  TEST_RR_OP( 2, psra.ws, 0x0000000100000000, 0x0000000200000001, 0x0000000000000001 );

  # Test case 2: Shift right by 0 (no change)
  TEST_RR_OP( 3, psra.ws, 0x0000000200000001, 0x0000000200000001, 0x0000000000000000 );

  # Test case 3: Shift right by 4 with sign extension
  TEST_RR_OP( 4, psra.ws, 0xf8000000f8000000, 0x8000000080000000, 0x0000000000000004 );

  # Test case 4: Positive value shift
  TEST_RR_OP( 5, psra.ws, 0x0400000004000000, 0x4000000040000000, 0x0000000000000004 );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN
  TEST_DATA
RVTEST_DATA_END

