# See LICENSE for license details.

#*****************************************************************************
# subd.S
#-----------------------------------------------------------------------------
#
# Test subd instruction (64-bit subtract using register pairs, RV32 only).
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV32U
RVTEST_CODE_BEGIN

  #-------------------------------------------------------------
  # Arithmetic tests
  #-------------------------------------------------------------

  # subd rd, rs1, rs2
  # rd_pair = rs1_pair - rs2_pair (64-bit subtraction)

  # Test case 1: Simple 64-bit subtraction (no borrow)
  # 0x00000002_00000003 - 0x00000001_00000001 = 0x00000001_00000002
  TEST_CASE( 2, x14, 0x00000002, \
    li x10, 0x00000003; \
    li x11, 0x00000002; \
    li x12, 0x00000001; \
    li x13, 0x00000001; \
    subd x14, x10, x12 );
  TEST_CASE( 3, x15, 0x00000001, nop );

  # Test case 2: 64-bit subtraction with borrow
  # 0x00000001_00000000 - 0x00000000_00000001 = 0x00000000_FFFFFFFF
  TEST_CASE( 4, x14, 0xFFFFFFFF, \
    li x10, 0x00000000; \
    li x11, 0x00000001; \
    li x12, 0x00000001; \
    li x13, 0x00000000; \
    subd x14, x10, x12 );
  TEST_CASE( 5, x15, 0x00000000, nop );

  # Test case 3: Zero - Zero = Zero
  TEST_CASE( 6, x14, 0x00000000, \
    li x10, 0x00000000; \
    li x11, 0x00000000; \
    li x12, 0x00000000; \
    li x13, 0x00000000; \
    subd x14, x10, x12 );
  TEST_CASE( 7, x15, 0x00000000, nop );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END

