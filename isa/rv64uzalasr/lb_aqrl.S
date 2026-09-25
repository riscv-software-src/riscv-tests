# See LICENSE for license details.

#*****************************************************************************
# lb_aqrl.S
#-----------------------------------------------------------------------------
#
# Test lb.aqrl instruction.
#

#include "riscv_test.h"
#include "test_macros.h"

.option arch, +zalasr

RVTEST_RV64U
RVTEST_CODE_BEGIN

  #-------------------------------------------------------------
  # Basic tests
  #-------------------------------------------------------------

  # lb.aqrl does not have offset, must be 0
  TEST_LD_OP( 2, lb.aqrl, 0xffffffffffffffff, 0, tdat );
  TEST_LD_OP( 3, lb.aqrl, 0x0000000000000000, 0, tdat2 );
  TEST_LD_OP( 4, lb.aqrl, 0xfffffffffffffff0, 0, tdat3 );
  TEST_LD_OP( 5, lb.aqrl, 0x000000000000000f, 0, tdat4 );

  # Test with a negative base

  TEST_CASE( 6, x5, 0xffffffffffffffff, \
    la  x1, tdat; \
    addi x1, x1, -32; \
    addi x1, x1, 32; \
    lb.aqrl x5, (x1); \
  )

  # Test with unaligned base

  TEST_CASE( 7, x5, 0x0000000000000000, \
    la  x1, tdat; \
    addi x1, x1, -6; \
    addi x1, x1, 7; \
    lb.aqrl x5, (x1); \
  )


  #-------------------------------------------------------------
  # Bypassing tests
  #-------------------------------------------------------------

  TEST_LD_DEST_BYPASS( 8, 0, lb.aqrl, 0xfffffffffffffff0, 0, tdat3 );
  TEST_LD_DEST_BYPASS( 9, 1, lb.aqrl, 0x000000000000000f, 0, tdat4 );
  TEST_LD_DEST_BYPASS( 10, 2, lb.aqrl, 0x0000000000000000, 0, tdat2 );

  TEST_LD_SRC1_BYPASS( 11, 0, lb.aqrl, 0xfffffffffffffff0, 0, tdat3 );
  TEST_LD_SRC1_BYPASS( 12, 1, lb.aqrl, 0x000000000000000f, 0, tdat4 );
  TEST_LD_SRC1_BYPASS( 13, 2, lb.aqrl, 0x0000000000000000, 0, tdat2 );

  #-------------------------------------------------------------
  # Test write-after-write hazard
  #-------------------------------------------------------------

  TEST_CASE( 14, x2, 2, \
    la  x5, tdat; \
    lb.aqrl  x2, (x5); \
    li  x2, 2; \
  )

  TEST_CASE( 15, x2, 2, \
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
