# See LICENSE for license details.

#*****************************************************************************
# pmulsu_w_h11.S
#-----------------------------------------------------------------------------
#
# Test pmulsu.w.h11 instruction (packed 16-bit to 32-bit multiply signed*unsigned, high halfwords, RV64 only).
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV64U
RVTEST_CODE_BEGIN

  # pmulsu.w.h11 rd, rs1, rs2 = sext(rs1[31:16]) * zext(rs2[31:16]) -> 32-bit

  # Test case 1: Simple multiply 2 * 3 = 6
  TEST_RR_OP( 2, pmulsu.w.h11, 0x0000000600000006, 0x0002000000020000, 0x0003000000030000 );

  # Test case 2: Zero multiply
  TEST_RR_OP( 3, pmulsu.w.h11, 0x0000000000000000, 0x0000000000000000, 0x0005000000050000 );

  # Test case 3: Larger values
  TEST_RR_OP( 4, pmulsu.w.h11, 0x0001000000010000, 0x0100000001000000, 0x0100000001000000 );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN
  TEST_DATA
RVTEST_DATA_END

