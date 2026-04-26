# See LICENSE for license details.

#*****************************************************************************
# pasa_hx.S
#-----------------------------------------------------------------------------
#
# Test pasa.hx instruction (packed cross averaging sub-add halfword).
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV64U
RVTEST_CODE_BEGIN

  #-------------------------------------------------------------
  # Arithmetic tests
  #-------------------------------------------------------------

  # pasa.hx rd, rs1, rs2
  # Performs packed cross averaging sub-add on halfwords:
  # rd[even] = (rs1[even] - rs2[odd]) >> 1
  # rd[odd]  = (rs1[odd] + rs2[even]) >> 1

  # Test case 1: Simple cross averaging sub-add
  # rs1 = 0x0004000800040008, rs2 = 0x0002000400020004
  # even: (0x0008 - 0x0002) >> 1 = 0x0003, (0x0004 - 0x0004) >> 1 = 0x0000
  # odd:  (0x0004 + 0x0004) >> 1 = 0x0004, (0x0008 + 0x0002) >> 1 = 0x0005
  # Expected: 0x0005000000040003
  TEST_RR_OP( 2, pasa.hx, 0x0005000000040003, 0x0004000800040008, 0x0002000400020004 );

  # Test case 2: Zero - Zero = Zero, Zero + Zero = Zero
  TEST_RR_OP( 3, pasa.hx, 0x0000000000000000, 0x0000000000000000, 0x0000000000000000 );

  # Test case 3: Same values in rs1 and rs2
  # rs1 = 0x0004000400040004, rs2 = 0x0002000200020002
  # even: (0x0004 - 0x0002) >> 1 = 0x0001
  # odd:  (0x0004 + 0x0002) >> 1 = 0x0003
  # Expected: 0x0003000100030001
  TEST_RR_OP( 4, pasa.hx, 0x0003000100030001, 0x0004000400040004, 0x0002000200020002 );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END

