# See LICENSE for license details.

#*****************************************************************************
# pmseq_w.S
#-----------------------------------------------------------------------------
#
# Test pmseq.w instruction (packed mask set equal word, RV64 only).
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV64U
RVTEST_CODE_BEGIN

  #-------------------------------------------------------------
  # Arithmetic tests
  #-------------------------------------------------------------

  # pmseq.w rd, rs1, rs2
  # Sets mask: rd[i] = 0xffffffff if rs1[i] == rs2[i], else 0x00000000 for each word

  # Test case 1: All equal - all masks set
  TEST_RR_OP( 2, pmseq.w, 0xffffffffffffffff, 0x0000000500000005, 0x0000000500000005 );

  # Test case 2: All different - no masks set
  TEST_RR_OP( 3, pmseq.w, 0x0000000000000000, 0x0000000500000005, 0x0000000300000003 );

  # Test case 3: Mixed equal and different
  # rs1 = 0x0000000100000002, rs2 = 0x0000000100000003
  # Words: (1==1), (2!=3)
  TEST_RR_OP( 4, pmseq.w, 0xffffffff00000000, 0x0000000100000002, 0x0000000100000003 );

  # Test case 4: Zero comparison
  TEST_RR_OP( 5, pmseq.w, 0xffffffffffffffff, 0x0000000000000000, 0x0000000000000000 );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END

