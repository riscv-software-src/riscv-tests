# See LICENSE for license details.

#*****************************************************************************
# waddu.S
#-----------------------------------------------------------------------------
#
# Test waddu instruction (unsigned widening add, RV32 only).
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV32U
RVTEST_CODE_BEGIN

  #-------------------------------------------------------------
  # Arithmetic tests
  #-------------------------------------------------------------

  # waddu rd, rs1, rs2
  # Unsigned widening add: rd_pair = zero_ext(rs1) + zero_ext(rs2)
  # 32-bit to 64-bit unsigned widening

  # Test case 1: Simple widening add
  # 0x00000001 + 0x00000002 = 0x00000000_00000003
  TEST_CASE( 2, x14, 0x00000003, \
    li x10, 0x00000001; \
    li x12, 0x00000002; \
    waddu x14, x10, x12 );
  TEST_CASE( 3, x15, 0x00000000, nop );

  # Test case 2: Unsigned add with high values
  # 0xFFFFFFFF + 0x00000001 = 0x00000001_00000000
  TEST_CASE( 4, x14, 0x00000000, \
    li x10, 0xFFFFFFFF; \
    li x12, 0x00000001; \
    waddu x14, x10, x12 );
  TEST_CASE( 5, x15, 0x00000001, nop );

  # Test case 3: Max unsigned values
  # 0xFFFFFFFF + 0xFFFFFFFF = 0x00000001_FFFFFFFE
  TEST_CASE( 6, x14, 0xFFFFFFFE, \
    li x10, 0xFFFFFFFF; \
    li x12, 0xFFFFFFFF; \
    waddu x14, x10, x12 );
  TEST_CASE( 7, x15, 0x00000001, nop );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END

