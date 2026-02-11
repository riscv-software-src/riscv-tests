# See LICENSE for license details.

#*****************************************************************************
# pli_dh.S
#-----------------------------------------------------------------------------
#
# Test pli.dh instruction (packed load immediate double-word halfword).
# RV32-only instruction that fills 4 halfwords with the same signed 10-bit immediate.
# Result is stored in register pair (x[rd+1]:x[rd]).
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV32U
RVTEST_CODE_BEGIN

  #-------------------------------------------------------------
  # Basic tests - pli.dh loads signed 10-bit immediate to all halfword elements
  # Result is 64-bit stored in register pair (rd uses rd_p encoding)
  # rd_p=7 means x14 (low) and x15 (high)
  #-------------------------------------------------------------

  # pli.dh with imm10 = 1: all halfwords = 0x0001
  # 64-bit result = 0x0001000100010001
  # x14 (low) = 0x00010001, x15 (high) = 0x00010001
  TEST_CASE( 2, x14, 0x00010001, li x14, 0; li x15, 0; pli.dh x14, 1 );
  TEST_CASE( 3, x15, 0x00010001, nop );

  # pli.dh with imm10 = 0: all halfwords = 0x0000
  # x14 = 0x00000000, x15 = 0x00000000
  TEST_CASE( 4, x14, 0x00000000, li x14, -1; li x15, -1; pli.dh x14, 0 );
  TEST_CASE( 5, x15, 0x00000000, nop );

  # pli.dh with imm10 = 511 (0x1FF): all halfwords = 0x01FF
  # x14 = 0x01FF01FF, x15 = 0x01FF01FF
  TEST_CASE( 6, x14, 0x01FF01FF, li x14, 0; li x15, 0; pli.dh x14, 511 );
  TEST_CASE( 7, x15, 0x01FF01FF, nop );

  # pli.dh with imm10 = -1 (sign-extended to 0xFFFF): all halfwords = 0xFFFF
  # x14 = 0xFFFFFFFF, x15 = 0xFFFFFFFF
  TEST_CASE( 8, x14, 0xFFFFFFFF, li x14, 0; li x15, 0; pli.dh x14, -1 );
  TEST_CASE( 9, x15, 0xFFFFFFFF, nop );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END

