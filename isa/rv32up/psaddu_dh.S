# See LICENSE for license details.

#*****************************************************************************
# psaddu_dh.S
#-----------------------------------------------------------------------------
#
# Test psaddu.dh instruction (packed unsigned saturating halfword add, double-word, RV32 only).
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV32U
RVTEST_CODE_BEGIN

  #-------------------------------------------------------------
  # Arithmetic tests
  #-------------------------------------------------------------

  # psaddu.dh rd, rs1, rs2
  # Packed unsigned saturating halfword addition: saturates to [0, 65535]

  # Test case 1: Simple addition (no saturation)
  TEST_CASE( 2, x14, 0x00030003, \
    li x10, 0x00010001; \
    li x11, 0x00010001; \
    li x12, 0x00020002; \
    li x13, 0x00020002; \
    psaddu.dh x14, x10, x12 );
  TEST_CASE( 3, x15, 0x00030003, nop );

  # Test case 2: Unsigned saturation (0xFFFF + 0x0001 saturates to 0xFFFF)
  TEST_CASE( 4, x14, 0xFFFFFFFF, \
    li x10, 0xFFFFFFFF; \
    li x11, 0xFFFFFFFF; \
    li x12, 0x00010001; \
    li x13, 0x00010001; \
    psaddu.dh x14, x10, x12 );
  TEST_CASE( 5, x15, 0xFFFFFFFF, nop );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END

