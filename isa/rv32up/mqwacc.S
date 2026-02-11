# See LICENSE for license details.

#*****************************************************************************
# mqwacc.S
#-----------------------------------------------------------------------------
#
# Test mqwacc instruction (packed multiply Q-format widening accumulate).
# RV32-only instruction using register pairs for 64-bit accumulator.
# rd = rd + ((signed)rs1 * (signed)rs2) >> 31
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV32U
RVTEST_CODE_BEGIN

  #-------------------------------------------------------------
  # Arithmetic tests
  #-------------------------------------------------------------

  # mqwacc rd, rs1, rs2
  # rd[63:0] = rd[63:0] + ((signed)rs1 * (signed)rs2) >> 31
  # rd is a register pair (rd, rd+1)

  # Test 2: Simple Q-format multiply accumulate
  # Accum = 10, rs1 = 0x40000000 (0.5 in Q31), rs2 = 0x40000000 (0.5 in Q31)
  # 0.5 * 0.5 = 0.25, in Q31: 0x40000000 * 0x40000000 >> 31 = 0x20000000
  # Result = 10 + 0x20000000 = 0x2000000A
  TEST_CASE( 2, x14, 0x2000000A, \
    li x14, 10; \
    li x15, 0; \
    li a1, 0x40000000; \
    li a2, 0x40000000; \
    mqwacc x14, a1, a2 );
  TEST_CASE( 3, x15, 0, nop );

  # Test 4: Zero accumulator
  # Accum = 0, rs1 = 0x7FFFFFFF (~1.0), rs2 = 0x40000000 (0.5)
  # Result ≈ 0x3FFFFFFF
  TEST_CASE( 4, x14, 0x3FFFFFFF, \
    li x14, 0; \
    li x15, 0; \
    li a1, 0x7FFFFFFF; \
    li a2, 0x40000000; \
    mqwacc x14, a1, a2 );
  TEST_CASE( 5, x15, 0, nop );

  # Test 6: Negative values
  # Accum = 100, rs1 = 0x80000000 (-1.0 in Q31), rs2 = 0x40000000 (0.5)
  # -1.0 * 0.5 = -0.5, >> 31 = 0xC0000000 (sign extended to 64-bit: -0x40000000)
  # Result = 100 + (-0x40000000) = 100 - 0x40000000
  TEST_CASE( 6, x14, 0xC0000064, \
    li x14, 100; \
    li x15, 0; \
    li a1, 0x80000000; \
    li a2, 0x40000000; \
    mqwacc x14, a1, a2 );
  TEST_CASE( 7, x15, 0xFFFFFFFF, nop );

  # Test 8: Both negative
  # Accum = 0, rs1 = 0x80000000 (-1.0), rs2 = 0x80000000 (-1.0)
  # -1.0 * -1.0 = 1.0, but with Q31 representation this saturates
  # 0x80000000 * 0x80000000 = 0x4000000000000000 >> 31 = 0x80000000
  TEST_CASE( 8, x14, 0x80000000, \
    li x14, 0; \
    li x15, 0; \
    li a1, 0x80000000; \
    li a2, 0x80000000; \
    mqwacc x14, a1, a2 );
  TEST_CASE( 9, x15, 0, nop );

  # Test 10: Small values
  # Accum = 1000, rs1 = 0x10000000 (0.125), rs2 = 0x10000000 (0.125)
  # 0.125 * 0.125 = 0.015625
  # 0x10000000 * 0x10000000 >> 31 = 0x02000000
  TEST_CASE( 10, x14, 0x020003E8, \
    li x14, 1000; \
    li x15, 0; \
    li a1, 0x10000000; \
    li a2, 0x10000000; \
    mqwacc x14, a1, a2 );
  TEST_CASE( 11, x15, 0, nop );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END

