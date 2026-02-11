# See LICENSE for license details.

#*****************************************************************************
# psaddu_dw.S
#-----------------------------------------------------------------------------
#
# Test psaddu.dw instruction (packed unsigned saturating word add, double-word, RV32 only).
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV32U
RVTEST_CODE_BEGIN

  #-------------------------------------------------------------
  # Arithmetic tests
  #-------------------------------------------------------------

  # psaddu.dw rd, rs1, rs2
  # Packed unsigned saturating word addition: saturates to [0, UINT32_MAX]

  # Test case 1: Simple addition (no saturation)
  TEST_CASE( 2, x14, 0x00000003, \
    li x10, 0x00000001; \
    li x11, 0x00000001; \
    li x12, 0x00000002; \
    li x13, 0x00000002; \
    psaddu.dw x14, x10, x12 );
  TEST_CASE( 3, x15, 0x00000003, nop );

  # Test case 2: Unsigned saturation (0xFFFFFFFF + 0x00000001 saturates to 0xFFFFFFFF)
  TEST_CASE( 4, x14, 0xFFFFFFFF, \
    li x10, 0xFFFFFFFF; \
    li x11, 0xFFFFFFFF; \
    li x12, 0x00000001; \
    li x13, 0x00000001; \
    psaddu.dw x14, x10, x12 );
  TEST_CASE( 5, x15, 0xFFFFFFFF, nop );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END

