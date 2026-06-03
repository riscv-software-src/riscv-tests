# See LICENSE for license details.

#*****************************************************************************
# pssub_b.S
#-----------------------------------------------------------------------------
#
# Test pssub.b instruction (packed byte saturating subtract, signed).
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV64U
RVTEST_CODE_BEGIN

  #-------------------------------------------------------------
  # Arithmetic tests
  #-------------------------------------------------------------

  # pssub.b rd, rs1, rs2
  # Performs packed signed saturating subtract

  # Test case 1: Simple subtraction (no saturation)
  TEST_RR_OP_VXSAT( 2, pssub.b, 0x0102030405060708, 0x0203040506070809, 0x0101010101010101, 0  );

  # Test case 2: Zero - Zero = Zero
  TEST_RR_OP_VXSAT( 3, pssub.b, 0x0000000000000000, 0x0000000000000000, 0x0000000000000000, 0  );

  # Test case 3: Negative saturation (0x80 - 0x70 saturates to 0x80)
  TEST_RR_OP_VXSAT( 4, pssub.b, 0x8080808080808080, 0x8080808080808080, 0x7070707070707070, 1  );

  # Test case 4: Positive saturation — 127 - (-1) = 128 > INT8_MAX, saturates to 127 = 0x7F
  TEST_RR_OP_VXSAT( 5, pssub.b, 0x7f7f7f7f7f7f7f7f, 0x7f7f7f7f7f7f7f7f, 0xffffffffffffffff, 1  );

  # Test case 5: Negative result — 0 - 1 = -1 = 0xFF (no saturation)
  TEST_RR_OP_VXSAT( 6, pssub.b, 0xffffffffffffffff, 0x0000000000000000, 0x0101010101010101, 0  );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END

