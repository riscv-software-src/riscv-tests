# See LICENSE for license details.

#*****************************************************************************
# mulsu_h11.S
#-----------------------------------------------------------------------------
#
# Test mulsu.h11 instruction (signed-unsigned 16-bit multiply, high halves).
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV32U
RVTEST_CODE_BEGIN

  #-------------------------------------------------------------
  # Arithmetic tests
  #-------------------------------------------------------------

  # mulsu.h11 rd, rs1, rs2 = sext(rs1[31:16]) * zext(rs2[31:16])

  # Test case 1: Simple multiply 2 * 3 = 6
  TEST_RR_OP( 2, mulsu.h11, 0x00000006, 0x00020000, 0x00030000 );

  # Test case 2: Zero multiply
  TEST_RR_OP( 3, mulsu.h11, 0x00000000, 0x00000000, 0x00050000 );

  # Test case 3: 0x0101 * 0x0202 = 0x00020402
  TEST_RR_OP( 4, mulsu.h11, 0x00020402, 0x01010000, 0x02020000 );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END

