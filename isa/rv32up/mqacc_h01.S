# See LICENSE for license details.

#*****************************************************************************
# mqacc_h01.S
#-----------------------------------------------------------------------------
#
# Test mqacc.h01 instruction.
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV32U
RVTEST_CODE_BEGIN

  #-------------------------------------------------------------
  # Arithmetic tests
  #-------------------------------------------------------------

  # mqacc.h01: rd = rd + (rs1[15:0] * rs2[31:16]) >> 15 (Q15 format)
  # Test: 10 + (0x4000 * 0x4000) >> 15 = 10 + 8192 = 8202 (rs2 = 0x40000000)
  TEST_CASE( 2, x14, 8202, li x14, 10; li a1, 0x4000; li a2, 0x40000000; mqacc.h01 x14, a1, a2 );

  # Test: 0 + (0x2000 * 0x2000) >> 15 = 0 + 2048 = 2048
  TEST_CASE( 3, x14, 2048, li x14, 0; li a1, 0x2000; li a2, 0x20000000; mqacc.h01 x14, a1, a2 );

  # Test: 5 + (0x1000 * 0x1000) >> 15 = 5 + 512 = 517
  TEST_CASE( 4, x14, 517, li x14, 5; li a1, 0x1000; li a2, 0x10000000; mqacc.h01 x14, a1, a2 );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END

