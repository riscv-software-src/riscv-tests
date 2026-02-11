# See LICENSE for license details.

#*****************************************************************************
# wadd.S
#-----------------------------------------------------------------------------
#
# Test wadd instruction (widening add, RV32 only).
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV32U
RVTEST_CODE_BEGIN

  #-------------------------------------------------------------
  # Arithmetic tests
  #-------------------------------------------------------------

  # wadd rd, rs1, rs2
  # Widening add: rd_pair = sign_ext(rs1) + sign_ext(rs2)
  # 32-bit to 64-bit signed widening

  # Test case 1: Simple widening add
  # 0x00000001 + 0x00000002 = 0x00000000_00000003
  TEST_CASE( 2, x14, 0x00000003, \
    li x10, 0x00000001; \
    li x12, 0x00000002; \
    wadd x14, x10, x12 );
  TEST_CASE( 3, x15, 0x00000000, nop );

  # Test case 2: Zero + Zero
  TEST_CASE( 4, x14, 0x00000000, \
    li x10, 0x00000000; \
    li x12, 0x00000000; \
    wadd x14, x10, x12 );
  TEST_CASE( 5, x15, 0x00000000, nop );

  # Test case 3: Signed negative values
  # 0xFFFFFFFF (-1) + 0x00000001 = 0x00000000_00000000
  TEST_CASE( 6, x14, 0x00000000, \
    li x10, 0xFFFFFFFF; \
    li x12, 0x00000001; \
    wadd x14, x10, x12 );
  TEST_CASE( 7, x15, 0x00000000, nop );

  # Test case 4: Large positive result (crosses 32-bit boundary)
  # 0x7FFFFFFF + 0x7FFFFFFF = 0x00000000_FFFFFFFE
  TEST_CASE( 8, x14, 0xFFFFFFFE, \
    li x10, 0x7FFFFFFF; \
    li x12, 0x7FFFFFFF; \
    wadd x14, x10, x12 );
  TEST_CASE( 9, x15, 0x00000000, nop );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END

