# See LICENSE for license details.

#*****************************************************************************
# pmacc_w_h11.S
#-----------------------------------------------------------------------------
#
# Test pmacc.w.h11 instruction (packed multiply-accumulate word, h1*h1, RV64 only).
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV64U
RVTEST_CODE_BEGIN

  #-------------------------------------------------------------
  # Arithmetic tests
  #-------------------------------------------------------------

  # pmacc.w.h11: packed multiply-accumulate for words using high halfwords
  # rd[i] += sext(rs1[i].h1) * sext(rs2[i].h1) for each 32-bit word

  # Test: 0x10 + (2 * 3) = 16 + 6 = 22 = 0x16 (rs1.h1=2, rs2.h1=3)
  TEST_CASE( 2, x14, 0x0000001600000016, \
    li x14, 0x0000001000000010; \
    li a1, 0x0002000000020000; \
    li a2, 0x0003000000030000; \
    pmacc.w.h11 x14, a1, a2 );

  # Test: 0x100 + (4 * 5) = 256 + 20 = 276 = 0x114
  TEST_CASE( 3, x14, 0x0000011400000114, \
    li x14, 0x0000010000000100; \
    li a1, 0x0004000000040000; \
    li a2, 0x0005000000050000; \
    pmacc.w.h11 x14, a1, a2 );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END

