# See LICENSE for license details.

#*****************************************************************************
# paadd_w.S
#-----------------------------------------------------------------------------
#
# Test paadd.w instruction (packed word averaging add, signed, RV64 only).
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV64U
RVTEST_CODE_BEGIN

  #-------------------------------------------------------------
  # Arithmetic tests
  #-------------------------------------------------------------

  # paadd.w rd, rs1, rs2
  # Performs packed signed averaging add: rd[i] = (rs1[i] + rs2[i]) >> 1
  # Two 32-bit words in a 64-bit register

  # Test case 1: Simple averaging (4 + 2) / 2 = 3
  TEST_RR_OP( 2, paadd.w, 0x0000000300000003, 0x0000000400000004, 0x0000000200000002 );

  # Test case 2: Zero + Zero = Zero
  TEST_RR_OP( 3, paadd.w, 0x0000000000000000, 0x0000000000000000, 0x0000000000000000 );

  # Test case 3: Averaging with odd sum (5 + 4) / 2 = 4 (truncated)
  TEST_RR_OP( 4, paadd.w, 0x0000000400000004, 0x0000000500000005, 0x0000000400000004 );

  # Test case 4: Large positive values
  TEST_RR_OP( 5, paadd.w, 0x4000000040000000, 0x4000000040000000, 0x4000000040000000 );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END

