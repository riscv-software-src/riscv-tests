# See LICENSE for license details.

#*****************************************************************************
# psh1add_dh.S
#-----------------------------------------------------------------------------
#
# Test psh1add.dh instruction (packed shift-left-1 add halfword, double-word, RV32 only).
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV32U
RVTEST_CODE_BEGIN

  #-------------------------------------------------------------
  # Arithmetic tests
  #-------------------------------------------------------------

  # psh1add.dh rd, rs1, rs2
  # Packed shift-left-1 add: rd[i] = (rs1[i] << 1) + rs2[i] for halfwords

  # Test case 1: (2 << 1) + 1 = 5
  TEST_CASE( 2, x14, 0x00050005, \
    li x10, 0x00020002; \
    li x11, 0x00020002; \
    li x12, 0x00010001; \
    li x13, 0x00010001; \
    psh1add.dh x14, x10, x12 );
  TEST_CASE( 3, x15, 0x00050005, nop );

  # Test case 2: Zero operations
  TEST_CASE( 4, x14, 0x00000000, \
    li x10, 0x00000000; \
    li x11, 0x00000000; \
    li x12, 0x00000000; \
    li x13, 0x00000000; \
    psh1add.dh x14, x10, x12 );
  TEST_CASE( 5, x15, 0x00000000, nop );

  # Test case 3: (3 << 1) + 2 = 8
  TEST_CASE( 6, x14, 0x00080008, \
    li x10, 0x00030003; \
    li x11, 0x00030003; \
    li x12, 0x00020002; \
    li x13, 0x00020002; \
    psh1add.dh x14, x10, x12 );
  TEST_CASE( 7, x15, 0x00080008, nop );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END

