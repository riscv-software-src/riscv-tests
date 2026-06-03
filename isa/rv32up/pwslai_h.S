# See LICENSE for license details.

#*****************************************************************************
# pwslai_h.S
#-----------------------------------------------------------------------------
#
# Test pwslai.h instruction (packed widening shift left arithmetic immediate, halfword to word).
# RV32-only instruction. Widens each signed halfword to word and shifts left by immediate.
# Result is stored in register pair (rd, rd+1).
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV32U
RVTEST_CODE_BEGIN

  #-------------------------------------------------------------
  # Arithmetic tests
  #-------------------------------------------------------------

  # Test 2: Simple widening shift by 1
  # rs1 = 0x00010002 (halfwords: 1, 2)
  # Each halfword sign-extended to word, then shifted left by 1
  # 1->2, 2->4 = Low: 0x00000004
  TEST_IMM_OP( 2, pwslai.h, 0x00000004, 0x00010002, 1 );

  # Test 3: Shift by 16
  # rs1 = 0x00010002
  # 1<<16=0x00010000, 2<<16=0x00020000
  # Low: 0x00020000
  TEST_IMM_OP( 3, pwslai.h, 0x00020000, 0x00010002, 16 );

  # Test 4: Negative values
  # rs1 = 0xFFFEFFFC (halfwords: -2, -4)
  # -2<<1=-4, -4<<1=-8
  # Low: 0xFFFFFFF8
  TEST_IMM_OP( 4, pwslai.h, 0xFFFFFFF8, 0xFFFEFFFC, 1 );

  # Test 5: Shift by 0 (just widen)
  # rs1 = 0x7FFF8000 (halfwords: 32767, -32768)
  # Low: 0xFFFF8000
  TEST_IMM_OP( 5, pwslai.h, 0xFFFF8000, 0x7FFF8000, 0 );

  # Test 6: Zero input
  TEST_IMM_OP( 6, pwslai.h, 0x00000000, 0x00000000, 5 );

  # Test 7: All 0xFFFF (all -1)
  # -1 << 1 = -2 for each word
  TEST_IMM_OP( 7, pwslai.h, 0xFFFFFFFE, 0xFFFFFFFF, 1 );

  # Test 8: Shift by 8
  TEST_IMM_OP( 8, pwslai.h, 0x00000200, 0x00010002, 8 );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END

