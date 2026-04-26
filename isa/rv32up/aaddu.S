# See LICENSE for license details.

#*****************************************************************************
# aaddu.S
#-----------------------------------------------------------------------------
#
# Test aaddu instruction (unsigned averaging add).
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV32U
RVTEST_CODE_BEGIN

  #-------------------------------------------------------------
  # Arithmetic tests
  #-------------------------------------------------------------

  # aaddu rd, rs1, rs2 = (rs1 + rs2) >> 1 (unsigned)

  # Test case 1: Simple averaging (4 + 2) / 2 = 3
  TEST_RR_OP( 2, aaddu, 0x00000003, 0x00000004, 0x00000002 );

  # Test case 2: Zero + Zero = Zero
  TEST_RR_OP( 3, aaddu, 0x00000000, 0x00000000, 0x00000000 );

  # Test case 3: Large unsigned values (0x80000000 + 0x80000000) / 2 = 0x80000000
  TEST_RR_OP( 4, aaddu, 0x80000000, 0x80000000, 0x80000000 );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END

