# See LICENSE for license details.

#*****************************************************************************
# pwmacc_h.S
#-----------------------------------------------------------------------------
#
# Test pwmacc.h instruction (packed widening multiply accumulate halfword).
# RV32-only instruction using register pairs for 64-bit accumulator.
# Each halfword in rs1 is multiplied with corresponding halfword in rs2,
# results are widened to 32-bit and accumulated.
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV32U
RVTEST_CODE_BEGIN

  #-------------------------------------------------------------
  # Arithmetic tests
  #-------------------------------------------------------------

  # pwmacc.h rd, rs1, rs2
  # rd[31:0] += (signed)rs1.H[0] * (signed)rs2.H[0]
  # rd[63:32] += (signed)rs1.H[1] * (signed)rs2.H[1]
  # rd is a register pair (rd, rd+1)

  # Test 2: Simple accumulate
  # Accum = {10, 20}, rs1 = {2, 3}, rs2 = {4, 5}
  # Low: 20 + 3*5 = 20 + 15 = 35, High: 10 + 2*4 = 10 + 8 = 18
  TEST_CASE( 2, x14, 35, \
    li x14, 20; \
    li x15, 10; \
    li a1, 0x00020003; \
    li a2, 0x00040005; \
    pwmacc.h x14, a1, a2 );
  TEST_CASE( 3, x15, 18, nop );

  # Test 4: Zero accumulator
  # Accum = {0, 0}, rs1 = {0x100, 0x100}, rs2 = {0x100, 0x100}
  # Low: 0x100*0x100 = 0x10000, High: 0x100*0x100 = 0x10000
  TEST_CASE( 4, x14, 0x10000, \
    li x14, 0; \
    li x15, 0; \
    li a1, 0x01000100; \
    li a2, 0x01000100; \
    pwmacc.h x14, a1, a2 );
  TEST_CASE( 5, x15, 0x10000, nop );

  # Test 6: Negative values
  # Accum = {100, 100}, rs1 = {-1, -2}, rs2 = {2, 3}
  # Low: 100 + (-2)*3 = 100 - 6 = 94
  # High: 100 + (-1)*2 = 100 - 2 = 98
  TEST_CASE( 6, x14, 94, \
    li x14, 100; \
    li x15, 100; \
    li a1, 0xFFFFFFFE; \
    li a2, 0x00020003; \
    pwmacc.h x14, a1, a2 );
  TEST_CASE( 7, x15, 98, nop );

  # Test 8: Both negative
  # Accum = {10, 10}, rs1 = {-2, -3}, rs2 = {-4, -5}
  # Low: 10 + (-3)*(-5) = 10 + 15 = 25
  # High: 10 + (-2)*(-4) = 10 + 8 = 18
  TEST_CASE( 8, x14, 25, \
    li x14, 10; \
    li x15, 10; \
    li a1, 0xFFFEFFFD; \
    li a2, 0xFFFCFFFB; \
    pwmacc.h x14, a1, a2 );
  TEST_CASE( 9, x15, 18, nop );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END

