# See LICENSE for license details.

#*****************************************************************************
# pwsub_b.S
#-----------------------------------------------------------------------------
#
# Test pwsub.b instruction (packed widening byte subtract, RV32 only).
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV32U
RVTEST_CODE_BEGIN

  #-------------------------------------------------------------
  # Arithmetic tests
  #-------------------------------------------------------------

  # pwsub.b rd, rs1, rs2
  # Packed widening subtract: 8-bit to 16-bit, signed
  # rd_pair[i] = sign_ext(rs1[i]) - sign_ext(rs2[i])

  # Test case 1: Simple widening subtract
  # 0x03 - 0x01 = 0x0002 (for each byte pair)
  TEST_CASE( 2, x14, 0x00020002, \
    li x10, 0x03030303; \
    li x12, 0x01010101; \
    pwsub.b x14, x10, x12 );
  TEST_CASE( 3, x15, 0x00020002, nop );

  # Test case 2: Zero - Zero
  TEST_CASE( 4, x14, 0x00000000, \
    li x10, 0x00000000; \
    li x12, 0x00000000; \
    pwsub.b x14, x10, x12 );
  TEST_CASE( 5, x15, 0x00000000, nop );

  # Test case 3: Negative result (signed)
  # 0x01 - 0x02 = 0xFFFF (-1)
  TEST_CASE( 6, x14, 0xFFFFFFFF, \
    li x10, 0x01010101; \
    li x12, 0x02020202; \
    pwsub.b x14, x10, x12 );
  TEST_CASE( 7, x15, 0xFFFFFFFF, nop );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END

