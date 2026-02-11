# See LICENSE for license details.

#*****************************************************************************
# pwadda_h.S
#-----------------------------------------------------------------------------
#
# Test pwadda.h instruction (packed widening halfword add accumulate, RV32 only).
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV32U
RVTEST_CODE_BEGIN

  #-------------------------------------------------------------
  # Arithmetic tests
  #-------------------------------------------------------------

  # pwadda.h rd, rs1, rs2
  # Packed widening add accumulate: rd_pair[i] += sign_ext(rs1[i]) + sign_ext(rs2[i])

  # Test case 1: Accumulate with initial value
  # rd = 0x00000010, rs1[i] = 0x0001, rs2[i] = 0x0002
  # rd[i] = 0x00000010 + 0x0001 + 0x0002 = 0x00000013
  TEST_CASE( 2, x14, 0x00000013, \
    li x14, 0x00000010; \
    li x15, 0x00000010; \
    li x10, 0x00010001; \
    li x12, 0x00020002; \
    pwadda.h x14, x10, x12 );
  TEST_CASE( 3, x15, 0x00000013, nop );

  # Test case 2: Accumulate from zero
  TEST_CASE( 4, x14, 0x00000003, \
    li x14, 0x00000000; \
    li x15, 0x00000000; \
    li x10, 0x00010001; \
    li x12, 0x00020002; \
    pwadda.h x14, x10, x12 );
  TEST_CASE( 5, x15, 0x00000003, nop );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END

