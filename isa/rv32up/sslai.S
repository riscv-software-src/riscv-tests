# See LICENSE for license details.

#*****************************************************************************
# sslai.S
#-----------------------------------------------------------------------------
#
# Test sslai instruction (saturating shift left arithmetic immediate).
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV32U
RVTEST_CODE_BEGIN

  #-------------------------------------------------------------
  # Arithmetic tests
  #-------------------------------------------------------------

  # sslai rd, rs1, imm
  # Performs saturating shift left by immediate

  # Test case 1: Shift left by 1 (no saturation)
  TEST_CASE( 2, x14, 0x00000008, li a1, 0x00000004; sslai x14, a1, 1 );

  # Test case 2: Shift by 0 (no change)
  TEST_CASE( 3, x14, 0x00000004, li a1, 0x00000004; sslai x14, a1, 0 );

  # Test case 3: Shift with saturation (0x70000000 << 4 saturates to 0x7FFFFFFF)
  TEST_CASE( 4, x14, 0x7fffffff, li a1, 0x70000000; sslai x14, a1, 4 );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END


