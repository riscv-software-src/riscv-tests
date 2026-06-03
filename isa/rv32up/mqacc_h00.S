# See LICENSE for license details.

#*****************************************************************************
# mqacc_h00.S
#-----------------------------------------------------------------------------
#
# Test mqacc.h00 instruction.
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV32U
RVTEST_CODE_BEGIN

  #-------------------------------------------------------------
  # Arithmetic tests
  #-------------------------------------------------------------

  # mqacc.h00: rd = rd + (rs1[15:0] * rs2[15:0]) >> 15 (Q15 format)
  # Test: 10 + (0x4000 * 0x4000) >> 15 = 10 + (0x10000000 >> 15) = 10 + 0x2000 = 10 + 8192
  TEST_CASE( 2, x14, 8202, li x14, 10; li a1, 0x4000; li a2, 0x4000; mqacc.h00 x14, a1, a2 );

  # Test: 0 + (0x2000 * 0x2000) >> 15 = 0 + 2048 = 2048
  TEST_CASE( 3, x14, 2048, li x14, 0; li a1, 0x2000; li a2, 0x2000; mqacc.h00 x14, a1, a2 );

  # Test: 5 + (0x1000 * 0x1000) >> 15 = 5 + 512 = 517
  TEST_CASE( 4, x14, 517, li x14, 5; li a1, 0x1000; li a2, 0x1000; mqacc.h00 x14, a1, a2 );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END

