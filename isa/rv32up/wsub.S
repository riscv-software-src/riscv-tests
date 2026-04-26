# See LICENSE for license details.

#*****************************************************************************
# wsub.S
#-----------------------------------------------------------------------------
#
# Test wsub instruction (widening subtract, RV32 only).
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV32U
RVTEST_CODE_BEGIN

  #-------------------------------------------------------------
  # Arithmetic tests
  #-------------------------------------------------------------

  # wsub rd, rs1, rs2
  # Widening subtract: rd_pair = sign_ext(rs1) - sign_ext(rs2)
  # 32-bit to 64-bit signed widening

  # Test case 1: Simple widening subtract
  # 0x00000003 - 0x00000001 = 0x00000000_00000002
  TEST_CASE( 2, x14, 0x00000002, \
    li x10, 0x00000003; \
    li x12, 0x00000001; \
    wsub x14, x10, x12 );
  TEST_CASE( 3, x15, 0x00000000, nop );

  # Test case 2: Zero - Zero
  TEST_CASE( 4, x14, 0x00000000, \
    li x10, 0x00000000; \
    li x12, 0x00000000; \
    wsub x14, x10, x12 );
  TEST_CASE( 5, x15, 0x00000000, nop );

  # Test case 3: Signed negative result
  # 0x00000001 - 0x00000002 = 0xFFFFFFFF_FFFFFFFF (-1)
  TEST_CASE( 6, x14, 0xFFFFFFFF, \
    li x10, 0x00000001; \
    li x12, 0x00000002; \
    wsub x14, x10, x12 );
  TEST_CASE( 7, x15, 0xFFFFFFFF, nop );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END

