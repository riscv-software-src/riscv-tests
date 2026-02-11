# See LICENSE for license details.

#*****************************************************************************
# psub_dw.S
#-----------------------------------------------------------------------------
#
# Test psub.dw instruction (packed word subtract, double-word, RV32 only).
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV32U
RVTEST_CODE_BEGIN

  #-------------------------------------------------------------
  # Arithmetic tests
  #-------------------------------------------------------------

  # psub.dw rd, rs1, rs2
  # Packed word subtraction on 64-bit register pairs

  # Test case 1: Simple word subtraction
  # Low:  0x00000003 - 0x00000002 = 0x00000001
  # High: 0x00000009 - 0x00000005 = 0x00000004
  TEST_CASE( 2, x14, 0x00000001, \
    li x10, 0x00000003; \
    li x11, 0x00000009; \
    li x12, 0x00000002; \
    li x13, 0x00000005; \
    psub.dw x14, x10, x12 );
  TEST_CASE( 3, x15, 0x00000004, nop );

  # Test case 2: Zero - Zero
  TEST_CASE( 4, x14, 0x00000000, \
    li x10, 0x00000000; \
    li x11, 0x00000000; \
    li x12, 0x00000000; \
    li x13, 0x00000000; \
    psub.dw x14, x10, x12 );
  TEST_CASE( 5, x15, 0x00000000, nop );

  # Test case 3: Word underflow (wraps)
  TEST_CASE( 6, x14, 0xFFFFFFFF, \
    li x10, 0x00000000; \
    li x11, 0x00000000; \
    li x12, 0x00000001; \
    li x13, 0x00000001; \
    psub.dw x14, x10, x12 );
  TEST_CASE( 7, x15, 0xFFFFFFFF, nop );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END

