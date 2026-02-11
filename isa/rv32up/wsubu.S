# See LICENSE for license details.

#*****************************************************************************
# wsubu.S
#-----------------------------------------------------------------------------
#
# Test wsubu instruction (unsigned widening subtract, RV32 only).
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV32U
RVTEST_CODE_BEGIN

  #-------------------------------------------------------------
  # Arithmetic tests
  #-------------------------------------------------------------

  # wsubu rd, rs1, rs2
  # Unsigned widening subtract: rd_pair = zero_ext(rs1) - zero_ext(rs2)
  # 32-bit to 64-bit unsigned widening

  # Test case 1: Simple widening subtract
  # 0x00000003 - 0x00000001 = 0x00000000_00000002
  TEST_CASE( 2, x14, 0x00000002, \
    li x10, 0x00000003; \
    li x12, 0x00000001; \
    wsubu x14, x10, x12 );
  TEST_CASE( 3, x15, 0x00000000, nop );

  # Test case 2: Unsigned subtract with high values
  # 0xFFFFFFFF - 0x00000001 = 0x00000000_FFFFFFFE
  TEST_CASE( 4, x14, 0xFFFFFFFE, \
    li x10, 0xFFFFFFFF; \
    li x12, 0x00000001; \
    wsubu x14, x10, x12 );
  TEST_CASE( 5, x15, 0x00000000, nop );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END

