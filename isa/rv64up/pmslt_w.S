# See LICENSE for license details.

#*****************************************************************************
# pmslt_w.S
#-----------------------------------------------------------------------------
#
# Test pmslt.w instruction (packed mask set less than word signed, RV64 only).
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV64U
RVTEST_CODE_BEGIN

  #-------------------------------------------------------------
  # Arithmetic tests
  #-------------------------------------------------------------

  # pmslt.w rd, rs1, rs2
  # Sets mask: rd[i] = 0xffffffff if rs1[i] < rs2[i] (signed), else 0x00000000 for each word

  # Test case 1: rs1 < rs2 - mask set
  TEST_RR_OP( 2, pmslt.w, 0xffffffffffffffff, 0x0000000300000003, 0x0000000500000005 );

  # Test case 2: rs1 > rs2 - no mask
  TEST_RR_OP( 3, pmslt.w, 0x0000000000000000, 0x0000000500000005, 0x0000000300000003 );

  # Test case 3: Equal values - no mask
  TEST_RR_OP( 4, pmslt.w, 0x0000000000000000, 0x0000000400000004, 0x0000000400000004 );

  # Test case 4: Signed comparison (-1 < 1)
  # 0xffffffff = -1, 0x00000001 = 1
  TEST_RR_OP( 5, pmslt.w, 0xffffffffffffffff, 0xffffffffffffffff, 0x0000000100000001 );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END

