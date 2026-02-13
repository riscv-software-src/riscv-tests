# See LICENSE for license details.

#*****************************************************************************
# mulsu_w11.S
#-----------------------------------------------------------------------------
#
# Test mulsu.w11 instruction (signed*unsigned 32-bit multiply, high words, RV64 only).
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV64U
RVTEST_CODE_BEGIN

  #-------------------------------------------------------------
  # Arithmetic tests
  #-------------------------------------------------------------

  # mulsu.w11 rd, rs1, rs2 = sext32(rs1[63:32]) * zext32(rs2[63:32])

  # Test case 1: Simple multiply 2 * 3 = 6 (both high words)
  TEST_RR_OP( 2, mulsu.w11, 0x0000000000000006, 0x0000000200000000, 0x0000000300000000 );

  # Test case 2: Zero multiply
  TEST_RR_OP( 3, mulsu.w11, 0x0000000000000000, 0x0000000000000000, 0x0000000500000000 );

  # Test case 3: Negative signed * positive unsigned: -2 * 3 = -6
  TEST_RR_OP( 4, mulsu.w11, 0xfffffffffffffffa, 0xfffffffe00000000, 0x0000000300000000 );

  # Test case 4: Negative signed * large unsigned: -1 * 0xffffffff = -0xffffffff
  TEST_RR_OP( 5, mulsu.w11, 0xffffffff00000001, 0xffffffff00000000, 0xffffffff00000000 );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END

