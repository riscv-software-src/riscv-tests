# See LICENSE for license details.

#*****************************************************************************
# predsum_bs.S
#-----------------------------------------------------------------------------
#
# Test predsum.bs instruction (packed reduction sum byte signed).
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV64U
RVTEST_CODE_BEGIN

  #-------------------------------------------------------------
  # Arithmetic tests
  #-------------------------------------------------------------

  # predsum.bs rd, rs1, rs2
  # Computes reduction sum of signed bytes from rs1, adds to rs2

  # Test case 1: Simple reduction sum
  # rs1 = 0x0102030405060708 (bytes: 1,2,3,4,5,6,7,8)
  # sum = 1+2+3+4+5+6+7+8 = 36 = 0x24
  # rs2 = 0, result = 0x24
  TEST_RR_OP( 2, predsum.bs, 0x0000000000000024, 0x0102030405060708, 0x0000000000000000 );

  # Test case 2: Zero sum
  TEST_RR_OP( 3, predsum.bs, 0x0000000000000000, 0x0000000000000000, 0x0000000000000000 );

  # Test case 3: With base value in rs2
  # sum of bytes = 36, rs2 = 0x10, result = 0x34
  TEST_RR_OP( 4, predsum.bs, 0x0000000000000034, 0x0102030405060708, 0x0000000000000010 );

  # Test case 4: Negative bytes (signed)
  # rs1 = 0xffffffffffffffff (all -1 signed bytes)
  # sum = -1 * 8 = -8 = 0xfffffffffffffff8
  TEST_RR_OP( 5, predsum.bs, 0xfffffffffffffff8, 0xffffffffffffffff, 0x0000000000000000 );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END

