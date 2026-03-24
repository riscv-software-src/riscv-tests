# See LICENSE for license details.

#*****************************************************************************
# psshl_dws.S
#-----------------------------------------------------------------------------
#
# Test psshl.dws instruction (packed saturating shift left double-word word).
# RV32-only instruction using register pairs for 64-bit operations.
# Equivalent to sshl on each 32-bit register in the pair.
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV32U
RVTEST_CODE_BEGIN

  #-------------------------------------------------------------
  # Arithmetic tests
  #-------------------------------------------------------------

  # psshl.dws rd, rs1, rs2
  # Operates on register pair (rd, rd+1) and (rs1, rs1+1)
  # Equivalent to: sshl rd, rs1, rs2; sshl rd+1, rs1+1, rs2

  # Test case 1: Left shift without saturation
  # rs1 pair = 0x00000005_00000005, rs2 = 0x00000002
  # Expected: 0x00000014_00000014
  TEST_RR_OP_PAIR( 2, psshl.dws, 0x0000001400000014, 0x0000000500000005, 2 );

  # Test case 2: Left shift with saturation
  # rs1 pair = 0x40000000_40000000, rs2 = 0x00000002
  # Expected: 0xFFFFFFFF_FFFFFFFF
  TEST_RR_OP_PAIR( 3, psshl.dws, 0xFFFFFFFFFFFFFFFF, 0x4000000040000000, 2 );

  # Test case 3: Right shift (negative shamt)
  # rs1 pair = 0x80000000_80000000, rs2 = 0xFFFFFFFC (shift right by 4)
  # Expected: 0x08000000_08000000
  TEST_RR_OP_PAIR( 4, psshl.dws, 0x0800000008000000, 0x8000000080000000, -4 );

  # Test case 4: Left shift by 0
  # rs1 pair = 0x12345678_9ABCDEF0, rs2 = 0x00000000
  # Expected: 0x12345678_9ABCDEF0
  TEST_RR_OP_PAIR( 5, psshl.dws, 0x123456789ABCDEF0, 0x123456789ABCDEF0, 0 );

  # Test case 5: Saturation with maximum value
  # rs1 pair = 0x7FFFFFFF_7FFFFFFF, rs2 = 0x00000002
  # Expected: 0xFFFFFFFF_FFFFFFFF
  TEST_RR_OP_PAIR( 6, psshl.dws, 0xFFFFFFFFFFFFFFFF, 0x7FFFFFFF7FFFFFFF, 2);

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END

