# See LICENSE for license details.

#*****************************************************************************
# psadd_dh.S
#-----------------------------------------------------------------------------
#
# Test psadd.dh instruction (packed saturating halfword add, double-word, RV32 only).
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV32U
RVTEST_CODE_BEGIN

  #-------------------------------------------------------------
  # Arithmetic tests
  #-------------------------------------------------------------

  # psadd.dh rd, rs1, rs2
  # Packed saturating halfword addition (signed): saturates to [-32768, 32767]

  # Test case 1: Simple addition (no saturation)
  TEST_CASE( 2, x14, 0x00030003, \
    li x10, 0x00010001; \
    li x11, 0x00010001; \
    li x12, 0x00020002; \
    li x13, 0x00020002; \
    psadd.dh x14, x10, x12 );
  TEST_CASE( 3, x15, 0x00030003, nop );

  # Test case 2: Positive saturation (0x7FFF + 0x0001 saturates to 0x7FFF)
  TEST_CASE( 4, x14, 0x7FFF7FFF, \
    li x10, 0x7FFF7FFF; \
    li x11, 0x7FFF7FFF; \
    li x12, 0x00010001; \
    li x13, 0x00010001; \
    psadd.dh x14, x10, x12 );
  TEST_CASE( 5, x15, 0x7FFF7FFF, nop );

  # Test case 3: Zero + Zero
  TEST_CASE( 6, x14, 0x00000000, \
    li x10, 0x00000000; \
    li x11, 0x00000000; \
    li x12, 0x00000000; \
    li x13, 0x00000000; \
    psadd.dh x14, x10, x12 );
  TEST_CASE( 7, x15, 0x00000000, nop );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END

