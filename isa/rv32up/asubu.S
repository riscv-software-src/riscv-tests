# See LICENSE for license details.

#*****************************************************************************
# asubu.S
#-----------------------------------------------------------------------------
#
# Test asubu instruction (unsigned averaging subtract).
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV32U
RVTEST_CODE_BEGIN

  #-------------------------------------------------------------
  # Arithmetic tests
  #-------------------------------------------------------------

  # asubu rd, rs1, rs2 = (rs1 - rs2) >> 1 (unsigned)

  # Test case 1: Simple averaging (6 - 2) / 2 = 2
  TEST_RR_OP( 2, asubu, 0x00000002, 0x00000006, 0x00000002 );

  # Test case 2: Zero - Zero = Zero
  TEST_RR_OP( 3, asubu, 0x00000000, 0x00000000, 0x00000000 );

  # Test case 3: Same values (0x80000000 - 0x80000000) / 2 = 0
  TEST_RR_OP( 4, asubu, 0x00000000, 0x80000000, 0x80000000 );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END

