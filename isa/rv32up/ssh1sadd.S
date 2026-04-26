# See LICENSE for license details.

#*****************************************************************************
# ssh1sadd.S
#-----------------------------------------------------------------------------
#
# Test ssh1sadd instruction (signed shift-1-and-saturating-add).
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV32U
RVTEST_CODE_BEGIN

  #-------------------------------------------------------------
  # Arithmetic tests
  #-------------------------------------------------------------

  # ssh1sadd rd, rs1, rs2 = sat((rs1 << 1) + rs2) (signed)

  # Test case 1: Simple shift and add (2 << 1) + 1 = 5 (no saturation)
  TEST_RR_OP( 2, ssh1sadd, 0x00000005, 0x00000002, 0x00000001 );

  # Test case 2: Zero operations
  TEST_RR_OP( 3, ssh1sadd, 0x00000000, 0x00000000, 0x00000000 );

  # Test case 3: Saturation case (0x60000000 << 1) + 0x60000000 = overflow, saturates to 0x7FFFFFFF
  TEST_RR_OP( 4, ssh1sadd, 0x7fffffff, 0x60000000, 0x60000000 );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END

