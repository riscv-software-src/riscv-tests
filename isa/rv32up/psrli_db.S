# See LICENSE for license details.

#*****************************************************************************
# psrli_db.S
#-----------------------------------------------------------------------------
#
# Test psrli.db instruction (packed shift right logical immediate, double-word, byte).
# RV32-only instruction using register pairs for 64-bit operations.
# Shifts each unsigned byte element right by an immediate value.
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV32U
RVTEST_CODE_BEGIN

  #-------------------------------------------------------------
  # Arithmetic tests
  #-------------------------------------------------------------

  # Test 2: Shift by 1
  # rs1 = 0x02040608 (bytes: 2, 4, 6, 8)
  # shift = 1
  # Expected: 1, 2, 3, 4 = 0x01020304
  TEST_IMM_OP( 2, psrli.db, 0x01020304, 0x02040608, 1 );

  # Test 3: Shift by 4
  # rs1 = 0x80808080 (all 0x80)
  # shift = 4
  # Expected: 0x08080808
  TEST_IMM_OP( 3, psrli.db, 0x08080808, 0x80808080, 4 );

  # Test 4: Shift by 7
  # rs1 = 0x80808080 (all 0x80)
  # shift = 7
  # Expected: 0x01010101
  TEST_IMM_OP( 4, psrli.db, 0x01010101, 0x80808080, 7 );

  # Test 5: Shift by 0 (no change)
  TEST_IMM_OP( 5, psrli.db, 0x12345678, 0x12345678, 0 );

  # Test 6: All 0xFF shifted by 1
  # 0xFF >> 1 = 0x7F (byte, no sign extension)
  TEST_IMM_OP( 6, psrli.db, 0x7F7F7F7F, 0xFFFFFFFF, 1 );

  # Test 7: Zero input
  TEST_IMM_OP( 7, psrli.db, 0x00000000, 0x00000000, 5 );

  # Test 8: Shift by 3
  TEST_IMM_OP( 8, psrli.db, 0x10101010, 0x80808080, 3 );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END

