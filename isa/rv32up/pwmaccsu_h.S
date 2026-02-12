# See LICENSE for license details.

#*****************************************************************************
# pwmaccsu_h.S
#-----------------------------------------------------------------------------
#
# Test pwmaccsu.h instruction (packed widening multiply accumulate signed-unsigned halfword).
# RV32-only instruction using register pairs for 64-bit accumulator.
# Each signed halfword in rs1 is multiplied with corresponding unsigned halfword in rs2,
# results are widened to 32-bit and accumulated.
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV32U
RVTEST_CODE_BEGIN

  #-------------------------------------------------------------
  # Arithmetic tests
  #-------------------------------------------------------------

  # pwmaccsu.h rd, rs1, rs2
  # rd[31:0] += (signed)rs1.H[0] * (unsigned)rs2.H[0]
  # rd[63:32] += (signed)rs1.H[1] * (unsigned)rs2.H[1]
  # rd is a register pair (rd, rd+1)

  # Test 2: Simple accumulate
  # Accum = {10, 20}, rs1 = {2, 3}, rs2 = {4, 5}
  # Low: 20 + 3*5 = 35, High: 10 + 2*4 = 18
  TEST_CASE( 2, x14, 35, \
    li x14, 20; \
    li x15, 10; \
    li a1, 0x00020003; \
    li a2, 0x00040005; \
    pwmaccsu.h x14, a1, a2 );
  TEST_CASE( 3, x15, 18, nop );

  # Test 4: Negative signed * positive unsigned
  # Accum = {100, 100}, rs1 = {-1, -2}, rs2 = {2, 3}
  # Low: 100 + (-2)*3 = 94
  # High: 100 + (-1)*2 = 98
  TEST_CASE( 4, x14, 94, \
    li x14, 100; \
    li x15, 100; \
    li a1, 0xFFFFFFFE; \
    li a2, 0x00020003; \
    pwmaccsu.h x14, a1, a2 );
  TEST_CASE( 5, x15, 98, nop );

  # Test 6: Positive signed * large unsigned (0xFFFF = 65535)
  # Accum = {0, 0}, rs1 = {1, 1}, rs2 = {0xFFFF, 0xFFFF}
  # Low: 0 + 1*65535 = 65535 = 0xFFFF
  # High: 0 + 1*65535 = 65535 = 0xFFFF
  TEST_CASE( 6, x14, 0xFFFF, \
    li x14, 0; \
    li x15, 0; \
    li a1, 0x00010001; \
    li a2, 0xFFFFFFFF; \
    pwmaccsu.h x14, a1, a2 );
  TEST_CASE( 7, x15, 0xFFFF, nop );

  # Test 8: Negative signed * large unsigned
  # Accum = {0, 0}, rs1 = {-1, -1}, rs2 = {2, 2}
  # Low: 0 + (-1)*2 = -2 = 0xFFFFFFFE (sign extended)
  # High: 0 + (-1)*2 = -2 = 0xFFFFFFFE
  TEST_CASE( 8, x14, 0xFFFFFFFE, \
    li x14, 0; \
    li x15, 0; \
    li a1, 0xFFFFFFFF; \
    li a2, 0x00020002; \
    pwmaccsu.h x14, a1, a2 );
  TEST_CASE( 9, x15, 0xFFFFFFFE, nop );

  # Test 10: Zero accumulator, simple multiply
  TEST_CASE( 10, x14, 30, \
    li x14, 0; \
    li x15, 0; \
    li a1, 0x00050006; \
    li a2, 0x00040005; \
    pwmaccsu.h x14, a1, a2 );
  TEST_CASE( 11, x15, 20, nop );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END

