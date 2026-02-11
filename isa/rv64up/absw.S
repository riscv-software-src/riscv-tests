# See LICENSE for license details.

#*****************************************************************************
# absw.S
#-----------------------------------------------------------------------------
#
# Test absw instruction (absolute value word, RV64 only).
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV64U
RVTEST_CODE_BEGIN

  #-------------------------------------------------------------
  # Arithmetic tests
  #-------------------------------------------------------------

  # absw rd, rs1 - absolute value of low 32 bits, sign-extended to 64 bits

  # Test case 1: Negative value
  TEST_R_OP( 2, absw, 5, -5 );

  # Test case 2: Positive value (unchanged)
  TEST_R_OP( 3, absw, 5, 5 );

  # Test case 4: Zero
  TEST_R_OP( 4, absw, 0, 0 );

  # Test case 5: Large negative word value
  # -2147483647 (0x80000001) -> 2147483647 (0x7fffffff)
  TEST_R_OP( 5, absw, 0x7fffffff, 0x80000001 );

  # Test case 6: -1
  TEST_R_OP( 6, absw, 1, -1 );

  # Test case 7: Works on lower 32 bits only
  # 0xffffffff00000005 (upper bits ignored, low 32 bits = 5)
  TEST_R_OP( 7, absw, 5, 0xffffffff00000005 );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END


