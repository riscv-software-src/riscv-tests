# See LICENSE for license details.

#*****************************************************************************
# psrai_dw.S
#-----------------------------------------------------------------------------
#
# Test psrai.dw instruction (packed shift right arithmetic immediate, double-word, word).
# RV32-only instruction using register pairs for 64-bit operations.
# Shifts each signed word element right by an immediate value, with sign extension.
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV32U
RVTEST_CODE_BEGIN

  #-------------------------------------------------------------
  # Arithmetic tests
  #-------------------------------------------------------------

  # Test 2: Shift positive values by 1
  # rs1 = 0x00000002
  # shift = 1
  # Expected: 1 = 0x00000001
  TEST_IMM_OP( 2, psrai.dw, 0x00000001, 0x00000002, 1 );

  # Test 3: Shift negative values by 1 (sign extension)
  # rs1 = 0xFFFFFFFE (signed word: -2)
  # shift = 1
  # Expected: -1 = 0xFFFFFFFF
  TEST_IMM_OP( 3, psrai.dw, 0xFFFFFFFF, 0xFFFFFFFE, 1 );

  # Test 4: Shift by 16
  # rs1 = 0x80000000 (-2147483648)
  # shift = 16
  # Expected: 0xFFFF8000
  TEST_IMM_OP( 4, psrai.dw, 0xFFFF8000, 0x80000000, 16 );

  # Test 5: Shift by 0 (no change)
  TEST_IMM_OP( 5, psrai.dw, 0x12345678, 0x12345678, 0 );

  # Test 6: Shift by 31 (sign fill)
  # rs1 = 0x80000000 (-2147483648)
  # shift = 31
  # Expected: 0xFFFFFFFF (all -1)
  TEST_IMM_OP( 6, psrai.dw, 0xFFFFFFFF, 0x80000000, 31 );

  # Test 7: Shift positive by 31
  # rs1 = 0x7FFFFFFF (2147483647)
  # shift = 31
  # Expected: 0x00000000
  TEST_IMM_OP( 7, psrai.dw, 0x00000000, 0x7FFFFFFF, 31 );

  # Test 8: Zero input
  TEST_IMM_OP( 8, psrai.dw, 0x00000000, 0x00000000, 5 );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END

