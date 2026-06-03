# See LICENSE for license details.

#*****************************************************************************
# pmsltu_w.S
#-----------------------------------------------------------------------------
#
# Test pmsltu.w instruction (packed mask set less than word unsigned, RV64 only).
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV64U
RVTEST_CODE_BEGIN

  #-------------------------------------------------------------
  # Arithmetic tests
  #-------------------------------------------------------------

  # pmsltu.w rd, rs1, rs2
  # Sets mask: rd[i] = 0xffffffff if rs1[i] < rs2[i] (unsigned), else 0x00000000 for each word

  # Test case 1: rs1 < rs2 - mask set
  TEST_RR_OP( 2, pmsltu.w, 0xffffffffffffffff, 0x0000000300000003, 0x0000000500000005 );

  # Test case 2: rs1 > rs2 - no mask
  TEST_RR_OP( 3, pmsltu.w, 0x0000000000000000, 0x0000000500000005, 0x0000000300000003 );

  # Test case 3: Equal values - no mask
  TEST_RR_OP( 4, pmsltu.w, 0x0000000000000000, 0x0000000400000004, 0x0000000400000004 );

  # Test case 4: Unsigned comparison (1 < 0xffffffff)
  TEST_RR_OP( 5, pmsltu.w, 0xffffffffffffffff, 0x0000000100000001, 0xffffffffffffffff );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END

