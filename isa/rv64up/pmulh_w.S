# See LICENSE for license details.

#*****************************************************************************
# pmulh_w.S
#-----------------------------------------------------------------------------
#
# Test pmulh.w instruction (packed multiply high word signed, RV64 only).
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV64U
RVTEST_CODE_BEGIN

  # pmulh.w rd, rs1, rs2 = (sext(rs1) * sext(rs2)) >> 32 for each 32-bit word

  # Test case 1: Large values to get non-zero high part
  # 0x40000000 * 0x40000000 = 0x1000000000000000, >> 32 = 0x10000000
  TEST_RR_OP( 2, pmulh.w, 0x1000000010000000, 0x4000000040000000, 0x4000000040000000 );

  # Test case 2: Small values (high part is 0)
  TEST_RR_OP( 3, pmulh.w, 0x0000000000000000, 0x0000000200000002, 0x0000000300000003 );

  # Test case 3: Negative * positive
  # 0xffffffff * 0x00000002 = -2, >> 32 = 0xffffffff
  TEST_RR_OP( 4, pmulh.w, 0xffffffffffffffff, 0xffffffffffffffff, 0x0000000200000002 );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN
  TEST_DATA
RVTEST_DATA_END

