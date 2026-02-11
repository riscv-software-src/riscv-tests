# See LICENSE for license details.

#*****************************************************************************
# pwmaccu_h.S
#-----------------------------------------------------------------------------
#
# Test pwmaccu.h instruction (packed widening multiply accumulate unsigned halfword).
# RV32-only instruction using register pairs for 64-bit accumulator.
# Each unsigned halfword in rs1 is multiplied with corresponding unsigned halfword in rs2,
# results are widened to 32-bit and accumulated.
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV32U
RVTEST_CODE_BEGIN

  #-------------------------------------------------------------
  # Arithmetic tests
  #-------------------------------------------------------------

  # pwmaccu.h rd, rs1, rs2
  # rd[31:0] += (unsigned)rs1.H[0] * (unsigned)rs2.H[0]
  # rd[63:32] += (unsigned)rs1.H[1] * (unsigned)rs2.H[1]
  # rd is a register pair (rd, rd+1)

  # Test 2: Simple accumulate
  # Accum = {10, 20}, rs1 = {2, 3}, rs2 = {4, 5}
  # Low: 20 + 3*5 = 35, High: 10 + 2*4 = 18
  TEST_CASE( 2, x14, 35, \
    li x14, 20; \
    li x15, 10; \
    li a1, 0x00020003; \
    li a2, 0x00040005; \
    pwmaccu.h x14, a1, a2 );
  TEST_CASE( 3, x15, 18, nop );

  # Test 4: Zero accumulator with simple multiply
  # Accum = {0, 0}, rs1 = {0x100, 0x100}, rs2 = {0x100, 0x100}
  # Low: 0x100*0x100 = 0x10000, High: 0x100*0x100 = 0x10000
  TEST_CASE( 4, x14, 0x10000, \
    li x14, 0; \
    li x15, 0; \
    li a1, 0x01000100; \
    li a2, 0x01000100; \
    pwmaccu.h x14, a1, a2 );
  TEST_CASE( 5, x15, 0x10000, nop );

  # Test 6: Large unsigned halfwords (0xFFFF = 65535)
  # Accum = {0, 0}, rs1 = {0xFFFF, 0xFFFF}, rs2 = {1, 1}
  # Low: 65535*1 = 65535 = 0xFFFF
  # High: 65535*1 = 65535 = 0xFFFF
  TEST_CASE( 6, x14, 0xFFFF, \
    li x14, 0; \
    li x15, 0; \
    li a1, 0xFFFFFFFF; \
    li a2, 0x00010001; \
    pwmaccu.h x14, a1, a2 );
  TEST_CASE( 7, x15, 0xFFFF, nop );

  # Test 8: Large product
  # Accum = {0, 0}, rs1 = {0xFFFF, 0xFFFF}, rs2 = {0xFFFF, 0xFFFF}
  # Low: 65535*65535 = 0xFFFE0001
  # High: 65535*65535 = 0xFFFE0001
  TEST_CASE( 8, x14, 0xFFFE0001, \
    li x14, 0; \
    li x15, 0; \
    li a1, 0xFFFFFFFF; \
    li a2, 0xFFFFFFFF; \
    pwmaccu.h x14, a1, a2 );
  TEST_CASE( 9, x15, 0xFFFE0001, nop );

  # Test 10: Accumulate to existing value
  # Accum = {100, 200}, rs1 = {10, 20}, rs2 = {5, 10}
  # Low: 200 + 20*10 = 400, High: 100 + 10*5 = 150
  TEST_CASE( 10, x14, 400, \
    li x14, 200; \
    li x15, 100; \
    li a1, 0x000A0014; \
    li a2, 0x0005000A; \
    pwmaccu.h x14, a1, a2 );
  TEST_CASE( 11, x15, 150, nop );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END

