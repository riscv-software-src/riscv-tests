# See LICENSE for license details.

#*****************************************************************************
# pmseq_h.S
#-----------------------------------------------------------------------------
#
# Test pmseq.h instruction (packed mask set equal halfword).
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV64U
RVTEST_CODE_BEGIN

  #-------------------------------------------------------------
  # Arithmetic tests
  #-------------------------------------------------------------

  # pmseq.h rd, rs1, rs2
  # Sets mask: rd[i] = 0xffff if rs1[i] == rs2[i], else 0x0000 for each halfword

  # Test case 1: All equal - all masks set
  TEST_RR_OP( 2, pmseq.h, 0xffffffffffffffff, 0x0005000500050005, 0x0005000500050005 );

  # Test case 2: All different - no masks set
  TEST_RR_OP( 3, pmseq.h, 0x0000000000000000, 0x0005000500050005, 0x0003000300030003 );

  # Test case 3: Mixed equal and different
  # rs1 = 0x0001000200030004, rs2 = 0x0001000300030005
  # Halfwords: (0001==0001), (0002!=0003), (0003==0003), (0004!=0005)
  TEST_RR_OP( 4, pmseq.h, 0xffff0000ffff0000, 0x0001000200030004, 0x0001000300030005 );

  # Test case 4: Zero comparison
  TEST_RR_OP( 5, pmseq.h, 0xffffffffffffffff, 0x0000000000000000, 0x0000000000000000 );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END


