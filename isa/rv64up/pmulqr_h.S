# See LICENSE for license details.

#*****************************************************************************
# pmulqr_h.S
#-----------------------------------------------------------------------------
#
# Test pmulqr.h instruction (packed Q-format signed multiply with rounding).
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV64U
RVTEST_CODE_BEGIN

  #-------------------------------------------------------------
  # Arithmetic tests
  #-------------------------------------------------------------

  # pmulqr.h rd, rs1, rs2 = packed (((rs1 * rs2) >> 14) + 1) >> 1 (with saturation)

  # Test case 1: Simple Q-format multiply with rounding
  TEST_RR_OP( 2, pmulqr.h, 0x0000000000000000, 0x0002000200020002, 0x0003000300030003 );

  # Test case 2: Zero multiply
  TEST_RR_OP( 3, pmulqr.h, 0x0000000000000000, 0x0000000000000000, 0x0005000500050005 );

  # Test case 3: Large positive values
  TEST_RR_OP( 4, pmulqr.h, 0x4000400040004000, 0x7fff7fff7fff7fff, 0x7fff7fff7fff7fff );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END

