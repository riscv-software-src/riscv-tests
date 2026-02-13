# See LICENSE for license details.

#*****************************************************************************
# psh1add_w.S
#-----------------------------------------------------------------------------
#
# Test psh1add.w instruction (packed word shift-1-and-add, RV64 only).
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV64U
RVTEST_CODE_BEGIN

  # psh1add.w rd, rs1, rs2
  # Performs packed shift-1-and-add: rd[i] = (rs1[i] << 1) + rs2[i]

  # Test case 1: Simple shift and add (2 << 1) + 1 = 5
  TEST_RR_OP( 2, psh1add.w, 0x0000000500000005, 0x0000000200000002, 0x0000000100000001 );

  # Test case 2: Zero operations
  TEST_RR_OP( 3, psh1add.w, 0x0000000000000000, 0x0000000000000000, 0x0000000000000000 );

  # Test case 3: (3 << 1) + 2 = 8
  TEST_RR_OP( 4, psh1add.w, 0x0000000800000008, 0x0000000300000003, 0x0000000200000002 );

  # Test case 4: Larger values (0x10000000 << 1) + 0x1 = 0x20000001
  TEST_RR_OP( 5, psh1add.w, 0x2000000120000001, 0x1000000010000000, 0x0000000100000001 );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN
  TEST_DATA
RVTEST_DATA_END

