# See LICENSE for license details.

#*****************************************************************************
# mul_w11.S
#-----------------------------------------------------------------------------
#
# Test mul.w11 instruction (signed 32-bit multiply, high words, RV64 only).
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV64U
RVTEST_CODE_BEGIN

  #-------------------------------------------------------------
  # Arithmetic tests
  #-------------------------------------------------------------

  # mul.w11 rd, rs1, rs2 = sext32(rs1[63:32]) * sext32(rs2[63:32])

  # Test case 1: 2 * 3 = 6 (both high words)
  TEST_RR_OP( 2, mul.w11, 0x0000000000000006, 0x0000000200000000, 0x0000000300000000 );

  # Test case 2: Zero multiply
  TEST_RR_OP( 3, mul.w11, 0x0000000000000000, 0x0000000000000000, 0x0000000500000000 );

  # Test case 3: 0x00010001 * 0x00020002 = 0x0000000200040002
  TEST_RR_OP( 4, mul.w11, 0x0000000200040002, 0x0001000100000000, 0x0002000200000000 );

  # Test case 4: Negative * positive: -2 * 3 = -6
  TEST_RR_OP( 5, mul.w11, 0xfffffffffffffffa, 0xfffffffe00000000, 0x0000000300000000 );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END

