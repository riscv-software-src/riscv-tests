# See LICENSE for license details.

#*****************************************************************************
# psll_bs.S
#-----------------------------------------------------------------------------
#
# Test psll.bs instruction (packed shift left logical byte - shift by rs2).
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV64U
RVTEST_CODE_BEGIN

  #-------------------------------------------------------------
  # Arithmetic tests
  #-------------------------------------------------------------

  # psll.bs rd, rs1, rs2
  # Performs packed byte shift left logical by rs2

  # Test case 1: Simple shift left by 1
  # bytes 01..08 << 1 = 02 04 06 08 0a 0c 0e 10 (decimal 2,4,6,8,10,12,14,16)
  TEST_RR_OP( 2, psll.bs, 0x020406080a0c0e10, 0x0102030405060708, 0x0101010101010101 );

  # Test case 2: Shift by 0 (no change)
  TEST_RR_OP( 3, psll.bs, 0x0102030405060708, 0x0102030405060708, 0x0000000000000000 );

  # Test case 3: Shift left by 4
  TEST_RR_OP( 4, psll.bs, 0x1020304050607080, 0x0102030405060708, 0x0404040404040404 );

  # Test case 4: Scalar shift — all bytes use only rs2[7:0]=2 as shift amount,
  # not their own byte (rs2 upper bytes differ, but result must equal shift-by-2)
  # If scalar: 0x01<<2=0x04 for all; if element-wise: results would vary per byte.
  TEST_RR_OP( 5, psll.bs, 0x0404040404040404, 0x0101010101010101, 0x0402030201040302 );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END


