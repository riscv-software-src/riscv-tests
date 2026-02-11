# See LICENSE for license details.

#*****************************************************************************
# wsubau.S
#-----------------------------------------------------------------------------
#
# Test wsubau instruction (unsigned widening subtract accumulate, RV32 only).
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV32U
RVTEST_CODE_BEGIN

  #-------------------------------------------------------------
  # Arithmetic tests
  #-------------------------------------------------------------

  # wsubau rd, rs1, rs2
  # Unsigned widening subtract accumulate: rd_pair += zero_ext(rs1) - zero_ext(rs2)

  # Test case 1: Accumulate with initial value
  TEST_CASE( 2, x14, 0x00000012, \
    li x14, 0x00000010; \
    li x15, 0x00000000; \
    li x10, 0x00000003; \
    li x12, 0x00000001; \
    wsubau x14, x10, x12 );
  TEST_CASE( 3, x15, 0x00000000, nop );

  # Test case 2: Unsigned subtract accumulate with high values
  # 0x00000010 + (0xFFFFFFFF - 0x00000001) = 0x0000000E + 0xFFFFFFFE = 0x0000000E + 0xFFFFFFFE = 0x1_0000000C
  TEST_CASE( 4, x14, 0x0000000E, \
    li x14, 0x00000010; \
    li x15, 0x00000000; \
    li x10, 0xFFFFFFFF; \
    li x12, 0x00000001; \
    wsubau x14, x10, x12 );
  TEST_CASE( 5, x15, 0x00000001, nop );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END

