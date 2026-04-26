# See LICENSE for license details.

#*****************************************************************************
# pminu_w.S
#-----------------------------------------------------------------------------
#
# Test pminu.w instruction (packed min word unsigned, RV64 only).
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV64U
RVTEST_CODE_BEGIN

  #-------------------------------------------------------------
  # Arithmetic tests
  #-------------------------------------------------------------

  # pminu.w rd, rs1, rs2
  # Performs packed unsigned min: rd[i] = min(rs1[i], rs2[i]) for each 32-bit word

  # Test case 1: Simple min (5 vs 3 = 3)
  TEST_RR_OP( 2, pminu.w, 0x0000000300000003, 0x0000000500000005, 0x0000000300000003 );

  # Test case 2: Reverse order (3 vs 5 = 3)
  TEST_RR_OP( 3, pminu.w, 0x0000000300000003, 0x0000000300000003, 0x0000000500000005 );

  # Test case 3: Equal values
  TEST_RR_OP( 4, pminu.w, 0x0000000400000004, 0x0000000400000004, 0x0000000400000004 );

  # Test case 4: Unsigned comparison (0xffffffff > 1, so min = 1)
  TEST_RR_OP( 5, pminu.w, 0x0000000100000001, 0xffffffffffffffff, 0x0000000100000001 );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END

