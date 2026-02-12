# See LICENSE for license details.

#*****************************************************************************
# psrari_dw.S
#-----------------------------------------------------------------------------
#
# Test psrari.dw instruction (packed shift right arithmetic rounding immediate, double-word, word).
# RV32-only instruction using register pairs for 64-bit operations.
# Shifts each signed word element right by an immediate value with rounding.
# Round = (shifted_out_bit) ? 1 : 0, added to result.
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV32U
RVTEST_CODE_BEGIN

  #-------------------------------------------------------------
  # Arithmetic tests
  #-------------------------------------------------------------

  # Test 2: Shift by 1, no rounding needed (LSB=0)
  # rs1 = 0x00000002 (word: 2)
  # shift = 1
  # Expected: 1 = 0x00000001
  TEST_IMM_OP( 2, psrari.dw, 0x00000001, 0x00000002, 1 );

  # Test 3: Shift by 1, rounding needed (LSB=1)
  # rs1 = 0x00000003 (word: 3)
  # shift = 1, 3>>1=1+1=2
  # Expected: 2 = 0x00000002
  TEST_IMM_OP( 3, psrari.dw, 0x00000002, 0x00000003, 1 );

  # Test 4: Shift negative with rounding
  # rs1 = 0xFFFFFFFD (signed word: -3)
  # shift = 1, -3>>1=-2+1=-1
  # Expected: -1 = 0xFFFFFFFF
  TEST_IMM_OP( 4, psrari.dw, 0xFFFFFFFF, 0xFFFFFFFD, 1 );

  # Test 5: Shift by 0 (no change, no rounding)
  TEST_IMM_OP( 5, psrari.dw, 0x12345678, 0x12345678, 0 );

  # Test 6: Shift by 16 with rounding
  # rs1 = 0x00018000 (word: 0x18000 = 98304)
  # 98304 >> 16 = 1, bit15=1, round: 1+1=2
  # Expected: 0x00000002
  TEST_IMM_OP( 6, psrari.dw, 0x00000002, 0x00018000, 16 );

  # Test 7: Zero input
  TEST_IMM_OP( 7, psrari.dw, 0x00000000, 0x00000000, 5 );

  # Test 8: Max positive shift
  TEST_IMM_OP( 8, psrari.dw, 0x00000001, 0x7FFFFFFF, 31 );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END

