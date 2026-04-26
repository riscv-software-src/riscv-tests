# See LICENSE for license details.

#*****************************************************************************
# mulu_w11.S
#-----------------------------------------------------------------------------
#
# Test mulu.w11 instruction (unsigned 32-bit multiply, high words, RV64 only).
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV64U
RVTEST_CODE_BEGIN

  #-------------------------------------------------------------
  # Arithmetic tests
  #-------------------------------------------------------------

  # mulu.w11 rd, rs1, rs2 = zext32(rs1[63:32]) * zext32(rs2[63:32])

  # Test case 1: 2 * 3 = 6 (both high words)
  TEST_RR_OP( 2, mulu.w11, 0x0000000000000006, 0x0000000200000000, 0x0000000300000000 );

  # Test case 2: Zero multiply
  TEST_RR_OP( 3, mulu.w11, 0x0000000000000000, 0x0000000000000000, 0x0000000500000000 );

  # Test case 3: 0x00010001 * 0x00020002 = 0x0000000200040002
  TEST_RR_OP( 4, mulu.w11, 0x0000000200040002, 0x0001000100000000, 0x0002000200000000 );

  # Test case 4: Large unsigned: 0xffffffff * 2 = 0x1fffffffe
  TEST_RR_OP( 5, mulu.w11, 0x00000001fffffffe, 0xffffffff00000000, 0x0000000200000000 );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END

