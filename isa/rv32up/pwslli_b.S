# See LICENSE for license details.

#*****************************************************************************
# pwslli_b.S
#-----------------------------------------------------------------------------
#
# Test pwslli.b instruction (packed widening shift left logical immediate, byte to halfword).
# RV32-only instruction. Widens each unsigned byte to halfword and shifts left by immediate.
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
  # Each byte zero-extended to halfword, then shifted left by 1
  # 1->2, 2->4, 3->6, 4->8 = 0x00060008 (low)
  TEST_IMM_OP( 2, pwslli.b, 0x00060008, 0x01020304, 1 );

  # Test 3: Shift by 8
  # rs1 = 0x01020304
  # 1<<8=0x0100, 2<<8=0x0200, 3<<8=0x0300, 4<<8=0x0400
  # Low word: 0x03000400
  TEST_IMM_OP( 3, pwslli.b, 0x03000400, 0x01020304, 8 );

  # Test 4: High byte values (unsigned)
  # rs1 = 0xFEFDFCFB (bytes: 254, 253, 252, 251)
  # 254<<1=508, 253<<1=506, 252<<1=504, 251<<1=502
  # Low word: 0x01F801F6
  TEST_IMM_OP( 4, pwslli.b, 0x01F801F6, 0xFEFDFCFB, 1 );

  # Test 5: Shift by 0 (just widen)
  # rs1 = 0xFF800180 (bytes: 255, 128, 1, 128)
  # Low word: 0x00010080
  TEST_IMM_OP( 5, pwslli.b, 0x00010080, 0xFF800180, 0 );

  # Test 6: Zero input
  TEST_IMM_OP( 6, pwslli.b, 0x00000000, 0x00000000, 5 );

  # Test 7: All 0xFF
  # 255 << 1 = 510 = 0x01FE for each halfword
  TEST_IMM_OP( 7, pwslli.b, 0x01FE01FE, 0xFFFFFFFF, 1 );

  # Test 8: Shift by 4
  TEST_IMM_OP( 8, pwslli.b, 0x00300040, 0x01020304, 4 );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END

