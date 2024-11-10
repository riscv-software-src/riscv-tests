# See LICENSE for license details.

#*****************************************************************************
# zalasr.S
#-----------------------------------------------------------------------------
#
# Test zalasr instructions.
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV64U
RVTEST_CODE_BEGIN

  TEST_LD_OP( 1, lb.aq  , 0x0000000000000008, 0, tdat );
  TEST_LD_OP( 2, lb.aqrl, 0x0000000000000008, 0, tdat );
  TEST_LD_OP( 3, lh.aq  , 0x0000000000000708, 0, tdat );
  TEST_LD_OP( 4, lh.aqrl, 0x0000000000000708, 0, tdat );
  TEST_LD_OP( 5, lw.aq  , 0x0000000005060708, 0, tdat );
  TEST_LD_OP( 6, lw.aqrl, 0x0000000005060708, 0, tdat );


  TEST_ST_OP(11, lb, sb.rl  , 0x0000000000000008, 0, tdat );
  TEST_ST_OP(12, lb, sb.aqrl, 0x0000000000000008, 0, tdat );
  TEST_ST_OP(13, lh, sh.rl  , 0x0000000000000708, 0, tdat );
  TEST_ST_OP(14, lh, sh.aqrl, 0x0000000000000708, 0, tdat );
  TEST_ST_OP(15, lw, sw.rl  , 0x0000000005060708, 0, tdat );
  TEST_ST_OP(16, lw, sw.aqrl, 0x0000000005060708, 0, tdat );
  

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

  .align 3
tdat:
  .dword 0x0102030405060708

RVTEST_DATA_END
