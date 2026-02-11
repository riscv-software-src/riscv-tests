# See LICENSE for license details.

#*****************************************************************************
# mseq.S
#-----------------------------------------------------------------------------
#
# Test mseq instruction (set if equal, RV32 only).
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV32U
RVTEST_CODE_BEGIN

  #-------------------------------------------------------------
  # Arithmetic tests
  #-------------------------------------------------------------

  # mseq rd, rs1, rs2
  # rd = (rs1 == rs2) ? all 1s : 0

  # Test case 1: Equal values - return all 1s
  TEST_RR_OP( 2, mseq, 0xffffffff, 0x00000005, 0x00000005 );

  # Test case 2: Different values - return 0
  TEST_RR_OP( 3, mseq, 0x00000000, 0x00000005, 0x00000003 );

  # Test case 3: Zero comparison - equal
  TEST_RR_OP( 4, mseq, 0xffffffff, 0x00000000, 0x00000000 );

  # Test case 4: Negative values equal
  TEST_RR_OP( 5, mseq, 0xffffffff, 0xffffffff, 0xffffffff );

  # Test case 5: Positive and negative - not equal
  TEST_RR_OP( 6, mseq, 0x00000000, 0x00000001, 0xffffffff );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END


