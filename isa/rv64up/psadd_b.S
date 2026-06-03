# See LICENSE for license details.

#*****************************************************************************
# psadd_b.S
#-----------------------------------------------------------------------------
#
# Test psadd.b instruction (packed byte saturating add, signed).
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV64U
RVTEST_CODE_BEGIN

  #-------------------------------------------------------------
  # Arithmetic tests
  #-------------------------------------------------------------

  # psadd.b rd, rs1, rs2
  # Performs packed signed saturating add

  # Test case 1: Simple addition (no saturation)
  TEST_RR_OP_VXSAT( 2, psadd.b, 0x0203040506070809, 0x0102030405060708, 0x0101010101010101, 0 );

  # Test case 2: Zero + Zero = Zero
  TEST_RR_OP_VXSAT( 3, psadd.b, 0x0000000000000000, 0x0000000000000000, 0x0000000000000000, 0 );

  # Test case 3: Positive saturation (0x70 + 0x70 saturates to 0x7F)
  TEST_RR_OP_VXSAT( 4, psadd.b, 0x7f7f7f7f7f7f7f7f, 0x7070707070707070, 0x7070707070707070, 1 );

  # Test case 4: Negative saturation — (-128) + (-1) = -129 < INT8_MIN, saturates to -128 = 0x80
  TEST_RR_OP_VXSAT( 5, psadd.b, 0x8080808080808080, 0x8080808080808080, 0xffffffffffffffff, 1 );

  # Test case 5: Mixed — positive + negative, no saturation: 0x70 + 0x90 = 0x00 (as signed: 112 + (-112) = 0)
  TEST_RR_OP_VXSAT( 6, psadd.b, 0x0000000000000000, 0x7070707070707070, 0x9090909090909090, 0 );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END

