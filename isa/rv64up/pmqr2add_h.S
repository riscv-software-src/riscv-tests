# See LICENSE for license details.

#*****************************************************************************
# pmqr2add_h.S
#-----------------------------------------------------------------------------
#
# Test pmqr2add.h instruction.
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV64U
RVTEST_CODE_BEGIN

  #-------------------------------------------------------------
  # Arithmetic tests
  #-------------------------------------------------------------

  # pmqr2add.h: packed multiply Q15 rounding 2-way add for halfwords
  # rd = rd + sum(((rs1[i] * rs2[i]) + 0x4000) >> 15) for each 32-bit segment
  # Test: 0x00000010 + (((0x4000 * 0x4000) + 0x4000) >> 15) + (((0x4000 * 0x4000) + 0x4000) >> 15) = 0x10 + 0x2000 + 0x2000 = 0x00004010
  TEST_CASE( 2, x14, 0x0000401000004010, \
    li x14, 0x0000001000000010; \
    li a1, 0x4000400040004000; \
    li a2, 0x4000400040004000; \
    pmqr2add.h x14, a1, a2 );

  # Test: 0x00000000 + (((0x1000 * 0x1000) + 0x4000) >> 15) + (((0x1000 * 0x1000) + 0x4000) >> 15) = 0x00 + 0x200 + 0x200 = 0x00000400
  TEST_CASE( 3, x14, 0x0000040000000400, \
    li x14, 0x0000000000000000; \
    li a1, 0x1000100010001000; \
    li a2, 0x1000100010001000; \
    pmqr2add.h x14, a1, a2 );

  # Test: 0x00000005 + (((0x2000 * 0x2000) + 0x4000) >> 15) + (((0x2000 * 0x2000) + 0x4000) >> 15) = 0x05 + 0x800 + 0x800 = 0x00001005
  TEST_CASE( 4, x14, 0x0000100500001005, \
    li x14, 0x0000000500000005; \
    li a1, 0x2000200020002000; \
    li a2, 0x2000200020002000; \
    pmqr2add.h x14, a1, a2 );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END

