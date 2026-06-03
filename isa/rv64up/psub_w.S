# See LICENSE for license details.

#*****************************************************************************
# psub_w.S
#-----------------------------------------------------------------------------
#
# Test psub.w instruction (packed word subtract, RV64 only).
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV64U
RVTEST_CODE_BEGIN

  #-------------------------------------------------------------
  # Arithmetic tests
  #-------------------------------------------------------------

  # psub.w rd, rs1, rs2
  # Performs packed word subtraction: rd[i] = rs1[i] - rs2[i]
  # Two 32-bit words in a 64-bit register

  # Test case 1: Simple subtraction (5-2=3, 3-1=2)
  TEST_RR_OP( 2, psub.w, 0x0000000300000002, 0x0000000500000003, 0x0000000200000001 );

  # Test case 2: Zero - Zero = Zero
  TEST_RR_OP( 3, psub.w, 0x0000000000000000, 0x0000000000000000, 0x0000000000000000 );

  # Test case 3: Underflow within word (wraps around)
  # 0x00000000 - 0x00000001 = 0xFFFFFFFF (with wrap)
  TEST_RR_OP( 4, psub.w, 0xffffffffffffffff, 0x0000000000000000, 0x0000000100000001 );

  # Test case 4: Large values
  TEST_RR_OP( 5, psub.w, 0x0000000000000000, 0x8000000080000000, 0x8000000080000000 );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END

