# See LICENSE for license details.

#*****************************************************************************
# pmulu_w_h00.S
#-----------------------------------------------------------------------------
#
# Test pmulu.w.h00 instruction (packed 16-bit to 32-bit multiply unsigned, low halfwords, RV64 only).
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV64U
RVTEST_CODE_BEGIN

  # pmulu.w.h00 rd, rs1, rs2 = zext(rs1[15:0]) * zext(rs2[15:0]) -> 32-bit

  # Test case 1: Simple multiply 2 * 3 = 6
  TEST_RR_OP( 2, pmulu.w.h00, 0x0000000600000006, 0x0002000200020002, 0x0003000300030003 );

  # Test case 2: Zero multiply
  TEST_RR_OP( 3, pmulu.w.h00, 0x0000000000000000, 0x0000000000000000, 0x0005000500050005 );

  # Test case 3: Larger values 0x100 * 0x100 = 0x10000
  TEST_RR_OP( 4, pmulu.w.h00, 0x0001000000010000, 0x0100010001000100, 0x0100010001000100 );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN
  TEST_DATA
RVTEST_DATA_END

