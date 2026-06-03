# See LICENSE for license details.

#*****************************************************************************
# mqracc_h00.S
#-----------------------------------------------------------------------------
#
# Test mqracc.h00 instruction.
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV32U
RVTEST_CODE_BEGIN

  #-------------------------------------------------------------
  # Arithmetic tests
  #-------------------------------------------------------------

  # mqracc.h00: rd = rd + ((sext_47(rs1[15:0]) * sext_47(rs2[15:0]) + 2^14)[46:15])
  # Bit-extract truncation, not rounded division.
  # 10 + (0x4000*0x4000 + 0x4000)[46:15] = 10 + 8192 = 8202
  TEST_CASE( 2, x14, 8202, li x14, 10; li a1, 0x4000; li a2, 0x4000; mqracc.h00 x14, a1, a2 );

  # 0 + (0x2000*0x2000 + 0x4000)[46:15] = 0 + 2048 = 2048
  TEST_CASE( 3, x14, 2048, li x14, 0; li a1, 0x2000; li a2, 0x2000; mqracc.h00 x14, a1, a2 );

  # 5 + (0x1000*0x1000 + 0x4000)[46:15] = 5 + 512 = 517
  TEST_CASE( 4, x14, 517, li x14, 5; li a1, 0x1000; li a2, 0x1000; mqracc.h00 x14, a1, a2 );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END

