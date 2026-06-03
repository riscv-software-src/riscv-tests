# See LICENSE for license details.

#*****************************************************************************
# padd_hs.S
#-----------------------------------------------------------------------------
#
# Test padd.hs instruction (packed halfword add with scalar second operand).
# Each halfword of rd = rs1_h_i + rs2[15:0]; addition wraps modulo 2^16 (no saturation).
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV64U
RVTEST_CODE_BEGIN

  #-------------------------------------------------------------
  # Arithmetic tests
  #-------------------------------------------------------------

  # padd.hs rd, rs1, rs2
  # Each halfword of rd = h_i(rs1) + rs2[15:0], wrap mod 2^16.

  # Test case 1: Simple add of broadcast scalar 0x0001
  TEST_RR_OP( 2, padd.hs, 0x0002000300040005, 0x0001000200030004, 0x0001000100010001 );

  # Test case 2: Zero + Zero = Zero
  TEST_RR_OP( 3, padd.hs, 0x0000000000000000, 0x0000000000000000, 0x0000000000000000 );

  # Test case 3: Modular wrap on signed overflow (0x7000 + 0x7000 = 0xE000 per halfword)
  TEST_RR_OP( 4, padd.hs, 0xe000e000e000e000, 0x7000700070007000, 0x7000700070007000 );

  # Test case 4: Only rs2[15:0] is used; higher halfwords of rs2 are ignored
  TEST_RR_OP( 5, padd.hs, 0x0002000300040005, 0x0001000200030004, 0xdeadbeefcafe0001 );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END

