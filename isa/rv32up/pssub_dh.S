# See LICENSE for license details.

#*****************************************************************************
# pssub_dh.S
#-----------------------------------------------------------------------------
#
# Test pssub.dh instruction (packed saturating halfword subtract, double-word, RV32 only).
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV32U
RVTEST_CODE_BEGIN

  #-------------------------------------------------------------
  # Arithmetic tests
  #-------------------------------------------------------------

  # pssub.dh rd, rs1, rs2
  # Packed saturating halfword subtraction (signed): saturates to [-32768, 32767]

  # Test case 1: Simple subtraction (no saturation)
  TEST_CASE( 2, x14, 0x00010001, \
    li x10, 0x00030003; \
    li x11, 0x00030003; \
    li x12, 0x00020002; \
    li x13, 0x00020002; \
    pssub.dh x14, x10, x12 );
  TEST_CASE( 3, x15, 0x00010001, nop );

  # Test case 2: Negative saturation (0x8000 - 0x0001 saturates to 0x8000)
  TEST_CASE( 4, x14, 0x80008000, \
    li x10, 0x80008000; \
    li x11, 0x80008000; \
    li x12, 0x00010001; \
    li x13, 0x00010001; \
    pssub.dh x14, x10, x12 );
  TEST_CASE( 5, x15, 0x80008000, nop );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END

