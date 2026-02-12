# See LICENSE for license details.

#*****************************************************************************
# pmqrwacc_h.S
#-----------------------------------------------------------------------------
#
# Test pmqrwacc.h instruction (packed multiply Q-format rounding widening accumulate halfword).
# Assembler mnemonic is mqrwacc.h
# RV32-only instruction using register pairs for 64-bit accumulator.
# Each halfword in rs1 is multiplied with corresponding halfword in rs2 in Q15 format,
# with rounding before shift, results are widened to 32-bit and accumulated.
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV32U
RVTEST_CODE_BEGIN

  #-------------------------------------------------------------
  # Arithmetic tests
  #-------------------------------------------------------------

  # mqrwacc.h rd, rs1, rs2
  # rd[31:0] += ((signed)rs1.H[0] * (signed)rs2.H[0] + 0x4000) >> 15
  # rd[63:32] += ((signed)rs1.H[1] * (signed)rs2.H[1] + 0x4000) >> 15
  # rd is a register pair (rd, rd+1)

  # Test 2: Simple Q15 rounding multiply accumulate
  # Accum = {10, 20}, rs1 = {0x4000, 0x4000} (0.5 in Q15), rs2 = {0x4000, 0x4000} (0.5)
  # 0.5 * 0.5 + round = 0.25, >> 15: (0x4000 * 0x4000 + 0x4000) >> 15 = 0x2000
  # Low: 20 + 0x2000 = 0x2014, High: 10 + 0x2000 = 0x200A
  TEST_CASE( 2, x14, 0x2014, \
    li x14, 20; \
    li x15, 10; \
    li a1, 0x40004000; \
    li a2, 0x40004000; \
    mqrwacc.h x14, a1, a2 );
  TEST_CASE( 3, x15, 0x200A, nop );

  # Test 4: Zero accumulator with rounding
  # Accum = {0, 0}, rs1 = {0x7FFF, 0x7FFF} (~1.0), rs2 = {0x4000, 0x4000} (0.5)
  # With rounding: result = 0x4000 for each
  TEST_CASE( 4, x14, 0x4000, \
    li x14, 0; \
    li x15, 0; \
    li a1, 0x7FFF7FFF; \
    li a2, 0x40004000; \
    mqrwacc.h x14, a1, a2 );
  TEST_CASE( 5, x15, 0x4000, nop );

  # Test 6: Negative values with rounding
  # Accum = {100, 100}, rs1 = {0x8000, 0x8000} (-1.0 in Q15), rs2 = {0x4000, 0x4000} (0.5)
  # -1.0 * 0.5 + rounding -> 0xFFFFC000
  # Low: 100 + 0xFFFFC000 = 0xFFFFC064
  TEST_CASE( 6, x14, 0xFFFFC064, \
    li x14, 100; \
    li x15, 100; \
    li a1, 0x80008000; \
    li a2, 0x40004000; \
    mqrwacc.h x14, a1, a2 );
  TEST_CASE( 7, x15, 0xFFFFC064, nop );

  # Test 8: Both negative with rounding
  # Accum = {0, 0}, rs1 = {0x8000, 0x8000} (-1.0), rs2 = {0x8000, 0x8000} (-1.0)
  # -1.0 * -1.0 with rounding in Q15
  # (0x8000 * 0x8000 + 0x4000) >> 15 = 0x4001
  TEST_CASE( 8, x14, 0x4001, \
    li x14, 0; \
    li x15, 0; \
    li a1, 0x80008000; \
    li a2, 0x80008000; \
    mqrwacc.h x14, a1, a2 );
  TEST_CASE( 9, x15, 0x4001, nop );

  # Test 10: Small positive values with rounding
  # Accum = {1000, 2000}, rs1 = {0x1000, 0x1000} (0.125), rs2 = {0x1000, 0x1000} (0.125)
  # 0.125 * 0.125 + rounding, >> 15: (0x1000 * 0x1000 + 0x4000) >> 15 = 0x200
  # Low: 2000 + 0x200 = 2512, High: 1000 + 0x200 = 1512
  TEST_CASE( 10, x14, 2512, \
    li x14, 2000; \
    li x15, 1000; \
    li a1, 0x10001000; \
    li a2, 0x10001000; \
    mqrwacc.h x14, a1, a2 );
  TEST_CASE( 11, x15, 1512, nop );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END

