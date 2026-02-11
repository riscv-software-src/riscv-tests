# See LICENSE for license details.

#*****************************************************************************
# sshar.S
#-----------------------------------------------------------------------------
#
# Test sshar instruction (shift left logical signed rounding).
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV32U
RVTEST_CODE_BEGIN

  #-------------------------------------------------------------
  # Arithmetic tests
  #-------------------------------------------------------------

  # sshar rd, rs1, rs2
  # Performs shift with rounding (left if positive, right if negative)

  # Test case 1: Shift left by 1
  TEST_RR_OP( 2, sshar, 0x00000008, 0x00000004, 0x00000001 );

  # Test case 2: Shift by 0 (no change)
  TEST_RR_OP( 3, sshar, 0x00000004, 0x00000004, 0x00000000 );

  # Test case 3: Shift right by 1 with rounding (negative shift amount, 0x00000005 >> 1 = 0x00000003 rounded)
  TEST_RR_OP( 4, sshar, 0x00000003, 0x00000005, 0xffffffff );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END


