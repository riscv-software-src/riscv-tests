# See LICENSE for license details.

#*****************************************************************************
# pli_db.S
#-----------------------------------------------------------------------------
#
# Test pli.db instruction (packed load immediate double-word byte).
# RV32-only instruction that fills 8 bytes with the same 8-bit immediate.
# Result is stored in register pair (x[rd+1]:x[rd]).
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV32U
RVTEST_CODE_BEGIN

  #-------------------------------------------------------------
  # Basic tests - pli.db loads 8-bit immediate to all byte elements
  # Result is 64-bit stored in register pair (rd uses rd_p encoding)
  # rd_p=7 means x14 (low) and x15 (high)
  #-------------------------------------------------------------

  # pli.db with imm8 = 1: all bytes = 0x01
  # 64-bit result = 0x0101010101010101
  # x14 (low) = 0x01010101, x15 (high) = 0x01010101
  TEST_CASE( 2, x14, 0x01010101, li x14, 0; li x15, 0; pli.db x14, 1 );
  TEST_CASE( 3, x15, 0x01010101, nop );

  # pli.db with imm8 = 0: all bytes = 0x00
  # x14 = 0x00000000, x15 = 0x00000000
  TEST_CASE( 4, x14, 0x00000000, li x14, -1; li x15, -1; pli.db x14, 0 );
  TEST_CASE( 5, x15, 0x00000000, nop );

  # pli.db with imm8 = 127 (0x7F): all bytes = 0x7F
  # x14 = 0x7F7F7F7F, x15 = 0x7F7F7F7F
  TEST_CASE( 6, x14, 0x7F7F7F7F, li x14, 0; li x15, 0; pli.db x14, 127 );
  TEST_CASE( 7, x15, 0x7F7F7F7F, nop );

  # pli.db with imm8 = -1 (0xFF): all bytes = 0xFF
  # x14 = 0xFFFFFFFF, x15 = 0xFFFFFFFF
  TEST_CASE( 8, x14, 0xFFFFFFFF, li x14, 0; li x15, 0; pli.db x14, -1 );
  TEST_CASE( 9, x15, 0xFFFFFFFF, nop );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END

