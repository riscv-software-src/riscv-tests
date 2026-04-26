# See LICENSE for license details.

#*****************************************************************************
# predsumu_ws.S
#-----------------------------------------------------------------------------
#
# Test predsumu.ws instruction (packed reduction sum word unsigned, RV64 only).
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV64U
RVTEST_CODE_BEGIN

  # predsumu.ws rd, rs1, rs2
  # Computes reduction sum of unsigned 32-bit words from rs1, adds to rs2

  # Test case 1: Simple reduction sum
  # rs1 = 0x0000000200000001 (words: 1, 2)
  # sum = 1+2 = 3
  # rs2 = 0, result = 3
  TEST_RR_OP( 2, predsumu.ws, 0x0000000000000003, 0x0000000200000001, 0x0000000000000000 );

  # Test case 2: Zero sum
  TEST_RR_OP( 3, predsumu.ws, 0x0000000000000000, 0x0000000000000000, 0x0000000000000000 );

  # Test case 3: With base value in rs2
  # sum of words = 3, rs2 = 0x10, result = 0x13
  TEST_RR_OP( 4, predsumu.ws, 0x0000000000000013, 0x0000000200000001, 0x0000000000000010 );

  # Test case 4: Large unsigned words
  # rs1 = 0x8000000080000000 (two 0x80000000 unsigned words)
  # sum = 0x80000000 + 0x80000000 = 0x100000000
  TEST_RR_OP( 5, predsumu.ws, 0x0000000100000000, 0x8000000080000000, 0x0000000000000000 );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN
  TEST_DATA
RVTEST_DATA_END

