# See LICENSE for license details.

#*****************************************************************************
# psshl_dhs.S
#-----------------------------------------------------------------------------
#
# Test psshl.dhs instruction (packed saturating shift left double-word halfword).
# RV32-only instruction using register pairs for 64-bit operations.
# Equivalent to psshl.hs on each 32-bit register in the pair.
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV32U
RVTEST_CODE_BEGIN

  #-------------------------------------------------------------
  # Arithmetic tests
  #-------------------------------------------------------------

  # psshl.dhs rd, rs1, rs2
  # Operates on register pair (rd, rd+1) and (rs1, rs1+1)
  # Equivalent to: psshl.hs rd, rs1, rs2; psshl.hs rd+1, rs1+1, rs2

  # Test case 1: Left shift without saturation
  # rs1 pair = 0x00050005_00050005, rs2 = 0x00000002
  # Expected: 0x00140014_00140014
  TEST_RR_OP_PAIR( 2, psshl.dhs, 0x0014001400140014, 0x0005000500050005, 2 );

  # Test case 2: Left shift with saturation
  # rs1 pair = 0x40004000_40004000, rs2 = 0x00000002
  # Expected: 0xFFFFFFFF_FFFFFFFF
  TEST_RR_OP_PAIR( 3, psshl.dhs, 0xFFFFFFFFFFFFFFFF, 0x4000400040004000, 2 );

  # Test case 3: Right shift (negative shamt)
  # rs1 pair = 0x80008000_80008000, rs2 = 0xFFFFFFFC (shift right by 4)
  # Expected: 0x08000800_08000800
  TEST_RR_OP_PAIR( 4, psshl.dhs, 0x0800080008000800, 0x8000800080008000, -4 );

  # Test case 4: Left shift by 0
  # rs1 pair = 0x12345678_9ABCDEF0, rs2 = 0x00000000
  # Expected: 0x12345678_9ABCDEF0
  TEST_RR_OP_PAIR( 5, psshl.dhs, 0x123456789ABCDEF0, 0x123456789ABCDEF0, 0 );

  # Test case 5: Saturation with maximum value
  # rs1 pair = 0x7FFF7FFF_7FFF7FFF, rs2 = 0x00000002
  # Expected: 0xFFFFFFFF_FFFFFFFF
  TEST_RR_OP_PAIR( 6, psshl.dhs, 0xFFFFFFFFFFFFFFFF, 0x7FFF7FFF7FFF7FFF, 2 );

  # Test case 6: Zero shifted
  # rs1 pair = 0x00000000_00000000, rs2 = 0x00000005
  # Expected: 0x00000000_00000000
  TEST_RR_OP_PAIR( 7, psshl.dhs, 0x0000000000000000, 0x0000000000000000, 5 );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END


