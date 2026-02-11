# See LICENSE for license details.

#*****************************************************************************
# predsum_bs.S (RV32)
#-----------------------------------------------------------------------------
#
# Test predsum.bs on RV32. Reduces XLEN/8 = 4 signed byte lanes of rs1 and
# accumulates into rs2.
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV32U
RVTEST_CODE_BEGIN

  # Test 1: rs1 = 0x05060708 (bytes 5,6,7,8) -> sum = 26 = 0x1A
  TEST_RR_OP( 2, predsum.bs, 0x0000001a, 0x05060708, 0x00000000 );

  # Test 2: zero
  TEST_RR_OP( 3, predsum.bs, 0x00000000, 0x00000000, 0x00000000 );

  # Test 3: with base value rs2 = 0x10
  TEST_RR_OP( 4, predsum.bs, 0x0000002a, 0x05060708, 0x00000010 );

  # Test 4: all -1 signed bytes, 4 lanes -> sum = -4 = 0xFFFFFFFC
  TEST_RR_OP( 5, predsum.bs, 0xfffffffc, 0xffffffff, 0x00000000 );

  # Test 5: 4 ones plus rs2 = -1 -> 4 + (-1) = 3
  TEST_RR_OP( 6, predsum.bs, 0x00000003, 0x01010101, 0xffffffff );

  # Test 6: alternating +1 / -1 over 4 bytes -> 0
  TEST_RR_OP( 7, predsum.bs, 0x00000000, 0xff01ff01, 0x00000000 );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END
