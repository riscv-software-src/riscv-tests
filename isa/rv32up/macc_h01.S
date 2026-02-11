# See LICENSE for license details.

#*****************************************************************************
# macc_h01.S
#-----------------------------------------------------------------------------
#
# Test macc.h01 instruction.
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV32U
RVTEST_CODE_BEGIN

  #-------------------------------------------------------------
  # Arithmetic tests
  #-------------------------------------------------------------

  # macc.h01: rd = rd + rs1[15:0] * rs2[31:16] (signed)
  # Test: 10 + 2 * 3 = 16 (rs2 = 0x00030000)
  TEST_CASE( 2, x14, 16, li x14, 10; li a1, 2; li a2, 0x00030000; macc.h01 x14, a1, a2 );

  # Test: 0 + 4 * 5 = 20 (rs2 = 0x00050000)
  TEST_CASE( 3, x14, 20, li x14, 0; li a1, 4; li a2, 0x00050000; macc.h01 x14, a1, a2 );

  # Test with negative: 100 + (-2) * 3 = 94
  TEST_CASE( 4, x14, 94, li x14, 100; li a1, -2; li a2, 0x00030000; macc.h01 x14, a1, a2 );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END

