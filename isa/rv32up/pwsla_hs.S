# See LICENSE for license details.

#*****************************************************************************
# pwsla_hs.S
#-----------------------------------------------------------------------------
#
# Test pwsla.hs instruction (packed widening shift left arithmetic, halfword to word).
# RV32-only instruction. Widens each signed halfword to word and shifts left.
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
  # 1->2, 2->4 = Low: 0x00000004, High: 0x00000002
  TEST_RR_OP( 2, pwsla.hs, 0x00000004, 0x00010002, 1 );

  # Test 3: Shift by 16
  # rs1 = 0x00010002
  # 1<<16=0x00010000, 2<<16=0x00020000
  # Low: 0x00020000, High: 0x00010000
  TEST_RR_OP( 3, pwsla.hs, 0x00020000, 0x00010002, 16 );

  # Test 4: Negative values
  # rs1 = 0xFFFEFFFC (halfwords: -2, -4)
  # -2<<1=-4, -4<<1=-8
  # Low: 0xFFFFFFF8, High: 0xFFFFFFFC
  TEST_RR_OP( 4, pwsla.hs, 0xFFFFFFF8, 0xFFFEFFFC, 1 );

  # Test 5: Shift by 0 (just widen)
  # rs1 = 0x7FFF8000 (halfwords: 32767, -32768)
  # Low: 0xFFFF8000, High: 0x00007FFF
  TEST_RR_OP( 5, pwsla.hs, 0xFFFF8000, 0x7FFF8000, 0 );

  # Test 6: Zero input
  TEST_RR_OP( 6, pwsla.hs, 0x00000000, 0x00000000, 5 );

  # Test 7: All 0xFFFF (all -1)
  # -1 << 1 = -2 for each word
  TEST_RR_OP( 7, pwsla.hs, 0xFFFFFFFE, 0xFFFFFFFF, 1 );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END

