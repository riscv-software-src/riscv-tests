# See LICENSE for license details.

#*****************************************************************************
# shar.S
#-----------------------------------------------------------------------------
#
# Test shar instruction (scalar bidirectional shift arithmetic rounding, RV64 only).
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV64U
RVTEST_CODE_BEGIN

  # shar rd, rs1, rs2
  # Bidirectional arithmetic shift with rounding on right shift
  # Positive rs2 = left shift, negative rs2 = right shift with rounding

  # Test case 1: Shift left by 1
  TEST_RR_OP( 2, shar, 0x0000000000000004, 0x0000000000000002, 0x0000000000000001 );

  # Test case 2: Shift left by 4
  TEST_RR_OP( 3, shar, 0x0000000000000020, 0x0000000000000002, 0x0000000000000004 );

  # Test case 3: Shift right by 1 with rounding (3 >> 1 = 1, but with rounding = 2)
  TEST_RR_OP( 4, shar, 0x0000000000000002, 0x0000000000000003, 0xffffffffffffffff );

  # Test case 4: Shift right by 1 no rounding needed (2 >> 1 = 1)
  TEST_RR_OP( 5, shar, 0x0000000000000001, 0x0000000000000002, 0xffffffffffffffff );

  # Test case 5: Zero input
  TEST_RR_OP( 6, shar, 0x0000000000000000, 0x0000000000000000, 0x0000000000000004 );

  # Test case 6: Shift right by 4 with rounding
  TEST_RR_OP( 7, shar, 0x0400000000000001, 0x4000000000000008, 0xfffffffffffffffc );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN
  TEST_DATA
RVTEST_DATA_END

