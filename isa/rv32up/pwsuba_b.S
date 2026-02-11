# See LICENSE for license details.

#*****************************************************************************
# pwsuba_b.S
#-----------------------------------------------------------------------------
#
# Test pwsuba.b instruction (packed widening byte subtract accumulate, RV32 only).
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV32U
RVTEST_CODE_BEGIN

  #-------------------------------------------------------------
  # Arithmetic tests
  #-------------------------------------------------------------

  # pwsuba.b rd, rs1, rs2
  # Packed widening subtract accumulate: rd_pair[i] += sign_ext(rs1[i]) - sign_ext(rs2[i])

  # Test case 1: Accumulate with initial value
  # rd = 0x00100010, rs1[i] = 0x03, rs2[i] = 0x01
  # rd[i] = 0x0010 + (0x03 - 0x01) = 0x0012
  TEST_CASE( 2, x14, 0x00120012, \
    li x14, 0x00100010; \
    li x15, 0x00100010; \
    li x10, 0x03030303; \
    li x12, 0x01010101; \
    pwsuba.b x14, x10, x12 );
  TEST_CASE( 3, x15, 0x00120012, nop );

  # Test case 2: Accumulate from zero
  TEST_CASE( 4, x14, 0x00020002, \
    li x14, 0x00000000; \
    li x15, 0x00000000; \
    li x10, 0x03030303; \
    li x12, 0x01010101; \
    pwsuba.b x14, x10, x12 );
  TEST_CASE( 5, x15, 0x00020002, nop );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END

