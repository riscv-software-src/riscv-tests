# See LICENSE for license details.

#*****************************************************************************
# pssubu_dw.S
#-----------------------------------------------------------------------------
#
# Test pssubu.dw instruction (packed unsigned saturating word subtract, double-word, RV32 only).
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV32U
RVTEST_CODE_BEGIN

  #-------------------------------------------------------------
  # Arithmetic tests
  #-------------------------------------------------------------

  # pssubu.dw rd, rs1, rs2
  # Packed unsigned saturating word subtraction: saturates to [0, UINT32_MAX]

  # Test case 1: Simple subtraction (no saturation)
  TEST_CASE( 2, x14, 0x00000001, \
    li x10, 0x00000003; \
    li x11, 0x00000003; \
    li x12, 0x00000002; \
    li x13, 0x00000002; \
    pssubu.dw x14, x10, x12 );
  TEST_CASE( 3, x15, 0x00000001, nop );

  # Test case 2: Unsigned saturation to 0 (0x00000000 - 0x00000001 saturates to 0x00000000)
  TEST_CASE( 4, x14, 0x00000000, \
    li x10, 0x00000000; \
    li x11, 0x00000000; \
    li x12, 0x00000001; \
    li x13, 0x00000001; \
    pssubu.dw x14, x10, x12 );
  TEST_CASE( 5, x15, 0x00000000, nop );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END

