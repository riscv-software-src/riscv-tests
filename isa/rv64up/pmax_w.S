# See LICENSE for license details.

#*****************************************************************************
# pmax_w.S
#-----------------------------------------------------------------------------
#
# Test pmax.w instruction (packed max word signed, RV64 only).
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV64U
RVTEST_CODE_BEGIN

  #-------------------------------------------------------------
  # Arithmetic tests
  #-------------------------------------------------------------

  # pmax.w rd, rs1, rs2
  # Performs packed signed max: rd[i] = max(rs1[i], rs2[i]) for each 32-bit word

  # Test case 1: Simple max (5 vs 3 = 5)
  TEST_RR_OP( 2, pmax.w, 0x0000000500000005, 0x0000000500000005, 0x0000000300000003 );

  # Test case 2: Reverse order (3 vs 5 = 5)
  TEST_RR_OP( 3, pmax.w, 0x0000000500000005, 0x0000000300000003, 0x0000000500000005 );

  # Test case 3: Equal values
  TEST_RR_OP( 4, pmax.w, 0x0000000400000004, 0x0000000400000004, 0x0000000400000004 );

  # Test case 4: Mixed positive and negative (signed: -1 vs 1 = 1)
  # 0xffffffff = -1, 0x00000001 = 1
  TEST_RR_OP( 5, pmax.w, 0x0000000100000001, 0xffffffffffffffff, 0x0000000100000001 );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END

