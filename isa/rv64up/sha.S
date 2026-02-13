# See LICENSE for license details.

#*****************************************************************************
# sha.S
#-----------------------------------------------------------------------------
#
# Test sha instruction (scalar bidirectional shift arithmetic, RV64 only).
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV64U
RVTEST_CODE_BEGIN

  # sha rd, rs1, rs2
  # Bidirectional arithmetic shift: positive rs2 = left shift, negative rs2 = right shift

  # Test case 1: Shift left by 1
  TEST_RR_OP( 2, sha, 0x0000000000000004, 0x0000000000000002, 0x0000000000000001 );

  # Test case 2: Shift left by 4
  TEST_RR_OP( 3, sha, 0x0000000000000020, 0x0000000000000002, 0x0000000000000004 );

  # Test case 3: Shift right by 1 (negative shift amount = -1 = 0xff in low 8 bits)
  TEST_RR_OP( 4, sha, 0x0000000000000001, 0x0000000000000002, 0xffffffffffffffff );

  # Test case 4: Shift right by 4 with sign extension
  TEST_RR_OP( 5, sha, 0xf800000000000000, 0x8000000000000000, 0xfffffffffffffffc );

  # Test case 5: Zero input
  TEST_RR_OP( 6, sha, 0x0000000000000000, 0x0000000000000000, 0x0000000000000004 );

  # Test case 6: Shift right positive value
  TEST_RR_OP( 7, sha, 0x0400000000000000, 0x4000000000000000, 0xfffffffffffffffc );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN
  TEST_DATA
RVTEST_DATA_END

