# See LICENSE for license details.

#*****************************************************************************
# padd_h.S
#-----------------------------------------------------------------------------
#
# Test padd.h instruction (packed halfword add).
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV64U
RVTEST_CODE_BEGIN

  #-------------------------------------------------------------
  # Arithmetic tests
  #-------------------------------------------------------------

  # padd.h rd, rs1, rs2
  # Performs packed halfword addition: rd[i] = rs1[i] + rs2[i] for each halfword

  # Test case 1: Simple addition
  # rs1 = 0x0001000200030004, rs2 = 0x0001000100010001
  # Expected: 0x0002000300040005
  TEST_RR_OP( 2, padd.h, 0x0002000300040005, 0x0001000200030004, 0x0001000100010001 );

  # Test case 2: Zero + Zero = Zero
  TEST_RR_OP( 3, padd.h, 0x0000000000000000, 0x0000000000000000, 0x0000000000000000 );

  # Test case 3: Overflow within halfword (wraps around)
  # 0xFFFF + 0x0001 = 0x0000 (with wrap)
  TEST_RR_OP( 4, padd.h, 0x0000000000000000, 0xffffffffffffffff, 0x0001000100010001 );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END

