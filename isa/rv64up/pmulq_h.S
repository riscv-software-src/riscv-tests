# See LICENSE for license details.

#*****************************************************************************
# pmulq_h.S
#-----------------------------------------------------------------------------
#
# Test pmulq.h instruction (packed Q-format signed multiply, 16-bit).
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV64U
RVTEST_CODE_BEGIN

  #-------------------------------------------------------------
  # Arithmetic tests
  #-------------------------------------------------------------

  # pmulq.h rd, rs1, rs2 = packed (rs1 * rs2) >> 15 (with saturation)

  # Test case 1: Simple Q-format multiply
  TEST_RR_OP( 2, pmulq.h, 0x0000000000000000, 0x0002000200020002, 0x0003000300030003 );

  # Test case 2: Zero multiply
  TEST_RR_OP( 3, pmulq.h, 0x0000000000000000, 0x0000000000000000, 0x0005000500050005 );

  # Test case 3: Large positive values
  TEST_RR_OP( 4, pmulq.h, 0x3fff3fff3fff3fff, 0x7fff7fff7fff7fff, 0x7fff7fff7fff7fff );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END

