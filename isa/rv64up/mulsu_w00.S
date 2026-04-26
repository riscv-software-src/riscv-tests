# See LICENSE for license details.

#*****************************************************************************
# mulsu_w00.S
#-----------------------------------------------------------------------------
#
# Test mulsu.w00 instruction (signed*unsigned 32-bit multiply, low words, RV64 only).
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV64U
RVTEST_CODE_BEGIN

  #-------------------------------------------------------------
  # Arithmetic tests
  #-------------------------------------------------------------

  # mulsu.w00 rd, rs1, rs2 = sext32(rs1[31:0]) * zext32(rs2[31:0])

  # Test case 1: Simple multiply 2 * 3 = 6
  TEST_RR_OP( 2, mulsu.w00, 0x0000000000000006, 0x0000000000000002, 0x0000000000000003 );

  # Test case 2: Zero multiply
  TEST_RR_OP( 3, mulsu.w00, 0x0000000000000000, 0x0000000000000000, 0x0000000000000005 );

  # Test case 3: Negative signed * positive unsigned: -2 * 3 = -6
  TEST_RR_OP( 4, mulsu.w00, 0xfffffffffffffffa, 0x00000000fffffffe, 0x0000000000000003 );

  # Test case 4: Negative signed * large unsigned: -1 * 0xffffffff = -0xffffffff
  TEST_RR_OP( 5, mulsu.w00, 0xffffffff00000001, 0x00000000ffffffff, 0x00000000ffffffff );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END

