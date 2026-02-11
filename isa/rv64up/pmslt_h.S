# See LICENSE for license details.

#*****************************************************************************
# pmslt_h.S
#-----------------------------------------------------------------------------
#
# Test pmslt.h instruction (packed mask set less than halfword signed).
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV64U
RVTEST_CODE_BEGIN

  #-------------------------------------------------------------
  # Arithmetic tests
  #-------------------------------------------------------------

  # pmslt.h rd, rs1, rs2
  # Sets mask: rd[i] = 0xffff if rs1[i] < rs2[i] (signed), else 0x0000 for each halfword

  # Test case 1: rs1 < rs2 - all masks set (3 < 5)
  TEST_RR_OP( 2, pmslt.h, 0xffffffffffffffff, 0x0003000300030003, 0x0005000500050005 );

  # Test case 2: rs1 > rs2 - no masks set (5 > 3)
  TEST_RR_OP( 3, pmslt.h, 0x0000000000000000, 0x0005000500050005, 0x0003000300030003 );

  # Test case 3: rs1 == rs2 - no masks set
  TEST_RR_OP( 4, pmslt.h, 0x0000000000000000, 0x0004000400040004, 0x0004000400040004 );

  # Test case 4: Signed comparison (-1 < 1 = true)
  # 0xffff = -1, 0x0001 = 1
  TEST_RR_OP( 5, pmslt.h, 0xffffffffffffffff, 0xffffffffffffffff, 0x0001000100010001 );

  # Test case 5: Signed comparison (1 < -1 = false)
  TEST_RR_OP( 6, pmslt.h, 0x0000000000000000, 0x0001000100010001, 0xffffffffffffffff );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END


