# See LICENSE for license details.

#*****************************************************************************
# psadd_dw.S
#-----------------------------------------------------------------------------
#
# Test psadd.dw instruction (packed saturating word add, double-word, RV32 only).
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV32U
RVTEST_CODE_BEGIN

  #-------------------------------------------------------------
  # Arithmetic tests
  #-------------------------------------------------------------

  # psadd.dw rd, rs1, rs2
  # Packed saturating word addition (signed): saturates to INT32_MIN/MAX

  # Test case 1: Simple addition (no saturation)
  TEST_CASE( 2, x14, 0x00000003, \
    li x10, 0x00000001; \
    li x11, 0x00000001; \
    li x12, 0x00000002; \
    li x13, 0x00000002; \
    psadd.dw x14, x10, x12 );
  TEST_CASE( 3, x15, 0x00000003, nop );

  # Test case 2: Positive saturation (0x7FFFFFFF + 0x00000001 saturates to 0x7FFFFFFF)
  TEST_CASE( 4, x14, 0x7FFFFFFF, \
    li x10, 0x7FFFFFFF; \
    li x11, 0x7FFFFFFF; \
    li x12, 0x00000001; \
    li x13, 0x00000001; \
    psadd.dw x14, x10, x12 );
  TEST_CASE( 5, x15, 0x7FFFFFFF, nop );

  # Test case 3: Zero + Zero
  TEST_CASE( 6, x14, 0x00000000, \
    li x10, 0x00000000; \
    li x11, 0x00000000; \
    li x12, 0x00000000; \
    li x13, 0x00000000; \
    psadd.dw x14, x10, x12 );
  TEST_CASE( 7, x15, 0x00000000, nop );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END

