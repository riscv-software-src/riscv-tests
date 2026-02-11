# See LICENSE for license details.

#*****************************************************************************
# plui_dh.S
#-----------------------------------------------------------------------------
#
# Test plui.dh instruction (packed load unsigned immediate double-word halfword).
# RV32-only instruction that fills 4 halfwords with the same unsigned 10-bit
# immediate shifted left by 6 bits.
# Result is stored in register pair (x[rd+1]:x[rd]).
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV32U
RVTEST_CODE_BEGIN

  #-------------------------------------------------------------
  # Basic tests - plui.dh loads unsigned 10-bit immediate << 6 to all halfword elements
  # Result is 64-bit stored in register pair (rd uses rd_p encoding)
  # rd_p=7 means x14 (low) and x15 (high)
  #-------------------------------------------------------------

  # plui.dh with imm10 = 1: all halfwords = 1 << 6 = 0x0040
  # 64-bit result = 0x0040004000400040
  # x14 (low) = 0x00400040, x15 (high) = 0x00400040
  TEST_CASE( 2, x14, 0x00400040, li x14, 0; li x15, 0; plui.dh x14, 1 );
  TEST_CASE( 3, x15, 0x00400040, nop );

  # plui.dh with imm10 = 0: all halfwords = 0x0000
  # x14 = 0x00000000, x15 = 0x00000000
  TEST_CASE( 4, x14, 0x00000000, li x14, -1; li x15, -1; plui.dh x14, 0 );
  TEST_CASE( 5, x15, 0x00000000, nop );

  # plui.dh with imm10 = 511 (0x1FF): all halfwords = 0x1FF << 6 = 0x7FC0
  # x14 = 0x7FC07FC0, x15 = 0x7FC07FC0
  TEST_CASE( 6, x14, 0x7FC07FC0, li x14, 0; li x15, 0; plui.dh x14, 511 );
  TEST_CASE( 7, x15, 0x7FC07FC0, nop );

  # plui.dh with imm10 = -512 (0x200): all halfwords = 0x200 << 6 = 0x8000
  # x14 = 0x80008000, x15 = 0x80008000
  TEST_CASE( 8, x14, 0x80008000, li x14, 0; li x15, 0; plui.dh x14, -512 );
  TEST_CASE( 9, x15, 0x80008000, nop );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END

