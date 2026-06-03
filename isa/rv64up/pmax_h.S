# See LICENSE for license details.

#*****************************************************************************
# pmax_h.S
#-----------------------------------------------------------------------------
#
# Test pmax.h instruction (packed max halfword signed).
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV64U
RVTEST_CODE_BEGIN

  #-------------------------------------------------------------
  # Arithmetic tests
  #-------------------------------------------------------------

  # pmax.h rd, rs1, rs2
  # Performs packed signed max: rd[i] = max(rs1[i], rs2[i]) for each halfword

  # Test case 1: Simple max (0x0005 vs 0x0003 = 0x0005)
  TEST_RR_OP( 2, pmax.h, 0x0005000500050005, 0x0005000500050005, 0x0003000300030003 );

  # Test case 2: Reverse order (0x0003 vs 0x0005 = 0x0005)
  TEST_RR_OP( 3, pmax.h, 0x0005000500050005, 0x0003000300030003, 0x0005000500050005 );

  # Test case 3: Equal values
  TEST_RR_OP( 4, pmax.h, 0x0004000400040004, 0x0004000400040004, 0x0004000400040004 );

  # Test case 4: Mixed positive and negative (signed: -1 vs 1 = 1)
  # 0xffff = -1, 0x0001 = 1
  TEST_RR_OP( 5, pmax.h, 0x0001000100010001, 0xffffffffffffffff, 0x0001000100010001 );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END


