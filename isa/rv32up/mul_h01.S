# See LICENSE for license details.

#*****************************************************************************
# mul_h01.S
#-----------------------------------------------------------------------------
#
# Test mul.h01 instruction (signed 16-bit multiply, low*high halves).
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV32U
RVTEST_CODE_BEGIN

  #-------------------------------------------------------------
  # Arithmetic tests
  #-------------------------------------------------------------

  # mul.h01 rd, rs1, rs2 = sext(rs1[15:0]) * sext(rs2[31:16])

  # Test case 1: 2 * 3 = 6 (rs2 high half = 3)
  TEST_RR_OP( 2, mul.h01, 0x00000006, 0x00000002, 0x00030000 );

  # Test case 2: Zero multiply
  TEST_RR_OP( 3, mul.h01, 0x00000000, 0x00000000, 0x00050000 );

  # Test case 3: 0x0101 * 0x0202 = 0x00020402
  TEST_RR_OP( 4, mul.h01, 0x00020402, 0x00000101, 0x02020000 );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END

