# See LICENSE for license details.

#*****************************************************************************
# wsll.S
#-----------------------------------------------------------------------------
#
# Test wsll instruction (widening shift left logical, word to double-word).
# RV32-only instruction. Zero-extends rs1 to 64 bits and shifts left by rs2[5:0].
# Result is stored in register pair (rd, rd+1).
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV32U
RVTEST_CODE_BEGIN

  #-------------------------------------------------------------
  # Arithmetic tests
  #-------------------------------------------------------------

  # Test 2: Simple shift by 1
  # rs1 = 0x00000001 (1)
  # shift = 1
  # Result: 2 = Low: 0x00000002
  TEST_RR_OP( 2, wsll, 0x00000002, 0x00000001, 1 );

  # Test 3: Shift by 32
  # rs1 = 0x00000001 (1)
  # shift = 32
  # Result: 0x100000000 = Low: 0x00000000, High: 0x00000001
  TEST_RR_OP( 3, wsll, 0x00000000, 0x00000001, 32 );

  # Test 4: High bit value shift (unsigned)
  # rs1 = 0xFFFFFFFF (4294967295 unsigned)
  # shift = 1
  # Result: 0x1FFFFFFFE = Low: 0xFFFFFFFE
  TEST_RR_OP( 4, wsll, 0xFFFFFFFE, 0xFFFFFFFF, 1 );

  # Test 5: High bit value shift by 32 (unsigned)
  # rs1 = 0xFFFFFFFF (4294967295 unsigned)
  # shift = 32
  # Result: 0xFFFFFFFF00000000 = Low: 0x00000000, High: 0xFFFFFFFF
  TEST_RR_OP( 5, wsll, 0x00000000, 0xFFFFFFFF, 32 );

  # Test 6: Shift by 0 (zero extend only)
  # rs1 = 0x80000000 (2147483648 unsigned)
  # shift = 0
  # Result: Low: 0x80000000, High: 0x00000000
  TEST_RR_OP( 6, wsll, 0x80000000, 0x80000000, 0 );

  # Test 7: Zero input
  TEST_RR_OP( 7, wsll, 0x00000000, 0x00000000, 5 );

  # Test 8: Larger shift
  # rs1 = 0x12345678
  # shift = 4
  # Result: 0x123456780 = Low: 0x23456780
  TEST_RR_OP( 8, wsll, 0x23456780, 0x12345678, 4 );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END

