# See LICENSE for license details.

#*****************************************************************************
# pasub_dh.S
#-----------------------------------------------------------------------------
#
# Test pasub.dh instruction (packed averaging halfword subtract, double-word, RV32 only).
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV32U
RVTEST_CODE_BEGIN

  #-------------------------------------------------------------
  # Arithmetic tests
  #-------------------------------------------------------------

  # pasub.dh rd, rs1, rs2
  # Packed averaging halfword subtraction: rd[i] = (rs1[i] - rs2[i]) >> 1 (signed)

  # Test case 1: Simple averaging subtract
  # (0x0004 - 0x0002) >> 1 = 0x0001
  TEST_CASE( 2, x14, 0x00010001, \
    li x10, 0x00040004; \
    li x11, 0x00040004; \
    li x12, 0x00020002; \
    li x13, 0x00020002; \
    pasub.dh x14, x10, x12 );
  TEST_CASE( 3, x15, 0x00010001, nop );

  # Test case 2: Zero averaging
  TEST_CASE( 4, x14, 0x00000000, \
    li x10, 0x00000000; \
    li x11, 0x00000000; \
    li x12, 0x00000000; \
    li x13, 0x00000000; \
    pasub.dh x14, x10, x12 );
  TEST_CASE( 5, x15, 0x00000000, nop );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END

