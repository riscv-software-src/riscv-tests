# See LICENSE for license details.

#*****************************************************************************
# wadda.S
#-----------------------------------------------------------------------------
#
# Test wadda instruction (widening add accumulate, RV32 only).
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV32U
RVTEST_CODE_BEGIN

  #-------------------------------------------------------------
  # Arithmetic tests
  #-------------------------------------------------------------

  # wadda rd, rs1, rs2
  # Widening add accumulate: rd_pair += sign_ext(rs1) + sign_ext(rs2)

  # Test case 1: Accumulate with initial value
  # rd = 0x00000000_00000010, rs1 = 0x00000001, rs2 = 0x00000002
  # rd = 0x10 + 0x01 + 0x02 = 0x00000000_00000013
  TEST_CASE( 2, x14, 0x00000013, \
    li x14, 0x00000010; \
    li x15, 0x00000000; \
    li x10, 0x00000001; \
    li x12, 0x00000002; \
    wadda x14, x10, x12 );
  TEST_CASE( 3, x15, 0x00000000, nop );

  # Test case 2: Accumulate from zero
  TEST_CASE( 4, x14, 0x00000003, \
    li x14, 0x00000000; \
    li x15, 0x00000000; \
    li x10, 0x00000001; \
    li x12, 0x00000002; \
    wadda x14, x10, x12 );
  TEST_CASE( 5, x15, 0x00000000, nop );

  # Test case 3: Accumulate with carry to high word
  TEST_CASE( 6, x14, 0x00000000, \
    li x14, 0xFFFFFFFE; \
    li x15, 0x00000000; \
    li x10, 0x00000001; \
    li x12, 0x00000001; \
    wadda x14, x10, x12 );
  TEST_CASE( 7, x15, 0x00000001, nop );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END

