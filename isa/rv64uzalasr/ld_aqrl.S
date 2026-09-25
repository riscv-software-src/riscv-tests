# See LICENSE for license details.

#*****************************************************************************
# ld_aqrl.S
#-----------------------------------------------------------------------------
#
# Test ld.aq and ld.aqrl instructions.
#

#include "riscv_test.h"
#include "test_macros.h"

.option arch, +zalasr

RVTEST_RV64U
RVTEST_CODE_BEGIN

  #-------------------------------------------------------------
  # Basic tests
  #-------------------------------------------------------------

  TEST_LD_OP( 2, ld.aq,   0x00ff00ff00ff00ff, 0, tdat );
  TEST_LD_OP( 3, ld.aq,   0xff00ff00ff00ff00, 0, tdat2 );

  TEST_LD_OP( 4, ld.aqrl, 0x0ff00ff00ff00ff0, 0, tdat3 );
  TEST_LD_OP( 5, ld.aqrl, 0xf00ff00ff00ff00f, 0, tdat4 );

  #-------------------------------------------------------------
  # Bypassing tests
  #-------------------------------------------------------------

  TEST_LD_DEST_BYPASS( 8, 0, ld.aq,   0x0ff00ff00ff00ff0, 0, tdat3 );
  TEST_LD_DEST_BYPASS( 9, 1, ld.aq,   0xf00ff00ff00ff00f, 0, tdat4 );
  TEST_LD_DEST_BYPASS( 10, 2, ld.aq,  0xff00ff00ff00ff00, 0, tdat2 );

  TEST_LD_SRC1_BYPASS( 11, 0, ld.aq,  0x0ff00ff00ff00ff0, 0, tdat3 );
  TEST_LD_SRC1_BYPASS( 12, 1, ld.aq,  0xf00ff00ff00ff00f, 0, tdat4 );
  TEST_LD_SRC1_BYPASS( 13, 2, ld.aq,  0xff00ff00ff00ff00, 0, tdat2 );

  TEST_LD_DEST_BYPASS( 14, 0, ld.aqrl, 0x0ff00ff00ff00ff0, 0, tdat3 );
  TEST_LD_DEST_BYPASS( 15, 1, ld.aqrl, 0xf00ff00ff00ff00f, 0, tdat4 );
  TEST_LD_DEST_BYPASS( 16, 2, ld.aqrl, 0xff00ff00ff00ff00, 0, tdat2 );

  TEST_LD_SRC1_BYPASS( 17, 0, ld.aqrl, 0x0ff00ff00ff00ff0, 0, tdat3 );
  TEST_LD_SRC1_BYPASS( 18, 1, ld.aqrl, 0xf00ff00ff00ff00f, 0, tdat4 );
  TEST_LD_SRC1_BYPASS( 19, 2, ld.aqrl, 0xff00ff00ff00ff00, 0, tdat2 );

  #-------------------------------------------------------------
  # Test write-after-write hazard
  #-------------------------------------------------------------

  TEST_CASE( 20, x2, 2, \
    la  x5, tdat; \
    ld.aq  x2, (x5); \
    li  x2, 2; \
  )

  TEST_CASE( 21, x2, 2, \
    la  x5, tdat; \
    ld.aq  x2, (x5); \
    nop; \
    li  x2, 2; \
  )

  TEST_CASE( 22, x2, 2, \
    la  x5, tdat; \
    ld.aqrl  x2, (x5); \
    li  x2, 2; \
  )

  TEST_CASE( 23, x2, 2, \
    la  x5, tdat; \
    ld.aqrl  x2, (x5); \
    nop; \
    li  x2, 2; \
  )

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

tdat:
tdat1:  .dword 0x00ff00ff00ff00ff
tdat2:  .dword 0xff00ff00ff00ff00
tdat3:  .dword 0x0ff00ff00ff00ff0
tdat4:  .dword 0xf00ff00ff00ff00f

RVTEST_DATA_END
