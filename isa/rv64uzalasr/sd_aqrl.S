# See LICENSE for license details.

#*****************************************************************************
# sd_acrl.S
#-----------------------------------------------------------------------------
#
# Test sd.rl and sd.aqrl instructions.
#

#include "riscv_test.h"
#include "test_macros.h"

.option arch, +zalasr

RVTEST_RV64U
RVTEST_CODE_BEGIN

  #-------------------------------------------------------------
  # Basic tests
  #-------------------------------------------------------------

  TEST_ST_OP( 2, ld, sd.aqrl, 0xaabbccddeeff0011, 0, tdat );
  TEST_ST_OP( 3, ld, sd.aqrl, 0x1100ffeeddccbbaa, 0, tdat2 );

  TEST_ST_OP( 4, ld, sd.rl,   0xaabbccddeeff0011, 0, tdat );
  TEST_ST_OP( 5, ld, sd.rl,   0x1100ffeeddccbbaa, 0, tdat2 );

  TEST_ST_SRC12_BYPASS( 6, 0, 0, ld, sd.aqrl, 0xaabbccddeeff0011, 0, tdat );
  TEST_ST_SRC12_BYPASS( 7, 1, 0, ld, sd.aqrl, 0x1100ffeeddccbbaa, 0, tdat2 );

  TEST_ST_SRC21_BYPASS( 8, 0, 0, ld, sd.aqrl, 0xaabbccddeeff0011, 0, tdat );
  TEST_ST_SRC21_BYPASS( 9, 1, 0, ld, sd.aqrl, 0x1100ffeeddccbbaa, 0, tdat2 );

  TEST_ST_SRC12_BYPASS( 10, 0, 0, ld, sd.rl, 0xaabbccddeeff0011, 0, tdat );
  TEST_ST_SRC12_BYPASS( 11, 1, 0, ld, sd.rl, 0x1100ffeeddccbbaa, 0, tdat2 );

  TEST_ST_SRC21_BYPASS( 12, 0, 0, ld, sd.rl, 0xaabbccddeeff0011, 0, tdat );
  TEST_ST_SRC21_BYPASS( 13, 1, 0, ld, sd.rl, 0x1100ffeeddccbbaa, 0, tdat2 );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN
  TEST_DATA
tdat:
tdat1:  .dword 0xdeadbeefdeadbeef
tdat2:  .dword 0xdeadbeefdeadbeef
RVTEST_DATA_END
