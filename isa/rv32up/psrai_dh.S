# See LICENSE for license details.

#*****************************************************************************
# psrai_dh.S
#-----------------------------------------------------------------------------
#
# Test psrai.dh instruction (packed shift right arithmetic immediate, double-word, halfword).
# RV32-only instruction using register pairs for 64-bit operations.
# Shifts each signed halfword element right by an immediate value, with sign extension.
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV32U
RVTEST_CODE_BEGIN

  #-------------------------------------------------------------
  # Arithmetic tests
  #-------------------------------------------------------------

  # Test 2: Shift positive values by 1
  # rs1 = 0x00020004
  # shift = 1
  # Expected: 1, 2 = 0x00010002
  TEST_IMM_OP( 2, psrai.dh, 0x00010002, 0x00020004, 1 );

  # Test 3: Shift negative values by 1 (sign extension)
  # rs1 = 0xFFFEFFFC (signed halfwords: -2, -4)
  # shift = 1
  # Expected: -1, -2 = 0xFFFFFFFE
  TEST_IMM_OP( 3, psrai.dh, 0xFFFFFFFE, 0xFFFEFFFC, 1 );

  # Test 4: Shift by 8
  # rs1 = 0x80008000 (all -32768)
  # shift = 8
  # Expected: 0xFF80FF80 (-128 per halfword)
  TEST_IMM_OP( 4, psrai.dh, 0xFF80FF80, 0x80008000, 8 );

  # Test 5: Shift by 0 (no change)
  TEST_IMM_OP( 5, psrai.dh, 0x12345678, 0x12345678, 0 );

  # Test 6: Shift by 15 (sign fill)
  # rs1 = 0x80008000 (all -32768)
  # shift = 15
  # Expected: 0xFFFFFFFF (all -1)
  TEST_IMM_OP( 6, psrai.dh, 0xFFFFFFFF, 0x80008000, 15 );

  # Test 7: Shift positive by 15
  # rs1 = 0x7FFF7FFF (all 32767)
  # shift = 15
  # Expected: 0x00000000
  TEST_IMM_OP( 7, psrai.dh, 0x00000000, 0x7FFF7FFF, 15 );

  # Test 8: Zero input
  TEST_IMM_OP( 8, psrai.dh, 0x00000000, 0x00000000, 5 );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END

