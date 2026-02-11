# See LICENSE for license details.

#*****************************************************************************
# predsumu_bs.S
#-----------------------------------------------------------------------------
#
# Test predsumu.bs instruction (packed reduction sum byte unsigned).
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV64U
RVTEST_CODE_BEGIN

  #-------------------------------------------------------------
  # Arithmetic tests
  #-------------------------------------------------------------

  # predsumu.bs rd, rs1, rs2
  # Computes reduction sum of unsigned bytes from rs1, adds to rs2

  # Test case 1: Simple reduction sum
  # rs1 = 0x0102030405060708 (bytes: 1,2,3,4,5,6,7,8)
  # sum = 1+2+3+4+5+6+7+8 = 36 = 0x24
  # rs2 = 0, result = 0x24
  TEST_RR_OP( 2, predsumu.bs, 0x0000000000000024, 0x0102030405060708, 0x0000000000000000 );

  # Test case 2: Zero sum
  TEST_RR_OP( 3, predsumu.bs, 0x0000000000000000, 0x0000000000000000, 0x0000000000000000 );

  # Test case 3: With base value in rs2
  # sum of bytes = 36, rs2 = 0x10, result = 0x34
  TEST_RR_OP( 4, predsumu.bs, 0x0000000000000034, 0x0102030405060708, 0x0000000000000010 );

  # Test case 4: Max unsigned bytes
  # rs1 = 0xffffffffffffffff (all 255 unsigned bytes)
  # sum = 255 * 8 = 2040 = 0x7f8
  TEST_RR_OP( 5, predsumu.bs, 0x00000000000007f8, 0xffffffffffffffff, 0x0000000000000000 );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END

