# See LICENSE for license details.

#*****************************************************************************
# pasubu_w.S
#-----------------------------------------------------------------------------
#
# Test pasubu.w instruction (packed word averaging sub, unsigned, RV64 only).
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV64U
RVTEST_CODE_BEGIN

  #-------------------------------------------------------------
  # Arithmetic tests
  #-------------------------------------------------------------

  # pasubu.w rd, rs1, rs2
  # Performs packed unsigned averaging sub: rd[i] = (rs1[i] - rs2[i]) >> 1
  # Two 32-bit words in a 64-bit register

  # Test case 1: Simple averaging (4 - 2) / 2 = 1
  TEST_RR_OP( 2, pasubu.w, 0x0000000100000001, 0x0000000400000004, 0x0000000200000002 );

  # Test case 2: Zero - Zero = Zero
  TEST_RR_OP( 3, pasubu.w, 0x0000000000000000, 0x0000000000000000, 0x0000000000000000 );

  # Test case 3: Same values = 0
  TEST_RR_OP( 4, pasubu.w, 0x0000000000000000, 0x0000000500000005, 0x0000000500000005 );

  # Test case 4: (8 - 2) / 2 = 3
  TEST_RR_OP( 5, pasubu.w, 0x0000000300000003, 0x0000000800000008, 0x0000000200000002 );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END

