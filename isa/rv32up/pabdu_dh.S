# See LICENSE for license details.

#*****************************************************************************
# pabdu_dh.S
#-----------------------------------------------------------------------------
#
# Test pabdu.dh instruction (Packed Unsigned Absolute Difference - Double-word Halfword, RV32 only).
# Note: rd and rs1 must be even registers (register-pair constraint).
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV32U
RVTEST_CODE_BEGIN

  # pabdu.dh rd, rs1, rs2
  # Computes |rs1[i] - rs2[i]| for each unsigned halfword element (signed comparison)
  # rd and rs1 must be even registers

  # Test case 2: Basic test - small positive differences
  # rs1 = 0x0004000300020001, rs2 = 0x0002000100000000
  # Result low: 0x00020001, Result high: 0x00020002
  TEST_CASE( 2, x14, 0x00020001, \
    li x10, 0x00020001; \
    li x11, 0x00040003; \
    li x12, 0x00000000; \
    li x13, 0x00020001; \
    pabdu.dh x14, x10, x12 );
  TEST_CASE( 3, x15, 0x00020002, nop );

  # Test case 4: Both operands same - result should be all zeros
  TEST_CASE( 4, x14, 0x00000000, \
    li x10, 0x12345678; \
    li x11, 0x12345678; \
    li x12, 0x12345678; \
    li x13, 0x12345678; \
    pabdu.dh x14, x10, x12 );
  TEST_CASE( 5, x15, 0x00000000, nop );

  # Test case 6: Small values only
  # rs1 = 0x000A000A000A000A (10), rs2 = 0x0005000500050005 (5)
  # Result = 5
  TEST_CASE( 6, x14, 0x00050005, \
    li x10, 0x000a000a; \
    li x11, 0x000a000a; \
    li x12, 0x00050005; \
    li x13, 0x00050005; \
    pabdu.dh x14, x10, x12 );
  TEST_CASE( 7, x15, 0x00050005, nop );

  # Test case 8: High value (0x8000) which is -32768 as signed
  # rs1 = 0x8000800080008000 (32768 unsigned, -32768 signed), rs2 = 0x0001000100010001 (1)
  # result = 0x8000 - 0x0001 = 0x7FFF
  TEST_CASE( 8, x14, 0x7fff7fff, \
    li x10, 0x80008000; \
    li x11, 0x80008000; \
    li x12, 0x00010001; \
    li x13, 0x00010001; \
    pabdu.dh x14, x10, x12 );
  TEST_CASE( 9, x15, 0x7fff7fff, nop );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END

