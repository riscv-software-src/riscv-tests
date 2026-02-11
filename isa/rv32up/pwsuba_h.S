# See LICENSE for license details.

#*****************************************************************************
# pwsuba_h.S
#-----------------------------------------------------------------------------
#
# Test pwsuba.h instruction (packed widening halfword subtract accumulate, RV32 only).
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV32U
RVTEST_CODE_BEGIN

  #-------------------------------------------------------------
  # Arithmetic tests
  #-------------------------------------------------------------

  # pwsuba.h rd, rs1, rs2
  # Packed widening subtract accumulate: rd_pair[i] += sign_ext(rs1[i]) - sign_ext(rs2[i])

  # Test case 1: Accumulate with initial value
  # rd = 0x00000010, rs1[i] = 0x0003, rs2[i] = 0x0001
  # rd[i] = 0x00000010 + (0x0003 - 0x0001) = 0x00000012
  TEST_CASE( 2, x14, 0x00000012, \
    li x14, 0x00000010; \
    li x15, 0x00000010; \
    li x10, 0x00030003; \
    li x12, 0x00010001; \
    pwsuba.h x14, x10, x12 );
  TEST_CASE( 3, x15, 0x00000012, nop );

  # Test case 2: Accumulate from zero
  TEST_CASE( 4, x14, 0x00000002, \
    li x14, 0x00000000; \
    li x15, 0x00000000; \
    li x10, 0x00030003; \
    li x12, 0x00010001; \
    pwsuba.h x14, x10, x12 );
  TEST_CASE( 5, x15, 0x00000002, nop );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END

