# See LICENSE for license details.

#*****************************************************************************
# pssubu_dh.S
#-----------------------------------------------------------------------------
#
# Test pssubu.dh instruction (packed unsigned saturating halfword subtract, double-word, RV32 only).
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV32U
RVTEST_CODE_BEGIN

  #-------------------------------------------------------------
  # Arithmetic tests
  #-------------------------------------------------------------

  # pssubu.dh rd, rs1, rs2
  # Packed unsigned saturating halfword subtraction: saturates to [0, 65535]

  # Test case 1: Simple subtraction (no saturation)
  TEST_CASE( 2, x14, 0x00010001, \
    li x10, 0x00030003; \
    li x11, 0x00030003; \
    li x12, 0x00020002; \
    li x13, 0x00020002; \
    pssubu.dh x14, x10, x12 );
  TEST_CASE( 3, x15, 0x00010001, nop );

  # Test case 2: Unsigned saturation to 0 (0x0000 - 0x0001 saturates to 0x0000)
  TEST_CASE( 4, x14, 0x00000000, \
    li x10, 0x00000000; \
    li x11, 0x00000000; \
    li x12, 0x00010001; \
    li x13, 0x00010001; \
    pssubu.dh x14, x10, x12 );
  TEST_CASE( 5, x15, 0x00000000, nop );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END

