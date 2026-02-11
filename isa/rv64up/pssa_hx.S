# See LICENSE for license details.

#*****************************************************************************
# pssa_hx.S
#-----------------------------------------------------------------------------
#
# Test pssa.hx instruction (packed cross saturating sub-add halfword).
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV64U
RVTEST_CODE_BEGIN

  #-------------------------------------------------------------
  # Arithmetic tests
  #-------------------------------------------------------------

  # pssa.hx rd, rs1, rs2
  # Performs packed cross saturating sub-add on halfwords:
  # rd[even] = SAT(rs1[even] - rs2[odd])
  # rd[odd]  = SAT(rs1[odd] + rs2[even])

  # Test case 1: Simple cross saturating sub-add (no saturation)
  # rs1 = 0x0004000800040008, rs2 = 0x0002000400020004
  # even: 0x0008 - 0x0002 = 0x0006, 0x0004 - 0x0004 = 0x0000
  # odd:  0x0004 + 0x0004 = 0x0008, 0x0008 + 0x0002 = 0x000a
  # Expected: 0x000a000000080006
  TEST_RR_OP( 2, pssa.hx, 0x000a000000080006, 0x0004000800040008, 0x0002000400020004 );

  # Test case 2: Zero - Zero = Zero, Zero + Zero = Zero
  TEST_RR_OP( 3, pssa.hx, 0x0000000000000000, 0x0000000000000000, 0x0000000000000000 );

  # Test case 3: Same values in rs1 and rs2
  # rs1 = 0x0004000400040004, rs2 = 0x0002000200020002
  # even: 0x0004 - 0x0002 = 0x0002
  # odd:  0x0004 + 0x0002 = 0x0006
  # Expected: 0x0006000200060002
  TEST_RR_OP( 4, pssa.hx, 0x0006000200060002, 0x0004000400040004, 0x0002000200020002 );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END

