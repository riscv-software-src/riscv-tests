# See LICENSE for license details.

#*****************************************************************************
# psrai_db.S
#-----------------------------------------------------------------------------
#
# Test psrai.db instruction (packed shift right arithmetic immediate, double-word, byte).
# RV32-only instruction using register pairs for 64-bit operations.
# Shifts each signed byte element right by an immediate value, with sign extension.
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV32U
RVTEST_CODE_BEGIN

  #-------------------------------------------------------------
  # Arithmetic tests
  #-------------------------------------------------------------

  # Test 2: Shift positive values by 1
  # rs1 = 0x02040608
  # shift = 1
  # Expected: 1, 2, 3, 4 = 0x01020304
  TEST_IMM_OP( 2, psrai.db, 0x01020304, 0x02040608, 1 );

  # Test 3: Shift negative values by 1 (sign extension)
  # rs1 = 0xFEFCFAF8 (signed bytes: -2, -4, -6, -8)
  # shift = 1
  # Expected: -1, -2, -3, -4 = 0xFFFEFDFC
  TEST_IMM_OP( 3, psrai.db, 0xFFFEFDFC, 0xFEFCFAF8, 1 );

  # Test 4: Shift by 4
  # rs1 = 0x80808080 (all -128)
  # shift = 4
  # Expected: 0xF8F8F8F8 (-8 per byte)
  TEST_IMM_OP( 4, psrai.db, 0xF8F8F8F8, 0x80808080, 4 );

  # Test 5: Shift by 0 (no change)
  TEST_IMM_OP( 5, psrai.db, 0x12345678, 0x12345678, 0 );

  # Test 6: Shift by 7 (sign fill)
  # rs1 = 0x80808080 (all -128)
  # shift = 7
  # Expected: 0xFFFFFFFF (all -1)
  TEST_IMM_OP( 6, psrai.db, 0xFFFFFFFF, 0x80808080, 7 );

  # Test 7: Shift positive by 7
  # rs1 = 0x7F7F7F7F (all 127)
  # shift = 7
  # Expected: 0x00000000
  TEST_IMM_OP( 7, psrai.db, 0x00000000, 0x7F7F7F7F, 7 );

  # Test 8: Zero input
  TEST_IMM_OP( 8, psrai.db, 0x00000000, 0x00000000, 5 );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END

