# See LICENSE for license details.

#*****************************************************************************
# pasub_dw.S
#-----------------------------------------------------------------------------
#
# Test pasub.dw instruction (packed averaging word subtract, double-word, RV32 only).
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV32U
RVTEST_CODE_BEGIN

  #-------------------------------------------------------------
  # Arithmetic tests
  #-------------------------------------------------------------

  # pasub.dw rd, rs1, rs2
  # Packed averaging word subtraction: rd[i] = (rs1[i] - rs2[i]) >> 1 (signed)

  # Test case 1: Simple averaging subtract
  # (0x00000004 - 0x00000002) >> 1 = 0x00000001
  TEST_CASE( 2, x14, 0x00000001, \
    li x10, 0x00000004; \
    li x11, 0x00000004; \
    li x12, 0x00000002; \
    li x13, 0x00000002; \
    pasub.dw x14, x10, x12 );
  TEST_CASE( 3, x15, 0x00000001, nop );

  # Test case 2: Zero averaging
  TEST_CASE( 4, x14, 0x00000000, \
    li x10, 0x00000000; \
    li x11, 0x00000000; \
    li x12, 0x00000000; \
    li x13, 0x00000000; \
    pasub.dw x14, x10, x12 );
  TEST_CASE( 5, x15, 0x00000000, nop );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END

