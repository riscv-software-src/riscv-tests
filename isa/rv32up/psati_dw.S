# See LICENSE for license details.

#*****************************************************************************
# psati_dw.S
#-----------------------------------------------------------------------------
#
# Test psati.dw instruction (packed saturate immediate double-word word).
# RV32-only instruction using register pairs for 64-bit operations.
# Saturates each 32-bit element to signed (imm+1)-bit range.
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV32U
RVTEST_CODE_BEGIN

  #-------------------------------------------------------------
  # Basic tests - psati.dw saturates each word to imm+1 bits (signed)
  #-------------------------------------------------------------

  # psati.dw rd, rs1, imm5
  # Saturates each 32-bit element to signed (imm+1)-bit range

  # Test case 1: No saturation needed (value fits in 16 bits signed: -32768 to 32767)
  # rs1 = 0x0000000500000005 (5 in each word)
  # imm = 15 (saturate to 16 bits: -32768 to 32767)
  # Expected: 0x0000000500000005 (no change)
  TEST_IMM_OP( 2, psati.dw, 0x0000000500000005, 0x0000000500000005, 15 );

  # Test case 2: Positive saturation (value > max for 16 bits signed)
  # rs1 = 0x0001000000010000 (65536 in each word)
  # imm = 15 (saturate to 16 bits: max = 32767)
  # Expected: 0x00007fff00007fff (saturated to 32767)
  TEST_IMM_OP( 3, psati.dw, 0x00007fff00007fff, 0x0001000000010000, 15 );

  # Test case 3: Negative saturation (value < min for 16 bits signed)
  # rs1 = 0xffff0000ffff0000 (-65536 in each word)
  # imm = 15 (saturate to 16 bits: min = -32768)
  # Expected: 0xffff8000ffff8000 (-32768 in each word)
  TEST_IMM_OP( 4, psati.dw, 0xffff8000ffff8000, 0xffff0000ffff0000, 15 );

  # Test case 4: Zero remains zero
  TEST_IMM_OP( 5, psati.dw, 0x0000000000000000, 0x0000000000000000, 15 );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END

