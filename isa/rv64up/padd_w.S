# See LICENSE for license details.

#*****************************************************************************
# padd_w.S
#-----------------------------------------------------------------------------
#
# Test padd.w instruction (packed word add, RV64 only).
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV64U
RVTEST_CODE_BEGIN

  #-------------------------------------------------------------
  # Arithmetic tests
  #-------------------------------------------------------------

  # padd.w rd, rs1, rs2
  # Performs packed word addition: rd[i] = rs1[i] + rs2[i]
  # Two 32-bit words in a 64-bit register

  # Test case 1: Simple addition
  TEST_RR_OP( 2, padd.w, 0x0000000300000005, 0x0000000100000002, 0x0000000200000003 );

  # Test case 2: Zero + Zero = Zero
  TEST_RR_OP( 3, padd.w, 0x0000000000000000, 0x0000000000000000, 0x0000000000000000 );

  # Test case 3: Overflow within word (wraps around)
  # 0xFFFFFFFF + 0x00000001 = 0x00000000 (with wrap)
  TEST_RR_OP( 4, padd.w, 0x0000000000000000, 0xffffffffffffffff, 0x0000000100000001 );

  # Test case 4: Large positive values
  TEST_RR_OP( 5, padd.w, 0x8000000080000000, 0x4000000040000000, 0x4000000040000000 );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END

