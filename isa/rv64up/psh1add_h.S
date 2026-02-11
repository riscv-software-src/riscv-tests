# See LICENSE for license details.

#*****************************************************************************
# psh1add_h.S
#-----------------------------------------------------------------------------
#
# Test psh1add.h instruction (packed halfword shift-1-and-add).
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV64U
RVTEST_CODE_BEGIN

  #-------------------------------------------------------------
  # Arithmetic tests
  #-------------------------------------------------------------

  # psh1add.h rd, rs1, rs2
  # Performs packed shift-1-and-add: rd[i] = (rs1[i] << 1) + rs2[i]

  # Test case 1: Simple shift and add (2 << 1) + 1 = 5
  TEST_RR_OP( 2, psh1add.h, 0x0005000500050005, 0x0002000200020002, 0x0001000100010001 );

  # Test case 2: Zero operations
  TEST_RR_OP( 3, psh1add.h, 0x0000000000000000, 0x0000000000000000, 0x0000000000000000 );

  # Test case 3: (3 << 1) + 2 = 8
  TEST_RR_OP( 4, psh1add.h, 0x0008000800080008, 0x0003000300030003, 0x0002000200020002 );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END

