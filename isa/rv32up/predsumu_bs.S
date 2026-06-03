# See LICENSE for license details.

#*****************************************************************************
# predsumu_bs.S (RV32)
#-----------------------------------------------------------------------------
#
# Test predsumu.bs on RV32. Reduces XLEN/8 = 4 unsigned byte lanes of rs1.
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV32U
RVTEST_CODE_BEGIN

  # Test 1: rs1 = 0x05060708 -> 5+6+7+8 = 26 = 0x1A
  TEST_RR_OP( 2, predsumu.bs, 0x0000001a, 0x05060708, 0x00000000 );

  # Test 2: zero
  TEST_RR_OP( 3, predsumu.bs, 0x00000000, 0x00000000, 0x00000000 );

  # Test 3: with base value rs2 = 0x10
  TEST_RR_OP( 4, predsumu.bs, 0x0000002a, 0x05060708, 0x00000010 );

  # Test 4: all 0xFF unsigned bytes, 4 lanes -> 4*255 = 1020 = 0x3FC
  TEST_RR_OP( 5, predsumu.bs, 0x000003fc, 0xffffffff, 0x00000000 );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END
