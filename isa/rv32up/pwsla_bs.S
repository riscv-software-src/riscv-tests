# See LICENSE for license details.

#*****************************************************************************
# pwsla_bs.S
#-----------------------------------------------------------------------------
#
# Test pwsla.bs instruction (packed widening shift left arithmetic, byte to halfword).
# RV32-only instruction. Widens each signed byte to halfword and shifts left.
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
  # rs1 = 0x01020304 (bytes: 1, 2, 3, 4)
  # Each byte sign-extended to halfword, then shifted left by 1
  # 1->2, 2->4, 3->6, 4->8 = 0x00020004, 0x00060008
  TEST_RR_OP( 2, pwsla.bs, 0x00060008, 0x01020304, 1 );

  # Test 3: Shift by 8
  # rs1 = 0x01020304
  # 1<<8=0x0100, 2<<8=0x0200, 3<<8=0x0300, 4<<8=0x0400
  # Low word: 0x03000400, High word: 0x01000200
  TEST_RR_OP( 3, pwsla.bs, 0x03000400, 0x01020304, 8 );

  # Test 4: Negative values
  # rs1 = 0xFEFDFCFB (bytes: -2, -3, -4, -5)
  # -2<<1=-4, -3<<1=-6, -4<<1=-8, -5<<1=-10
  # Low word: 0xFFF8FFF6, High word: 0xFFFCFFFA
  TEST_RR_OP( 4, pwsla.bs, 0xFFF8FFF6, 0xFEFDFCFB, 1 );

  # Test 5: Shift by 0 (just widen)
  # rs1 = 0x7F80017F (bytes: 127, -128, 1, 127)
  # Low word: 0x0001007F, High word: 0x007FFF80
  TEST_RR_OP( 5, pwsla.bs, 0x0001007F, 0x7F80017F, 0 );

  # Test 6: Zero input
  TEST_RR_OP( 6, pwsla.bs, 0x00000000, 0x00000000, 5 );

  # Test 7: All 0xFF (all -1)
  # -1 << 1 = -2 for each halfword
  TEST_RR_OP( 7, pwsla.bs, 0xFFFEFFFE, 0xFFFFFFFF, 1 );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END

