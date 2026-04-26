# See LICENSE for license details.

#*****************************************************************************
# pssub_w.S
#-----------------------------------------------------------------------------
#
# Test pssub.w instruction (packed word saturating subtract, signed, RV64 only).
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV64U
RVTEST_CODE_BEGIN

  # pssub.w rd, rs1, rs2
  # Performs packed signed saturating subtract for 32-bit words

  # Test case 1: Simple subtraction (no saturation)
  TEST_RR_OP( 2, pssub.w, 0x0000000100000001, 0x0000000300000003, 0x0000000200000002 );

  # Test case 2: Zero - Zero = Zero
  TEST_RR_OP( 3, pssub.w, 0x0000000000000000, 0x0000000000000000, 0x0000000000000000 );

  # Test case 3: Negative saturation (0x80000000 - 0x70000000 saturates to 0x80000000)
  TEST_RR_OP( 4, pssub.w, 0x8000000080000000, 0x8000000080000000, 0x7000000070000000 );

  # Test case 4: Positive saturation (0x70000000 - 0x90000000 saturates to 0x7FFFFFFF)
  TEST_RR_OP( 5, pssub.w, 0x7fffffff7fffffff, 0x7000000070000000, 0x9000000090000000 );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN
  TEST_DATA
RVTEST_DATA_END

