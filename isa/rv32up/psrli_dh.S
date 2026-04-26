# See LICENSE for license details.

#*****************************************************************************
# psrli_dh.S
#-----------------------------------------------------------------------------
#
# Test psrli.dh instruction (packed shift right logical immediate, double-word, halfword).
# RV32-only instruction using register pairs for 64-bit operations.
# Shifts each unsigned halfword element right by an immediate value.
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV32U
RVTEST_CODE_BEGIN

  #-------------------------------------------------------------
  # Arithmetic tests
  #-------------------------------------------------------------

  # Test 2: Shift by 1
  # rs1 = 0x00020004 (halfwords: 2, 4)
  # shift = 1
  # Expected: 1, 2 = 0x00010002
  TEST_IMM_OP( 2, psrli.dh, 0x00010002, 0x00020004, 1 );

  # Test 3: Shift by 8
  # rs1 = 0x80008000 (all 0x8000)
  # shift = 8
  # Expected: 0x00800080
  TEST_IMM_OP( 3, psrli.dh, 0x00800080, 0x80008000, 8 );

  # Test 4: Shift by 15
  # rs1 = 0x80008000 (all 0x8000)
  # shift = 15
  # Expected: 0x00010001
  TEST_IMM_OP( 4, psrli.dh, 0x00010001, 0x80008000, 15 );

  # Test 5: Shift by 0 (no change)
  TEST_IMM_OP( 5, psrli.dh, 0x12345678, 0x12345678, 0 );

  # Test 6: All 0xFFFF shifted by 1
  # 0xFFFF >> 1 = 0x7FFF (halfword, no sign extension)
  TEST_IMM_OP( 6, psrli.dh, 0x7FFF7FFF, 0xFFFFFFFF, 1 );

  # Test 7: Zero input
  TEST_IMM_OP( 7, psrli.dh, 0x00000000, 0x00000000, 5 );

  # Test 8: Shift by 4
  TEST_IMM_OP( 8, psrli.dh, 0x08000800, 0x80008000, 4 );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END

