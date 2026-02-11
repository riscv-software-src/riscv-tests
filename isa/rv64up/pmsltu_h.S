# See LICENSE for license details.

#*****************************************************************************
# pmsltu_h.S
#-----------------------------------------------------------------------------
#
# Test pmsltu.h instruction (packed mask set less than halfword unsigned).
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV64U
RVTEST_CODE_BEGIN

  #-------------------------------------------------------------
  # Arithmetic tests
  #-------------------------------------------------------------

  # pmsltu.h rd, rs1, rs2
  # Sets mask: rd[i] = 0xffff if rs1[i] < rs2[i] (unsigned), else 0x0000 for each halfword

  # Test case 1: rs1 < rs2 - all masks set (3 < 5)
  TEST_RR_OP( 2, pmsltu.h, 0xffffffffffffffff, 0x0003000300030003, 0x0005000500050005 );

  # Test case 2: rs1 > rs2 - no masks set (5 > 3)
  TEST_RR_OP( 3, pmsltu.h, 0x0000000000000000, 0x0005000500050005, 0x0003000300030003 );

  # Test case 3: rs1 == rs2 - no masks set
  TEST_RR_OP( 4, pmsltu.h, 0x0000000000000000, 0x0004000400040004, 0x0004000400040004 );

  # Test case 4: Unsigned comparison (0x0001 < 0xffff = true, since 1 < 65535)
  TEST_RR_OP( 5, pmsltu.h, 0xffffffffffffffff, 0x0001000100010001, 0xffffffffffffffff );

  # Test case 5: Unsigned comparison (0xffff < 0x0001 = false, since 65535 > 1)
  TEST_RR_OP( 6, pmsltu.h, 0x0000000000000000, 0xffffffffffffffff, 0x0001000100010001 );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END


