# See LICENSE for license details.

#*****************************************************************************
# pmqracc_w_h11.S
#-----------------------------------------------------------------------------
#
# Test pmqracc.w.h11 instruction (packed multiply Q-format rounding accumulate word h1*h1, RV64 only).
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV64U
RVTEST_CODE_BEGIN

  #-------------------------------------------------------------
  # Arithmetic tests
  #-------------------------------------------------------------

  # pmqracc.w.h11 (per P-ext spec):
  #   q_i = (sext_47(rs1.h1_w_i) * sext_47(rs2.h1_w_i) + 2^14)[46:15]
  #   d_i = X[rd].w_i + q_i

  # Test 1: rs1.h1=2, rs2.h1=3, p=6, q=0, d=rd_init.
  TEST_CASE( 2, x14, 0x0000001000000010, \
    li x14, 0x0000001000000010; \
    li a1, 0x0002000000020000; \
    li a2, 0x0003000000030000; \
    pmqracc.w.h11 x14, a1, a2 );

  # Test 2: p=20, q=0, d=rd_init.
  TEST_CASE( 3, x14, 0x0000010000000100, \
    li x14, 0x0000010000000100; \
    li a1, 0x0004000000040000; \
    li a2, 0x0005000000050000; \
    pmqracc.w.h11 x14, a1, a2 );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END
