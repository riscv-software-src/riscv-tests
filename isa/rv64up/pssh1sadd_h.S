# See LICENSE for license details.

#*****************************************************************************
# pssh1sadd_h.S
#-----------------------------------------------------------------------------
#
# Test pssh1sadd.h instruction (packed halfword signed shift-1-and-saturating-add).
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV64U
RVTEST_CODE_BEGIN

  #-------------------------------------------------------------
  # Arithmetic tests
  #-------------------------------------------------------------

  # pssh1sadd.h rd, rs1, rs2
  # Performs packed signed shift-1-and-saturating-add: rd[i] = sat((rs1[i] << 1) + rs2[i])

  # Test case 1: Simple shift and add (2 << 1) + 1 = 5 (no saturation)
  TEST_RR_OP( 2, pssh1sadd.h, 0x0005000500050005, 0x0002000200020002, 0x0001000100010001 );

  # Test case 2: Zero operations
  TEST_RR_OP( 3, pssh1sadd.h, 0x0000000000000000, 0x0000000000000000, 0x0000000000000000 );

  # Test case 3: Saturation case (0x6000 << 1) + 0x6000 = overflow, saturates to 0x7FFF
  TEST_RR_OP( 4, pssh1sadd.h, 0x7fff7fff7fff7fff, 0x6000600060006000, 0x6000600060006000 );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END

