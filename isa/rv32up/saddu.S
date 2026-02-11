# See LICENSE for license details.

#*****************************************************************************
# saddu.S
#-----------------------------------------------------------------------------
#
# Test saddu instruction (unsigned saturating add).
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV32U
RVTEST_CODE_BEGIN

  #-------------------------------------------------------------
  # Arithmetic tests
  #-------------------------------------------------------------

  # saddu rd, rs1, rs2 = sat(rs1 + rs2) (unsigned)

  # Test case 1: Simple addition (no saturation)
  TEST_RR_OP( 2, saddu, 0x00000006, 0x00000004, 0x00000002 );

  # Test case 2: Zero + Zero = Zero
  TEST_RR_OP( 3, saddu, 0x00000000, 0x00000000, 0x00000000 );

  # Test case 3: Unsigned saturation (0xF0000000 + 0xF0000000 saturates to 0xFFFFFFFF)
  TEST_RR_OP( 4, saddu, 0xffffffff, 0xf0000000, 0xf0000000 );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END

