# See LICENSE for license details.

#*****************************************************************************
# wmaccu.S
#-----------------------------------------------------------------------------
#
# Test wmaccu instruction (widening multiply accumulate unsigned).
# RV32-only instruction using register pairs for 64-bit accumulator.
# rd = rd + (unsigned)rs1 * (unsigned)rs2
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV32U
RVTEST_CODE_BEGIN

  #-------------------------------------------------------------
  # Arithmetic tests
  #-------------------------------------------------------------

  # wmaccu rd, rs1, rs2
  # rd[63:0] = rd[63:0] + (unsigned)rs1[31:0] * (unsigned)rs2[31:0]
  # rd is a register pair (rd, rd+1)

  # Test 2: Simple accumulate
  # Accum = 10, 3 * 4 = 12, result = 22
  TEST_CASE( 2, x14, 22, \
    li x14, 10; \
    li x15, 0; \
    li a1, 3; \
    li a2, 4; \
    wmaccu x14, a1, a2 );
  TEST_CASE( 3, x15, 0, nop );

  # Test 4: Accumulate with larger values
  # Accum = 100, 0x100 * 0x100 = 0x10000, result = 100 + 0x10000 = 0x10064
  TEST_CASE( 4, x14, 0x10064, \
    li x14, 100; \
    li x15, 0; \
    li a1, 0x100; \
    li a2, 0x100; \
    wmaccu x14, a1, a2 );
  TEST_CASE( 5, x15, 0, nop );

  # Test 6: Large unsigned values (0xFFFFFFFF * 1)
  # Accum = 0, 0xFFFFFFFF * 1 = 0xFFFFFFFF
  TEST_CASE( 6, x14, 0xFFFFFFFF, \
    li x14, 0; \
    li x15, 0; \
    li a1, 0xFFFFFFFF; \
    li a2, 1; \
    wmaccu x14, a1, a2 );
  TEST_CASE( 7, x15, 0, nop );

  # Test 8: Zero accumulator
  # Accum = 0, 5 * 6 = 30, result = 30
  TEST_CASE( 8, x14, 30, \
    li x14, 0; \
    li x15, 0; \
    li a1, 5; \
    li a2, 6; \
    wmaccu x14, a1, a2 );
  TEST_CASE( 9, x15, 0, nop );

  # Test 10: Large product requiring 64-bit
  # Accum = 0, 0x10000 * 0x10000 = 0x100000000
  TEST_CASE( 10, x14, 0, \
    li x14, 0; \
    li x15, 0; \
    li a1, 0x10000; \
    li a2, 0x10000; \
    wmaccu x14, a1, a2 );
  TEST_CASE( 11, x15, 1, nop );

  # Test 12: Maximum unsigned * 2
  # Accum = 0, 0xFFFFFFFF * 2 = 0x1FFFFFFFE
  TEST_CASE( 12, x14, 0xFFFFFFFE, \
    li x14, 0; \
    li x15, 0; \
    li a1, 0xFFFFFFFF; \
    li a2, 2; \
    wmaccu x14, a1, a2 );
  TEST_CASE( 13, x15, 1, nop );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END

