# See LICENSE for license details.

#*****************************************************************************
# pssubu_w.S
#-----------------------------------------------------------------------------
#
# Test pssubu.w instruction (packed word saturating subtract, unsigned, RV64 only).
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV64U
RVTEST_CODE_BEGIN

  # pssubu.w rd, rs1, rs2
  # Performs packed unsigned saturating subtract for 32-bit words

  # Test case 1: Simple subtraction (no saturation)
  TEST_RR_OP( 2, pssubu.w, 0x0000000100000001, 0x0000000300000003, 0x0000000200000002 );

  # Test case 2: Zero - Zero = Zero
  TEST_RR_OP( 3, pssubu.w, 0x0000000000000000, 0x0000000000000000, 0x0000000000000000 );

  # Test case 3: Unsigned saturation to zero (0x10000000 - 0x20000000 saturates to 0)
  TEST_RR_OP( 4, pssubu.w, 0x0000000000000000, 0x1000000010000000, 0x2000000020000000 );

  # Test case 4: No saturation with large values
  TEST_RR_OP( 5, pssubu.w, 0x4000000040000000, 0x8000000080000000, 0x4000000040000000 );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN
  TEST_DATA
RVTEST_DATA_END

