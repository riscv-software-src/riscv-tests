# See LICENSE for license details.

#*****************************************************************************
# predsum_hs.S
#-----------------------------------------------------------------------------
#
# Test predsum.hs instruction (packed reduction sum halfword signed).
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV64U
RVTEST_CODE_BEGIN

  #-------------------------------------------------------------
  # Arithmetic tests
  #-------------------------------------------------------------

  # predsum.hs rd, rs1, rs2
  # Computes reduction sum of signed halfwords from rs1, adds to rs2

  # Test case 1: Simple reduction sum
  # rs1 = 0x0001000200030004 (halfwords: 1,2,3,4)
  # sum = 1+2+3+4 = 10 = 0xa
  # rs2 = 0, result = 0xa
  TEST_RR_OP( 2, predsum.hs, 0x000000000000000a, 0x0001000200030004, 0x0000000000000000 );

  # Test case 2: Zero sum
  TEST_RR_OP( 3, predsum.hs, 0x0000000000000000, 0x0000000000000000, 0x0000000000000000 );

  # Test case 3: With base value in rs2
  # sum of halfwords = 10, rs2 = 0x10, result = 0x1a
  TEST_RR_OP( 4, predsum.hs, 0x000000000000001a, 0x0001000200030004, 0x0000000000000010 );

  # Test case 4: Negative halfwords (signed)
  # rs1 = 0xffffffffffffffff (all -1 signed halfwords)
  # sum = -1 * 4 = -4 = 0xfffffffffffffffc
  TEST_RR_OP( 5, predsum.hs, 0xfffffffffffffffc, 0xffffffffffffffff, 0x0000000000000000 );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END

