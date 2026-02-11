# See LICENSE for license details.

#*****************************************************************************
# pssh1sadd_dh.S
#-----------------------------------------------------------------------------
#
# Test pssh1sadd.dh instruction (packed saturating shift-left-1 add halfword, double-word, RV32 only).
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV32U
RVTEST_CODE_BEGIN

  #-------------------------------------------------------------
  # Arithmetic tests
  #-------------------------------------------------------------

  # pssh1sadd.dh rd, rs1, rs2
  # Packed saturating shift-left-1 add for halfwords

  # Test case 1: (2 << 1) + 1 = 5 (no saturation)
  TEST_CASE( 2, x14, 0x00050005, \
    li x10, 0x00020002; \
    li x11, 0x00020002; \
    li x12, 0x00010001; \
    li x13, 0x00010001; \
    pssh1sadd.dh x14, x10, x12 );
  TEST_CASE( 3, x15, 0x00050005, nop );

  # Test case 2: Saturation case (0x4000 << 1) + 0x0001 would overflow, saturates to 0x7FFF
  TEST_CASE( 4, x14, 0x7FFF7FFF, \
    li x10, 0x40004000; \
    li x11, 0x40004000; \
    li x12, 0x00010001; \
    li x13, 0x00010001; \
    pssh1sadd.dh x14, x10, x12 );
  TEST_CASE( 5, x15, 0x7FFF7FFF, nop );

  # Test case 3: Zero operations
  TEST_CASE( 6, x14, 0x00000000, \
    li x10, 0x00000000; \
    li x11, 0x00000000; \
    li x12, 0x00000000; \
    li x13, 0x00000000; \
    pssh1sadd.dh x14, x10, x12 );
  TEST_CASE( 7, x15, 0x00000000, nop );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END

