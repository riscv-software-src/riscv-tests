# See LICENSE for license details.

#*****************************************************************************
# predsum_ws.S
#-----------------------------------------------------------------------------
#
# Test predsum.ws instruction (packed reduction sum word signed, RV64 only).
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV64U
RVTEST_CODE_BEGIN

  # predsum.ws rd, rs1, rs2
  # Computes reduction sum of signed 32-bit words from rs1, adds to rs2

  # Test case 1: Simple reduction sum
  # rs1 = 0x0000000200000001 (words: 1, 2)
  # sum = 1+2 = 3
  # rs2 = 0, result = 3
  TEST_RR_OP( 2, predsum.ws, 0x0000000000000003, 0x0000000200000001, 0x0000000000000000 );

  # Test case 2: Zero sum
  TEST_RR_OP( 3, predsum.ws, 0x0000000000000000, 0x0000000000000000, 0x0000000000000000 );

  # Test case 3: With base value in rs2
  # sum of words = 3, rs2 = 0x10, result = 0x13
  TEST_RR_OP( 4, predsum.ws, 0x0000000000000013, 0x0000000200000001, 0x0000000000000010 );

  # Test case 4: Negative words (signed)
  # rs1 = 0xffffffffffffffff (two -1 signed words)
  # sum = -1 + -1 = -2 = 0xfffffffffffffffe
  TEST_RR_OP( 5, predsum.ws, 0xfffffffffffffffe, 0xffffffffffffffff, 0x0000000000000000 );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN
  TEST_DATA
RVTEST_DATA_END

