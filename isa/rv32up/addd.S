# See LICENSE for license details.

#*****************************************************************************
# addd.S
#-----------------------------------------------------------------------------
#
# Test addd instruction (64-bit add using register pairs, RV32 only).
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV32U
RVTEST_CODE_BEGIN

  #-------------------------------------------------------------
  # Arithmetic tests
  #-------------------------------------------------------------

  # addd rd, rs1, rs2
  # rd_pair = rs1_pair + rs2_pair (64-bit addition)
  # Uses even register as low word, odd register as high word

  # Test case 1: Simple 64-bit addition (no carry)
  # 0x00000001_00000002 + 0x00000001_00000001 = 0x00000002_00000003
  TEST_CASE( 2, x14, 0x00000003, \
    li x10, 0x00000002; \
    li x11, 0x00000001; \
    li x12, 0x00000001; \
    li x13, 0x00000001; \
    addd x14, x10, x12 );
  TEST_CASE( 3, x15, 0x00000002, nop );

  # Test case 2: 64-bit addition with carry from low to high
  # 0x00000000_FFFFFFFF + 0x00000000_00000001 = 0x00000001_00000000
  TEST_CASE( 4, x14, 0x00000000, \
    li x10, 0xFFFFFFFF; \
    li x11, 0x00000000; \
    li x12, 0x00000001; \
    li x13, 0x00000000; \
    addd x14, x10, x12 );
  TEST_CASE( 5, x15, 0x00000001, nop );

  # Test case 3: Zero + Zero = Zero
  TEST_CASE( 6, x14, 0x00000000, \
    li x10, 0x00000000; \
    li x11, 0x00000000; \
    li x12, 0x00000000; \
    li x13, 0x00000000; \
    addd x14, x10, x12 );
  TEST_CASE( 7, x15, 0x00000000, nop );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END

