# See LICENSE for license details.

#*****************************************************************************
# wslai.S
#-----------------------------------------------------------------------------
#
# Test wslai instruction (widening shift left arithmetic immediate, word to double-word).
# RV32-only instruction. Sign-extends rs1 to 64 bits and shifts left by immediate.
# Result is stored in register pair (rd, rd+1).
# Note: rd must be an even register (register-pair constraint).
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV32U
RVTEST_CODE_BEGIN

  #-------------------------------------------------------------
  # Arithmetic tests
  #-------------------------------------------------------------

  # wslai rd, rs1, imm
  # rd (register pair) = sign-extended rs1 << imm
  # rd must be an even register

  # Test 2: Simple shift by 1 (positive)
  # rs1 = 0x00000001 (1)
  # shift = 1
  # Result: 2 = Low: 0x00000002
  TEST_CASE( 2, x14, 0x00000002, \
    li x10, 0x00000001; \
    wslai x14, x10, 1 );
  TEST_CASE( 3, x15, 0x00000000, nop );

  # Test 4: Shift by 31 (max shift)
  # rs1 = 0x00000001 (1)
  # shift = 31
  # Result: 0x80000000 = Low: 0x80000000, High: 0x00000000
  TEST_CASE( 4, x14, 0x80000000, \
    li x10, 0x00000001; \
    wslai x14, x10, 31 );
  TEST_CASE( 5, x15, 0x00000000, nop );

  # Test 6: Negative value shift
  # rs1 = 0xFFFFFFFF (-1)
  # shift = 1
  # Result: -2 = Low: 0xFFFFFFFE, High: 0xFFFFFFFF
  TEST_CASE( 6, x14, 0xFFFFFFFE, \
    li x10, 0xFFFFFFFF; \
    wslai x14, x10, 1 );
  TEST_CASE( 7, x15, 0xFFFFFFFF, nop );

  # Test 8: Negative value shift by 31
  # rs1 = 0xFFFFFFFF (-1)
  # shift = 31
  # Result: -1 << 31 = Low: 0x80000000, High: 0xFFFFFFFF
  TEST_CASE( 8, x14, 0x80000000, \
    li x10, 0xFFFFFFFF; \
    wslai x14, x10, 31 );
  TEST_CASE( 9, x15, 0xFFFFFFFF, nop );

  # Test 10: Shift by 0 (sign extend only)
  # rs1 = 0x80000000 (-2147483648)
  # shift = 0
  # Result: Low: 0x80000000, High: 0xFFFFFFFF
  TEST_CASE( 10, x14, 0x80000000, \
    li x10, 0x80000000; \
    wslai x14, x10, 0 );
  TEST_CASE( 11, x15, 0xFFFFFFFF, nop );

  # Test 12: Zero input
  TEST_CASE( 12, x14, 0x00000000, \
    li x10, 0x00000000; \
    wslai x14, x10, 5 );
  TEST_CASE( 13, x15, 0x00000000, nop );

  # Test 14: Positive value, larger shift
  # rs1 = 0x12345678
  # shift = 4
  # Result: 0x123456780 = Low: 0x23456780, High: 0x00000001
  TEST_CASE( 14, x14, 0x23456780, \
    li x10, 0x12345678; \
    wslai x14, x10, 4 );
  TEST_CASE( 15, x15, 0x00000001, nop );

  # Test 16: Large shift with negative value
  # rs1 = 0x80000001 (-2147483647)
  # shift = 8
  # Result: Low: 0x00000100, High: 0xFFFFFF80
  TEST_CASE( 16, x14, 0x00000100, \
    li x10, 0x80000001; \
    wslai x14, x10, 8 );
  TEST_CASE( 17, x15, 0xFFFFFF80, nop );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END

