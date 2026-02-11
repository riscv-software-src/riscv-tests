# See LICENSE for license details.

#*****************************************************************************
# psas_hx.S
#-----------------------------------------------------------------------------
#
# Test psas.hx instruction (packed cross saturating add-sub halfword).
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV64U
RVTEST_CODE_BEGIN

  #-------------------------------------------------------------
  # Arithmetic tests
  #-------------------------------------------------------------

  # psas.hx rd, rs1, rs2
  # Performs packed cross saturating add-sub on halfwords:
  # rd[even] = SAT(rs1[even] + rs2[odd])
  # rd[odd]  = SAT(rs1[odd] - rs2[even])

  # Test case 1: Simple cross saturating add-sub (no saturation)
  # rs1 = 0x0004000800040008, rs2 = 0x0002000400020004
  # even: 0x0008 + 0x0002 = 0x000a, 0x0004 + 0x0004 = 0x0008
  # odd:  0x0004 - 0x0004 = 0x0000, 0x0008 - 0x0002 = 0x0006
  # Expected: 0x000600080000000a
  TEST_RR_OP( 2, psas.hx, 0x000600080000000a, 0x0004000800040008, 0x0002000400020004 );

  # Test case 2: Zero + Zero = Zero
  TEST_RR_OP( 3, psas.hx, 0x0000000000000000, 0x0000000000000000, 0x0000000000000000 );

  # Test case 3: Same values in rs1 and rs2
  # rs1 = 0x0004000400040004, rs2 = 0x0002000200020002
  # even: 0x0004 + 0x0002 = 0x0006
  # odd:  0x0004 - 0x0002 = 0x0002
  # Expected: 0x0002000600020006
  TEST_RR_OP( 4, psas.hx, 0x0002000600020006, 0x0004000400040004, 0x0002000200020002 );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END

