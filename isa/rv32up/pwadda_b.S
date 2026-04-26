# See LICENSE for license details.

#*****************************************************************************
# pwadda_b.S
#-----------------------------------------------------------------------------
#
# Test pwadda.b instruction (packed widening byte add accumulate, RV32 only).
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV32U
RVTEST_CODE_BEGIN

  #-------------------------------------------------------------
  # Arithmetic tests
  #-------------------------------------------------------------

  # pwadda.b rd, rs1, rs2
  # Packed widening add accumulate: rd_pair[i] += sign_ext(rs1[i]) + sign_ext(rs2[i])

  # Test case 1: Accumulate with initial value
  # rd = 0x00100010, rs1[i] = 0x01, rs2[i] = 0x02
  # rd[i] = 0x0010 + 0x01 + 0x02 = 0x0013
  TEST_CASE( 2, x14, 0x00130013, \
    li x14, 0x00100010; \
    li x15, 0x00100010; \
    li x10, 0x01010101; \
    li x12, 0x02020202; \
    pwadda.b x14, x10, x12 );
  TEST_CASE( 3, x15, 0x00130013, nop );

  # Test case 2: Accumulate from zero
  TEST_CASE( 4, x14, 0x00030003, \
    li x14, 0x00000000; \
    li x15, 0x00000000; \
    li x10, 0x01010101; \
    li x12, 0x02020202; \
    pwadda.b x14, x10, x12 );
  TEST_CASE( 5, x15, 0x00030003, nop );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END

