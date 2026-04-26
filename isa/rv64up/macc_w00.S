# See LICENSE for license details.

#*****************************************************************************
# macc_w00.S
#-----------------------------------------------------------------------------
#
# Test macc.w00 instruction (signed 32-bit multiply-accumulate, low words, RV64 only).
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV64U
RVTEST_CODE_BEGIN

  #-------------------------------------------------------------
  # Arithmetic tests
  #-------------------------------------------------------------

  # macc.w00 rd, rs1, rs2 = rd + sext32(rs1[31:0]) * sext32(rs2[31:0])

  # Test case 1: 10 + 2 * 3 = 16
  TEST_CASE( 2, x14, 16, li x14, 10; li a1, 2; li a2, 3; macc.w00 x14, a1, a2 );

  # Test case 2: 0 + 4 * 5 = 20
  TEST_CASE( 3, x14, 20, li x14, 0; li a1, 4; li a2, 5; macc.w00 x14, a1, a2 );

  # Test case 3: 100 + (-2) * 3 = 94
  TEST_CASE( 4, x14, 94, li x14, 100; li a1, -2; li a2, 3; macc.w00 x14, a1, a2 );

  # Test case 4: 1000 + 10 * 10 = 1100
  TEST_CASE( 5, x14, 1100, li x14, 1000; li a1, 10; li a2, 10; macc.w00 x14, a1, a2 );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END

