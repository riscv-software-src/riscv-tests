# See LICENSE for license details.

#*****************************************************************************
# psra_dhs.S
#-----------------------------------------------------------------------------
#
# Test psra.dhs instruction (packed shift right arithmetic, double-word, halfword, by register).
# RV32-only instruction using register pairs for 64-bit operations.
# Shifts each signed halfword element right by the amount in rs2, with sign extension.
# Note: rd and rs1 must be even registers (register-pair constraint).
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV32U
RVTEST_CODE_BEGIN

  #-------------------------------------------------------------
  # Arithmetic tests
  #-------------------------------------------------------------

  # psra.dhs rd, rs1, rs2
  # rd (register pair) = rs1 (register pair) >> rs2 (per halfword, arithmetic)
  # rd and rs1 must be even registers

  # Test 2: Shift positive values by 1
  # rs1 = 0x0002000400020004 (halfwords: 2, 4)
  # shift = 1
  # Expected: 1, 2 = 0x00010002
  TEST_CASE( 2, x14, 0x00010002, \
    li x10, 0x00020004; \
    li x11, 0x00020004; \
    li x12, 1; \
    psra.dhs x14, x10, x12 );
  TEST_CASE( 3, x15, 0x00010002, nop );

  # Test 4: Shift negative values by 1 (sign extension)
  # rs1 = 0xFFFEFFFCFFFEFFFC (signed halfwords: -2, -4)
  # shift = 1
  # Expected: -1, -2 = 0xFFFFFFFE
  TEST_CASE( 4, x14, 0xFFFFFFFE, \
    li x10, 0xFFFEFFFC; \
    li x11, 0xFFFEFFFC; \
    li x12, 1; \
    psra.dhs x14, x10, x12 );
  TEST_CASE( 5, x15, 0xFFFFFFFE, nop );

  # Test 6: Shift by 8
  # rs1 = 0x8000800080008000 (all -32768)
  # shift = 8
  # Expected: 0xFF80FF80 (-128 per halfword)
  TEST_CASE( 6, x14, 0xFF80FF80, \
    li x10, 0x80008000; \
    li x11, 0x80008000; \
    li x12, 8; \
    psra.dhs x14, x10, x12 );
  TEST_CASE( 7, x15, 0xFF80FF80, nop );

  # Test 8: Shift by 0 (no change)
  TEST_CASE( 8, x14, 0x12345678, \
    li x10, 0x12345678; \
    li x11, 0x12345678; \
    li x12, 0; \
    psra.dhs x14, x10, x12 );
  TEST_CASE( 9, x15, 0x12345678, nop );

  # Test 10: Shift by 15 (sign fill)
  # rs1 = 0x8000800080008000 (all -32768)
  # shift = 15
  # Expected: 0xFFFFFFFF (all -1)
  TEST_CASE( 10, x14, 0xFFFFFFFF, \
    li x10, 0x80008000; \
    li x11, 0x80008000; \
    li x12, 15; \
    psra.dhs x14, x10, x12 );
  TEST_CASE( 11, x15, 0xFFFFFFFF, nop );

  # Test 12: Shift positive by 15
  # rs1 = 0x7FFF7FFF7FFF7FFF (all 32767)
  # shift = 15
  # Expected: 0x00000000
  TEST_CASE( 12, x14, 0x00000000, \
    li x10, 0x7FFF7FFF; \
    li x11, 0x7FFF7FFF; \
    li x12, 15; \
    psra.dhs x14, x10, x12 );
  TEST_CASE( 13, x15, 0x00000000, nop );

  # Test 14: Zero input
  TEST_CASE( 14, x14, 0x00000000, \
    li x10, 0x00000000; \
    li x11, 0x00000000; \
    li x12, 5; \
    psra.dhs x14, x10, x12 );
  TEST_CASE( 15, x15, 0x00000000, nop );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END

