# See LICENSE for license details.

#*****************************************************************************
# mulu_w00.S
#-----------------------------------------------------------------------------
#
# Test mulu.w00 instruction (unsigned 32-bit multiply, low words, RV64 only).
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV64U
RVTEST_CODE_BEGIN

  #-------------------------------------------------------------
  # Arithmetic tests
  #-------------------------------------------------------------

  # mulu.w00 rd, rs1, rs2 = zext32(rs1[31:0]) * zext32(rs2[31:0])

  # Test case 1: Simple multiply 2 * 3 = 6
  TEST_RR_OP( 2, mulu.w00, 0x0000000000000006, 0x0000000000000002, 0x0000000000000003 );

  # Test case 2: Zero multiply
  TEST_RR_OP( 3, mulu.w00, 0x0000000000000000, 0x0000000000000000, 0x0000000000000005 );

  # Test case 3: 0x00010001 * 0x00020002 = 0x0000000200040002
  TEST_RR_OP( 4, mulu.w00, 0x0000000200040002, 0x0000000000010001, 0x0000000000020002 );

  # Test case 4: Large unsigned: 0xffffffff * 2 = 0x1fffffffe
  TEST_RR_OP( 5, mulu.w00, 0x00000001fffffffe, 0x00000000ffffffff, 0x0000000000000002 );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END

