# See LICENSE for license details.

#*****************************************************************************
# lb_aqrl.S
#-----------------------------------------------------------------------------
#
# Test lb.aq and lb.aqrl instructions.
#

#include "riscv_test.h"
#include "test_macros.h"

.option arch, +zalasr

RVTEST_RV64U
RVTEST_CODE_BEGIN

  #-------------------------------------------------------------
  # Basic tests
  #-------------------------------------------------------------

  # lb.aq and lb.aqrl do not have offset, which must be 0
  TEST_LD_OP( 2, lb.aq,   0xffffffffffffffff, 0, tdat );
  TEST_LD_OP( 3, lb.aq,   0x0000000000000000, 0, tdat2 );

  TEST_LD_OP( 4, lb.aqrl, 0xfffffffffffffff0, 0, tdat3 );
  TEST_LD_OP( 5, lb.aqrl, 0x000000000000000f, 0, tdat4 );

  #-------------------------------------------------------------
  # Bypassing tests
  #-------------------------------------------------------------

  TEST_LD_DEST_BYPASS( 8, 0, lb.aq,   0xfffffffffffffff0, 0, tdat3 );
  TEST_LD_DEST_BYPASS( 9, 1, lb.aq,   0x000000000000000f, 0, tdat4 );
  TEST_LD_DEST_BYPASS( 10, 2, lb.aq,   0x0000000000000000, 0, tdat2 );

  TEST_LD_SRC1_BYPASS( 11, 0, lb.aq,   0xfffffffffffffff0, 0, tdat3 );
  TEST_LD_SRC1_BYPASS( 12, 1, lb.aq,   0x000000000000000f, 0, tdat4 );
  TEST_LD_SRC1_BYPASS( 13, 2, lb.aq,   0x0000000000000000, 0, tdat2 );

  TEST_LD_DEST_BYPASS( 14, 0, lb.aqrl, 0xfffffffffffffff0, 0, tdat3 );
  TEST_LD_DEST_BYPASS( 15, 1, lb.aqrl, 0x000000000000000f, 0, tdat4 );
  TEST_LD_DEST_BYPASS( 16, 2, lb.aqrl, 0x0000000000000000, 0, tdat2 );

  TEST_LD_SRC1_BYPASS( 17, 0, lb.aqrl, 0xfffffffffffffff0, 0, tdat3 );
  TEST_LD_SRC1_BYPASS( 18, 1, lb.aqrl, 0x000000000000000f, 0, tdat4 );
  TEST_LD_SRC1_BYPASS( 19, 2, lb.aqrl, 0x0000000000000000, 0, tdat2 );

  #-------------------------------------------------------------
  # Test write-after-write hazard
  #-------------------------------------------------------------

  TEST_CASE( 20, x2, 2, \
    la  x5, tdat; \
    lb.aq  x2, (x5); \
    li  x2, 2; \
  )

  TEST_CASE( 21, x2, 2, \
    la  x5, tdat; \
    lb.aq  x2, (x5); \
    nop; \
    li  x2, 2; \
  )

  TEST_CASE( 22, x2, 2, \
    la  x5, tdat; \
    lb.aqrl  x2, (x5); \
    li  x2, 2; \
  )

  TEST_CASE( 23, x2, 2, \
    la  x5, tdat; \
    lb.aqrl  x2, (x5); \
    nop; \
    li  x2, 2; \
  )

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

tdat:
tdat1:  .byte 0xff
tdat2:  .byte 0x00
tdat3:  .byte 0xf0
tdat4:  .byte 0x0f

RVTEST_DATA_END
