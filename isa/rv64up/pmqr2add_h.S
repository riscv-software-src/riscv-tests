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

  # pmqr2add.h: rounded Q-format 2-way add for halfwords (NON-accumulating)
  # q_i = (sext_47(rs1.h_i) * sext_47(rs2.h_i) + 2^14)[46:15]
  # rd  = q0 + q1 per 32-bit lane

  # Test: q = (0x4000*0x4000 + 0x4000)>>15 = 0x10004000>>15 = 0x2000, sum = 0x4000
  TEST_CASE( 2, x14, 0x0000400000004000, \
    li x14, 0x0000001000000010; \
    li a1, 0x4000400040004000; \
    li a2, 0x4000400040004000; \
    pmqr2add.h x14, a1, a2 );

  # Test: q = (0x1000*0x1000 + 0x4000)>>15 = 0x01004000>>15 = 0x200, sum = 0x400
  TEST_CASE( 3, x14, 0x0000040000000400, \
    li x14, 0x0000000000000000; \
    li a1, 0x1000100010001000; \
    li a2, 0x1000100010001000; \
    pmqr2add.h x14, a1, a2 );

  # Test: q = (0x2000*0x2000 + 0x4000)>>15 = 0x04004000>>15 = 0x800, sum = 0x1000
  TEST_CASE( 4, x14, 0x0000100000001000, \
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
