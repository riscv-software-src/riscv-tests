# See LICENSE for license details.

#*****************************************************************************
# predsumu_hs.S (RV32)
#-----------------------------------------------------------------------------
#
# Test predsumu.hs on RV32. Reduces XLEN/16 = 2 unsigned halfword lanes of rs1.
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV32U
RVTEST_CODE_BEGIN

  # Test 1: rs1 = 0x00030004 -> 3+4 = 7
  TEST_RR_OP( 2, predsumu.hs, 0x00000007, 0x00030004, 0x00000000 );

  # Test 2: zero
  TEST_RR_OP( 3, predsumu.hs, 0x00000000, 0x00000000, 0x00000000 );

  # Test 3: with base value rs2 = 0x10
  TEST_RR_OP( 4, predsumu.hs, 0x00000017, 0x00030004, 0x00000010 );

  # Test 4: 2 * 0xFFFF = 0x1FFFE
  TEST_RR_OP( 5, predsumu.hs, 0x0001fffe, 0xffffffff, 0x00000000 );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END
