# See LICENSE for license details.

#*****************************************************************************
# pmqr2add_w.S
#-----------------------------------------------------------------------------
#
# Test pmqr2add.w instruction (packed multiply Q31 rounding 2-way add word, RV64 only).
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV64U
RVTEST_CODE_BEGIN

  #-------------------------------------------------------------
  # Arithmetic tests
  #-------------------------------------------------------------

  # pmqr2add.w: packed multiply Q31 rounding 2-way add for 32-bit words
  # rd = sum(((rs1[i] * rs2[i]) + 0x40000000) >> 31) for each 64-bit segment
  # Adds rounding constant before shift

  # Test: (((0x40000000 * 0x40000000) + 0x40000000) >> 31) + (((0x40000000 * 0x40000000) + 0x40000000) >> 31)
  #     = 0x20000000 + 0x20000000 = 0x40000000 (rounding doesn't change result for large values)
  TEST_RR_OP( 2, pmqr2add.w, 0x0000000040000000, 0x4000000040000000, 0x4000000040000000 );

  # Test: (((0x10000000 * 0x10000000) + 0x40000000) >> 31) + (((0x10000000 * 0x10000000) + 0x40000000) >> 31)
  #     = 0x02000000 + 0x02000000 = 0x04000000
  TEST_RR_OP( 3, pmqr2add.w, 0x0000000004000000, 0x1000000010000000, 0x1000000010000000 );

  # Test: (((0x20000000 * 0x20000000) + 0x40000000) >> 31) + (((0x20000000 * 0x20000000) + 0x40000000) >> 31)
  #     = 0x08000000 + 0x08000000 = 0x10000000
  TEST_RR_OP( 4, pmqr2add.w, 0x0000000010000000, 0x2000000020000000, 0x2000000020000000 );

  # Test with zeros - rounding constant effect
  # (((0 * 0) + 0x40000000) >> 31) + (((0 * 0) + 0x40000000) >> 31) = 0 + 0 = 0
  TEST_RR_OP( 5, pmqr2add.w, 0x0000000000000000, 0x0000000000000000, 0x0000000000000000 );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END

