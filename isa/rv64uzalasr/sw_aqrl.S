# See LICENSE for license details.

#*****************************************************************************
# sw_acrl.S
#-----------------------------------------------------------------------------
#
# Test sw.rl and sw.aqrl instructions.
#

#include "riscv_test.h"
#include "test_macros.h"

.option arch, +zalasr

RVTEST_RV64U
RVTEST_CODE_BEGIN

  #-------------------------------------------------------------
  # Basic tests
  #-------------------------------------------------------------
  TEST_ST_OP( 2, lw, sw.aqrl, 0xffffffffaabbccdd, 0, tdat );
  TEST_ST_OP( 3, lw, sw.aqrl, 0x0000000000000055, 0, tdat2 );

  TEST_ST_OP( 4, lw, sw.rl,   0xffffffffaabbccdd, 0, tdat );
  TEST_ST_OP( 5, lw, sw.rl,   0x0000000000000055, 0, tdat2 );

  TEST_ST_SRC12_BYPASS( 6, 0, 0, lw, sw.aqrl, 0xffffffffaabbccdd, 0, tdat );
  TEST_ST_SRC12_BYPASS( 7, 1, 0, lw, sw.aqrl, 0x0000000000000055, 0, tdat2 );

  TEST_ST_SRC21_BYPASS( 8, 0, 0, lw, sw.aqrl, 0xffffffffaabbccdd, 0, tdat );
  TEST_ST_SRC21_BYPASS( 9, 1, 0, lw, sw.aqrl, 0x0000000000000055, 0, tdat2 );
 
  TEST_ST_SRC12_BYPASS( 10, 0, 0, lw, sw.rl, 0xffffffffaabbccdd, 0, tdat );
  TEST_ST_SRC12_BYPASS( 11, 1, 0, lw, sw.rl, 0x0000000000000055, 0, tdat2 );

  TEST_ST_SRC21_BYPASS( 12, 0, 0, lw, sw.rl, 0xffffffffaabbccdd, 0, tdat );
  TEST_ST_SRC21_BYPASS( 13, 1, 0, lw, sw.rl, 0x0000000000000055, 0, tdat2 );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN
  TEST_DATA
tdat:
tdat1:  .dword 0xdeadbeefdeadbeef
tdat2:  .dword 0xdeadbeefdeadbeef
RVTEST_DATA_END
