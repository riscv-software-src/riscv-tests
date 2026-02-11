# See LICENSE for license details.

#*****************************************************************************
# pwsub_h.S
#-----------------------------------------------------------------------------
#
# Test pwsub.h instruction (packed widening halfword subtract, RV32 only).
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV32U
RVTEST_CODE_BEGIN

  #-------------------------------------------------------------
  # Arithmetic tests
  #-------------------------------------------------------------

  # pwsub.h rd, rs1, rs2
  # Packed widening subtract: 16-bit to 32-bit, signed
  # rd_pair[i] = sign_ext(rs1[i]) - sign_ext(rs2[i])

  # Test case 1: Simple widening subtract
  # 0x0003 - 0x0001 = 0x00000002 (for each halfword pair)
  TEST_CASE( 2, x14, 0x00000002, \
    li x10, 0x00030003; \
    li x12, 0x00010001; \
    pwsub.h x14, x10, x12 );
  TEST_CASE( 3, x15, 0x00000002, nop );

  # Test case 2: Zero - Zero
  TEST_CASE( 4, x14, 0x00000000, \
    li x10, 0x00000000; \
    li x12, 0x00000000; \
    pwsub.h x14, x10, x12 );
  TEST_CASE( 5, x15, 0x00000000, nop );

  # Test case 3: Negative result (signed)
  # 0x0001 - 0x0002 = 0xFFFFFFFF (-1)
  TEST_CASE( 6, x14, 0xFFFFFFFF, \
    li x10, 0x00010001; \
    li x12, 0x00020002; \
    pwsub.h x14, x10, x12 );
  TEST_CASE( 7, x15, 0xFFFFFFFF, nop );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END

