# See LICENSE for license details.

#*****************************************************************************
# aadd.S
#-----------------------------------------------------------------------------
#
# Test aadd instruction (signed averaging add).
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV32U
RVTEST_CODE_BEGIN

  #-------------------------------------------------------------
  # Arithmetic tests
  #-------------------------------------------------------------

  # aadd rd, rs1, rs2 = (rs1 + rs2) >> 1 (signed)

  # Test case 1: Simple averaging (4 + 2) / 2 = 3
  TEST_RR_OP( 2, aadd, 0x00000003, 0x00000004, 0x00000002 );

  # Test case 2: Zero + Zero = Zero
  TEST_RR_OP( 3, aadd, 0x00000000, 0x00000000, 0x00000000 );

  # Test case 3: Odd sum (5 + 4) / 2 = 4 (truncated)
  TEST_RR_OP( 4, aadd, 0x00000004, 0x00000005, 0x00000004 );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END

