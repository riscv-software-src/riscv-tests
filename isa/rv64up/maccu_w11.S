# See LICENSE for license details.

#*****************************************************************************
# maccu_w11.S
#-----------------------------------------------------------------------------
#
# Test maccu.w11 instruction (unsigned 32-bit multiply-accumulate, high words, RV64 only).
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV64U
RVTEST_CODE_BEGIN

  #-------------------------------------------------------------
  # Arithmetic tests
  #-------------------------------------------------------------

  # maccu.w11 rd, rs1, rs2 = rd + zext32(rs1[63:32]) * zext32(rs2[63:32])

  # Test case 1: 10 + 2 * 3 = 16 (both high words)
  TEST_CASE( 2, x14, 16, li x14, 10; li a1, 0x0000000200000000; li a2, 0x0000000300000000; maccu.w11 x14, a1, a2 );

  # Test case 2: 0 + 4 * 5 = 20
  TEST_CASE( 3, x14, 20, li x14, 0; li a1, 0x0000000400000000; li a2, 0x0000000500000000; maccu.w11 x14, a1, a2 );

  # Test case 3: 100 + 0xffffffff * 2 = 100 + 0x1fffffffe = 0x200000062
  TEST_CASE( 4, x14, 0x200000062, li x14, 100; li a1, 0xffffffff00000000; li a2, 0x0000000200000000; maccu.w11 x14, a1, a2 );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END

