# See LICENSE for license details.

#*****************************************************************************
# psrari_dh.S
#-----------------------------------------------------------------------------
#
# Test psrari.dh instruction (packed shift right arithmetic rounding immediate, double-word, halfword).
# RV32-only instruction using register pairs for 64-bit operations.
# Shifts each signed halfword element right by an immediate value with rounding.
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
  # rs1 = 0x00020004 (halfwords: 2, 4)
  # shift = 1
  # Expected: 1, 2 = 0x00010002
  TEST_IMM_OP( 2, psrari.dh, 0x00010002, 0x00020004, 1 );

  # Test 3: Shift by 1, rounding needed (LSB=1)
  # rs1 = 0x00030005 (halfwords: 3, 5)
  # shift = 1, 3>>1=1+1=2, 5>>1=2+1=3
  # Expected: 2, 3 = 0x00020003
  TEST_IMM_OP( 3, psrari.dh, 0x00020003, 0x00030005, 1 );

  # Test 4: Shift negative with rounding
  # rs1 = 0xFFFDFFFB (signed halfwords: -3, -5)
  # shift = 1, -3>>1=-2+1=-1, -5>>1=-3+1=-2
  # Expected: -1, -2 = 0xFFFFFFFE
  TEST_IMM_OP( 4, psrari.dh, 0xFFFFFFFE, 0xFFFDFFFB, 1 );

  # Test 5: Shift by 0 (no change, no rounding)
  TEST_IMM_OP( 5, psrari.dh, 0x12345678, 0x12345678, 0 );

  # Test 6: Shift by 8 with rounding
  # rs1 = 0x01800380 (halfwords: 0x0180=384, 0x0380=896)
  # 384 >> 8 = 1, bit7=1, round: 1+1=2
  # 896 >> 8 = 3, bit7=1, round: 3+1=4
  # Expected: 0x00020004
  TEST_IMM_OP( 6, psrari.dh, 0x00020004, 0x01800380, 8 );

  # Test 7: Zero input
  TEST_IMM_OP( 7, psrari.dh, 0x00000000, 0x00000000, 5 );

  # Test 8: Max positive shift
  TEST_IMM_OP( 8, psrari.dh, 0x00000001, 0x7FFF7FFF, 15 );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END

