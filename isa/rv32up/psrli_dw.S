# See LICENSE for license details.

#*****************************************************************************
# psrli_dw.S
#-----------------------------------------------------------------------------
#
# Test psrli.dw instruction (packed shift right logical immediate, double-word, word).
# RV32-only instruction using register pairs for 64-bit operations.
# Shifts each unsigned word element right by an immediate value.
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV32U
RVTEST_CODE_BEGIN

  #-------------------------------------------------------------
  # Arithmetic tests
  #-------------------------------------------------------------

  # Test 2: Shift by 1
  # rs1 = 0x00000002 (word: 2)
  # shift = 1
  # Expected: 1 = 0x00000001
  TEST_IMM_OP( 2, psrli.dw, 0x00000001, 0x00000002, 1 );

  # Test 3: Shift by 16
  # rs1 = 0x80000000
  # shift = 16
  # Expected: 0x00008000
  TEST_IMM_OP( 3, psrli.dw, 0x00008000, 0x80000000, 16 );

  # Test 4: Shift by 31
  # rs1 = 0x80000000
  # shift = 31
  # Expected: 0x00000001
  TEST_IMM_OP( 4, psrli.dw, 0x00000001, 0x80000000, 31 );

  # Test 5: Shift by 0 (no change)
  TEST_IMM_OP( 5, psrli.dw, 0x12345678, 0x12345678, 0 );

  # Test 6: All 0xFFFFFFFF shifted by 1
  # 0xFFFFFFFF >> 1 = 0x7FFFFFFF (word, no sign extension)
  TEST_IMM_OP( 6, psrli.dw, 0x7FFFFFFF, 0xFFFFFFFF, 1 );

  # Test 7: Zero input
  TEST_IMM_OP( 7, psrli.dw, 0x00000000, 0x00000000, 5 );

  # Test 8: Shift by 4
  TEST_IMM_OP( 8, psrli.dw, 0x08000000, 0x80000000, 4 );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END

