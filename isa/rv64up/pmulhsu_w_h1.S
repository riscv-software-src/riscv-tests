# See LICENSE for license details.

#*****************************************************************************
# pmulhsu_w_h1.S
#-----------------------------------------------------------------------------
#
# Test pmulhsu.w.h1 instruction (packed multiply high word signed*unsigned, high halfword, RV64 only).
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV64U
RVTEST_CODE_BEGIN

  # pmulhsu.w.h1 (per P-ext spec):
  #   d_w_i = (sext_48(rs1.w_i) * zext_48(rs2.w_i[31:16]))[47:16]

  # Test case 1: rs1.w=0x40000000, rs2.h1=0x4000, p=2^44, [47:16]=0x10000000.
  TEST_RR_OP( 2, pmulhsu.w.h1, 0x1000000010000000, 0x4000000040000000, 0x4000000040000000 );

  # Test case 2: rs1.w=0x00020000, rs2.h1=0x0003, p=0x60000, [47:16]=0x6.
  TEST_RR_OP( 3, pmulhsu.w.h1, 0x0000000600000006, 0x0002000000020000, 0x0003000000030000 );

  # Test case 3: rs1.w=0x20000000, rs2.h1=0x2000, p=2^42, [47:16]=0x04000000.
  TEST_RR_OP( 4, pmulhsu.w.h1, 0x0400000004000000, 0x2000000020000000, 0x2000000020000000 );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN
  TEST_DATA
RVTEST_DATA_END
