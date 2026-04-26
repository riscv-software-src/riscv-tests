# See LICENSE for license details.

#*****************************************************************************
# psrl_dhs.S
#-----------------------------------------------------------------------------
#
# Test psrl.dhs instruction (packed shift right logical, double-word, halfword, by register).
# RV32-only instruction using register pairs for 64-bit operations.
# Shifts each unsigned halfword element right by the amount in rs2[7:0].
# Note: rd and rs1 must be even registers (register-pair constraint).
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV32U
RVTEST_CODE_BEGIN

  #-------------------------------------------------------------
  # Arithmetic tests
  #-------------------------------------------------------------

  # psrl.dhs rd, rs1, rs2
  # rd (register pair) = rs1 (register pair) >> rs2 (per halfword, logical)
  # rd and rs1 must be even registers

  # Test 2: Shift by 1
  # rs1 = 0x00020004 (halfwords: 2, 4)
  # shift = 1
  # Expected: 1, 2 = 0x00010002
  TEST_CASE( 2, x14, 0x00010002, \
    li x10, 0x00020004; \
    li x11, 0x00020004; \
    li x12, 1; \
    psrl.dhs x14, x10, x12 );
  TEST_CASE( 3, x15, 0x00010002, nop );

  # Test 4: Shift by 8
  # rs1 = 0x80008000 (all 0x8000)
  # shift = 8
  # Expected: 0x00800080
  TEST_CASE( 4, x14, 0x00800080, \
    li x10, 0x80008000; \
    li x11, 0x80008000; \
    li x12, 8; \
    psrl.dhs x14, x10, x12 );
  TEST_CASE( 5, x15, 0x00800080, nop );

  # Test 6: Shift by 15
  # rs1 = 0x80008000 (all 0x8000)
  # shift = 15
  # Expected: 0x00010001
  TEST_CASE( 6, x14, 0x00010001, \
    li x10, 0x80008000; \
    li x11, 0x80008000; \
    li x12, 15; \
    psrl.dhs x14, x10, x12 );
  TEST_CASE( 7, x15, 0x00010001, nop );

  # Test 8: Shift by 0 (no change)
  TEST_CASE( 8, x14, 0x12345678, \
    li x10, 0x12345678; \
    li x11, 0x12345678; \
    li x12, 0; \
    psrl.dhs x14, x10, x12 );
  TEST_CASE( 9, x15, 0x12345678, nop );

  # Test 10: All 0xFFFF shifted by 1
  # 0xFFFF >> 1 = 0x7FFF (halfword, no sign extension)
  TEST_CASE( 10, x14, 0x7FFF7FFF, \
    li x10, 0xFFFFFFFF; \
    li x11, 0xFFFFFFFF; \
    li x12, 1; \
    psrl.dhs x14, x10, x12 );
  TEST_CASE( 11, x15, 0x7FFF7FFF, nop );

  # Test 12: Zero input
  TEST_CASE( 12, x14, 0x00000000, \
    li x10, 0x00000000; \
    li x11, 0x00000000; \
    li x12, 5; \
    psrl.dhs x14, x10, x12 );
  TEST_CASE( 13, x15, 0x00000000, nop );

  # Test 14: Shift by 4
  TEST_CASE( 14, x14, 0x08000800, \
    li x10, 0x80008000; \
    li x11, 0x80008000; \
    li x12, 4; \
    psrl.dhs x14, x10, x12 );
  TEST_CASE( 15, x15, 0x08000800, nop );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END

