# See LICENSE for license details.

#*****************************************************************************
# sadd.S
#-----------------------------------------------------------------------------
#
# Test sadd instruction (signed saturating add).
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV32U
RVTEST_CODE_BEGIN

  #-------------------------------------------------------------
  # Arithmetic tests
  #-------------------------------------------------------------

  # sadd rd, rs1, rs2 = sat(rs1 + rs2) (signed)

  # Test case 1: Simple addition (no saturation)
  TEST_RR_OP( 2, sadd, 0x00000006, 0x00000004, 0x00000002 );

  # Test case 2: Zero + Zero = Zero
  TEST_RR_OP( 3, sadd, 0x00000000, 0x00000000, 0x00000000 );

  # Test case 3: Positive saturation (0x70000000 + 0x70000000 saturates to 0x7FFFFFFF)
  TEST_RR_OP( 4, sadd, 0x7fffffff, 0x70000000, 0x70000000 );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END

