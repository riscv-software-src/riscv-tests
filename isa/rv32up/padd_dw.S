# See LICENSE for license details.

#*****************************************************************************
# padd_dw.S
#-----------------------------------------------------------------------------
#
# Test padd.dw instruction (packed word add, double-word, RV32 only).
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV32U
RVTEST_CODE_BEGIN

  #-------------------------------------------------------------
  # Arithmetic tests
  #-------------------------------------------------------------

  # padd.dw rd, rs1, rs2
  # Packed word addition on 64-bit register pairs

  # Test case 1: Simple word addition
  # Low:  0x00000001 + 0x00000002 = 0x00000003
  # High: 0x00000004 + 0x00000005 = 0x00000009
  TEST_CASE( 2, x14, 0x00000003, \
    li x10, 0x00000001; \
    li x11, 0x00000004; \
    li x12, 0x00000002; \
    li x13, 0x00000005; \
    padd.dw x14, x10, x12 );
  TEST_CASE( 3, x15, 0x00000009, nop );

  # Test case 2: Zero + Zero
  TEST_CASE( 4, x14, 0x00000000, \
    li x10, 0x00000000; \
    li x11, 0x00000000; \
    li x12, 0x00000000; \
    li x13, 0x00000000; \
    padd.dw x14, x10, x12 );
  TEST_CASE( 5, x15, 0x00000000, nop );

  # Test case 3: Word overflow (wraps)
  TEST_CASE( 6, x14, 0x00000000, \
    li x10, 0xFFFFFFFF; \
    li x11, 0xFFFFFFFF; \
    li x12, 0x00000001; \
    li x13, 0x00000001; \
    padd.dw x14, x10, x12 );
  TEST_CASE( 7, x15, 0x00000000, nop );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END

