# See LICENSE for license details.

#*****************************************************************************
# lh_aqrl.S
#-----------------------------------------------------------------------------
#
# Test lh.aq and lh.aqrl instructions.
#

#include "riscv_test.h"
#include "test_macros.h"

.option arch, +zalasr

RVTEST_RV64U
RVTEST_CODE_BEGIN

  #-------------------------------------------------------------
  # Basic tests
  #-------------------------------------------------------------

  TEST_LD_OP( 2, lh.aq,   0x00000000000000ff, 0, tdat );
  TEST_LD_OP( 3, lh.aq,   0xffffffffffffff00, 0, tdat2 );

  TEST_LD_OP( 4, lh.aqrl, 0x0000000000000ff0, 0, tdat3 );
  TEST_LD_OP( 5, lh.aqrl, 0xfffffffffffff00f, 0, tdat4 );

  #-------------------------------------------------------------
  # Bypassing tests
  #-------------------------------------------------------------

  TEST_LD_DEST_BYPASS( 8, 0, lh.aq,   0x0000000000000ff0, 0, tdat3 );
  TEST_LD_DEST_BYPASS( 9, 1, lh.aq,   0xfffffffffffff00f, 0, tdat4 );
  TEST_LD_DEST_BYPASS( 10, 2, lh.aq, 0xffffffffffffff00, 0, tdat2 );
 
  TEST_LD_SRC1_BYPASS( 11, 0, lh.aq,  0x0000000000000ff0, 0, tdat3 );
  TEST_LD_SRC1_BYPASS( 12, 1, lh.aq,  0xfffffffffffff00f, 0, tdat4 );
  TEST_LD_SRC1_BYPASS( 13, 2, lh.aq,  0xffffffffffffff00, 0, tdat2 );

  TEST_LD_DEST_BYPASS( 14, 0, lh.aqrl, 0x0000000000000ff0, 0, tdat3 );
  TEST_LD_DEST_BYPASS( 15, 1, lh.aqrl, 0xfffffffffffff00f, 0, tdat4 );
  TEST_LD_DEST_BYPASS( 16, 2, lh.aqrl, 0xffffffffffffff00, 0, tdat2 );
 
  TEST_LD_SRC1_BYPASS( 17, 0, lh.aqrl,  0x0000000000000ff0, 0, tdat3 );
  TEST_LD_SRC1_BYPASS( 18, 1, lh.aqrl,  0xfffffffffffff00f, 0, tdat4 );
  TEST_LD_SRC1_BYPASS( 19, 2, lh.aqrl,  0xffffffffffffff00, 0, tdat2 );

  #-------------------------------------------------------------
  # Test write-after-write hazard
  #-------------------------------------------------------------

  TEST_CASE( 20, x2, 2, \
    la  x5, tdat; \
    lh.aq  x2, (x5); \
    li  x2, 2; \
  )

  TEST_CASE( 21, x2, 2, \
    la  x5, tdat; \
    lh.aq  x2, (x5); \
    nop; \
    li  x2, 2; \
  )

  TEST_CASE( 22, x2, 2, \
    la  x5, tdat; \
    lh.aqrl  x2, (x5); \
    li  x2, 2; \
  )

  TEST_CASE( 23, x2, 2, \
    la  x5, tdat; \
    lh.aqrl  x2, (x5); \
    nop; \
    li  x2, 2; \
  )

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

tdat:
tdat1:  .half 0x00ff
tdat2:  .half 0xff00
tdat3:  .half 0x0ff0
tdat4:  .half 0xf00f

RVTEST_DATA_END
