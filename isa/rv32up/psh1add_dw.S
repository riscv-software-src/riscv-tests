# See LICENSE for license details.

#*****************************************************************************
# psh1add_dw.S
#-----------------------------------------------------------------------------
#
# Test psh1add.dw instruction (packed shift-left-1 add word, double-word, RV32 only).
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV32U
RVTEST_CODE_BEGIN

  #-------------------------------------------------------------
  # Arithmetic tests
  #-------------------------------------------------------------

  # psh1add.dw rd, rs1, rs2
  # Packed shift-left-1 add: rd[i] = (rs1[i] << 1) + rs2[i] for words

  # Test case 1: (2 << 1) + 1 = 5
  TEST_CASE( 2, x14, 0x00000005, \
    li x10, 0x00000002; \
    li x11, 0x00000002; \
    li x12, 0x00000001; \
    li x13, 0x00000001; \
    psh1add.dw x14, x10, x12 );
  TEST_CASE( 3, x15, 0x00000005, nop );

  # Test case 2: Zero operations
  TEST_CASE( 4, x14, 0x00000000, \
    li x10, 0x00000000; \
    li x11, 0x00000000; \
    li x12, 0x00000000; \
    li x13, 0x00000000; \
    psh1add.dw x14, x10, x12 );
  TEST_CASE( 5, x15, 0x00000000, nop );

  # Test case 3: (3 << 1) + 2 = 8
  TEST_CASE( 6, x14, 0x00000008, \
    li x10, 0x00000003; \
    li x11, 0x00000003; \
    li x12, 0x00000002; \
    li x13, 0x00000002; \
    psh1add.dw x14, x10, x12 );
  TEST_CASE( 7, x15, 0x00000008, nop );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END

