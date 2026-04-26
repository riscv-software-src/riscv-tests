# See LICENSE for license details.

#*****************************************************************************
# wsuba.S
#-----------------------------------------------------------------------------
#
# Test wsuba instruction (widening subtract accumulate, RV32 only).
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV32U
RVTEST_CODE_BEGIN

  #-------------------------------------------------------------
  # Arithmetic tests
  #-------------------------------------------------------------

  # wsuba rd, rs1, rs2
  # Widening subtract accumulate: rd_pair += sign_ext(rs1) - sign_ext(rs2)

  # Test case 1: Accumulate with initial value
  # rd = 0x00000000_00000010, rs1 = 0x00000003, rs2 = 0x00000001
  # rd = 0x10 + (0x03 - 0x01) = 0x00000000_00000012
  TEST_CASE( 2, x14, 0x00000012, \
    li x14, 0x00000010; \
    li x15, 0x00000000; \
    li x10, 0x00000003; \
    li x12, 0x00000001; \
    wsuba x14, x10, x12 );
  TEST_CASE( 3, x15, 0x00000000, nop );

  # Test case 2: Accumulate from zero
  TEST_CASE( 4, x14, 0x00000002, \
    li x14, 0x00000000; \
    li x15, 0x00000000; \
    li x10, 0x00000003; \
    li x12, 0x00000001; \
    wsuba x14, x10, x12 );
  TEST_CASE( 5, x15, 0x00000000, nop );

  # Test case 3: Accumulate with negative difference
  # 0x10 + (0x01 - 0x02) = 0x10 + (-1) = 0x0F
  TEST_CASE( 6, x14, 0x0000000F, \
    li x14, 0x00000010; \
    li x15, 0x00000000; \
    li x10, 0x00000001; \
    li x12, 0x00000002; \
    wsuba x14, x10, x12 );
  TEST_CASE( 7, x15, 0x00000000, nop );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END

