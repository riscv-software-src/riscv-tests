# See LICENSE for license details.

#*****************************************************************************
# pmqacc_w_h01.S
#-----------------------------------------------------------------------------
#
# Test pmqacc.w.h01 instruction (packed multiply Q-format accumulate word h0*h1, RV64 only).
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV64U
RVTEST_CODE_BEGIN

  #-------------------------------------------------------------
  # Arithmetic tests
  #-------------------------------------------------------------

  # pmqacc.w.h01 (per P-ext spec):
  #   q_i = (sext_47(rs1.h0_w_i) * sext_47(rs2.h1_w_i))[46:15]
  #   d_i = X[rd].w_i + q_i

  # Test 1: rs1.h0=2, rs2.h1=3, p=6, q=0, d=rd_init.
  TEST_CASE( 2, x14, 0x0000001000000010, \
    li x14, 0x0000001000000010; \
    li a1, 0x0000000200000002; \
    li a2, 0x0003000000030000; \
    pmqacc.w.h01 x14, a1, a2 );

  # Test 2: rs1.h0=4, rs2.h1=5, p=20, q=0, d=rd_init.
  TEST_CASE( 3, x14, 0x0000010000000100, \
    li x14, 0x0000010000000100; \
    li a1, 0x0000000400000004; \
    li a2, 0x0005000000050000; \
    pmqacc.w.h01 x14, a1, a2 );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END
