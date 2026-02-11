# See LICENSE for license details.

#*****************************************************************************
# predsumu_hs.S
#-----------------------------------------------------------------------------
#
# Test predsumu.hs instruction (packed reduction sum halfword unsigned).
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV64U
RVTEST_CODE_BEGIN

  #-------------------------------------------------------------
  # Arithmetic tests
  #-------------------------------------------------------------

  # predsumu.hs rd, rs1, rs2
  # Computes reduction sum of unsigned halfwords from rs1, adds to rs2

  # Test case 1: Simple reduction sum
  # rs1 = 0x0001000200030004 (halfwords: 1,2,3,4)
  # sum = 1+2+3+4 = 10 = 0xa
  # rs2 = 0, result = 0xa
  TEST_RR_OP( 2, predsumu.hs, 0x000000000000000a, 0x0001000200030004, 0x0000000000000000 );

  # Test case 2: Zero sum
  TEST_RR_OP( 3, predsumu.hs, 0x0000000000000000, 0x0000000000000000, 0x0000000000000000 );

  # Test case 3: With base value in rs2
  # sum of halfwords = 10, rs2 = 0x10, result = 0x1a
  TEST_RR_OP( 4, predsumu.hs, 0x000000000000001a, 0x0001000200030004, 0x0000000000000010 );

  # Test case 4: Max unsigned halfwords
  # rs1 = 0xffffffffffffffff (all 65535 unsigned halfwords)
  # sum = 65535 * 4 = 262140 = 0x3fffc
  TEST_RR_OP( 5, predsumu.hs, 0x000000000003fffc, 0xffffffffffffffff, 0x0000000000000000 );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END

