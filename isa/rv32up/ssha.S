# See LICENSE for license details.

#*****************************************************************************
# ssha.S
#-----------------------------------------------------------------------------
#
# Test ssha instruction (shift left logical signed).
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV32U
RVTEST_CODE_BEGIN

  #-------------------------------------------------------------
  # Arithmetic tests
  #-------------------------------------------------------------

  # ssha rd, rs1, rs2
  # Performs shift (left if positive, right if negative)

  # Test case 1: Shift left by 1
  TEST_RR_OP( 2, ssha, 0x00000008, 0x00000004, 0x00000001 );

  # Test case 2: Shift by 0 (no change)
  TEST_RR_OP( 3, ssha, 0x00000004, 0x00000004, 0x00000000 );

  # Test case 3: Shift right by 1 (negative shift amount)
  TEST_RR_OP( 4, ssha, 0x00000002, 0x00000004, 0xffffffff );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END


