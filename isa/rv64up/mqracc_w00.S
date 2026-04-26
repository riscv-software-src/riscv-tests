# See LICENSE for license details.

#*****************************************************************************
# mqracc_w00.S
#-----------------------------------------------------------------------------
#
# Test mqracc.w00 instruction (Q31 format rounding multiply-accumulate, low words, RV64 only).
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV64U
RVTEST_CODE_BEGIN

  #-------------------------------------------------------------
  # Arithmetic tests
  #-------------------------------------------------------------

  # mqracc.w00 rd, rs1, rs2 = rd + ((sext(rs1[31:0]) * sext(rs2[31:0]) + 0x40000000) >> 31)

  # Test case 1: 10 + ((0x40000000 * 0x40000000 + 0x40000000) >> 31) = 10 + 0x20000000 = 0x2000000a
  TEST_CASE( 2, x14, 0x2000000a, li x14, 10; li a1, 0x40000000; li a2, 0x40000000; mqracc.w00 x14, a1, a2 );

  # Test case 2: 0 + ((0x20000000 * 0x20000000 + 0x40000000) >> 31) = 0 + 0x08000000 = 0x08000000
  TEST_CASE( 3, x14, 0x08000000, li x14, 0; li a1, 0x20000000; li a2, 0x20000000; mqracc.w00 x14, a1, a2 );

  # Test case 3: 5 + ((0x10000000 * 0x10000000 + 0x40000000) >> 31) = 5 + 0x02000001 = 0x02000006
  TEST_CASE( 4, x14, 0x02000006, li x14, 5; li a1, 0x10000000; li a2, 0x10000000; mqracc.w00 x14, a1, a2 );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END

