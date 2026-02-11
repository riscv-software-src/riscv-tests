# See LICENSE for license details.

#*****************************************************************************
# paadd_h.S
#-----------------------------------------------------------------------------
#
# Test paadd.h instruction (packed halfword averaging add, signed).
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV64U
RVTEST_CODE_BEGIN

  #-------------------------------------------------------------
  # Arithmetic tests
  #-------------------------------------------------------------

  # paadd.h rd, rs1, rs2
  # Performs packed signed averaging add: rd[i] = (rs1[i] + rs2[i]) >> 1

  # Test case 1: Simple averaging (4 + 2) / 2 = 3
  TEST_RR_OP( 2, paadd.h, 0x0003000300030003, 0x0004000400040004, 0x0002000200020002 );

  # Test case 2: Zero + Zero = Zero
  TEST_RR_OP( 3, paadd.h, 0x0000000000000000, 0x0000000000000000, 0x0000000000000000 );

  # Test case 3: Averaging with odd sum (5 + 4) / 2 = 4 (truncated)
  TEST_RR_OP( 4, paadd.h, 0x0004000400040004, 0x0005000500050005, 0x0004000400040004 );

  # Test case 4: Negative odd sum — floor rounding: (-1 + 0) >> 1 = floor(-0.5) = -1 = 0xFFFF
  # Truncation toward 0 would give 0x0000; floor gives 0xFFFF.
  TEST_RR_OP( 5, paadd.h, 0xffffffffffffffff, 0xffffffffffffffff, 0x0000000000000000 );

  # Test case 5: Negative odd sum: (-3 + 0) >> 1 = floor(-1.5) = -2 = 0xFFFE per halfword
  # Truncation toward 0 would give 0xFFFF; floor gives 0xFFFE.
  TEST_RR_OP( 6, paadd.h, 0xfffefffefffefffe, 0xfffdfffdfffdfffd, 0x0000000000000000 );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END

