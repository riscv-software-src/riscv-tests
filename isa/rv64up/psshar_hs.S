# See LICENSE for license details.

#*****************************************************************************
# psshar_hs.S
#-----------------------------------------------------------------------------
#
# Test psshar.hs instruction (packed shift left logical halfword signed rounding).
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV64U
RVTEST_CODE_BEGIN

  #-------------------------------------------------------------
  # Arithmetic tests
  #-------------------------------------------------------------

  # psshar.hs rd, rs1, rs2
  # Performs packed halfword shift with rounding (left if positive, right if negative)

  # Test case 1: Shift left by 1
  TEST_RR_OP( 2, psshar.hs, 0x0002000400060008, 0x0001000200030004, 0x0001000100010001 );

  # Test case 2: Shift by 0 (no change)
  TEST_RR_OP( 3, psshar.hs, 0x0001000200030004, 0x0001000200030004, 0x0000000000000000 );

  # Test case 3: Shift right by 1 with rounding (negative shift amount)
  TEST_RR_OP( 4, psshar.hs, 0x0001000100020002, 0x0001000200030004, 0xffffffffffffffff );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END


