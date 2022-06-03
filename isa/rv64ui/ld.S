# See LICENSE for license details.

#*****************************************************************************
# ld.S
#-----------------------------------------------------------------------------
#
# Test ld instruction.
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV64U
RVTEST_CODE_BEGIN

  #-------------------------------------------------------------
  # Basic tests
  #-------------------------------------------------------------

  TEST_LD_OP( 2, ld, 0x00ff00ff00ff00ff, 0,  tdat );
  TEST_LD_OP( 3, ld, 0xff00ff00ff00ff00, 8,  tdat );
  TEST_LD_OP( 4, ld, 0x0ff00ff00ff00ff0, 16, tdat );
  TEST_LD_OP( 5, ld, 0xf00ff00ff00ff00f, 24, tdat );

  # Test with negative offset

  TEST_LD_OP( 6, ld, 0x00ff00ff00ff00ff, -24, tdat4 );
  TEST_LD_OP( 7, ld, 0xff00ff00ff00ff00, -16, tdat4 );
  TEST_LD_OP( 8, ld, 0x0ff00ff00ff00ff0, -8,  tdat4 );
  TEST_LD_OP( 9, ld, 0xf00ff00ff00ff00f, 0,   tdat4 );

  # Test with a negative base

  TEST_CASE( 10, x5, 0x00ff00ff00ff00ff, \
    la  x1, tdat; \
    addi x1, x1, -32; \
    ld x5, 32(x1); \
  )

  # Test with unaligned base

  TEST_CASE( 11, x5, 0xff00ff00ff00ff00, \
    la  x1, tdat; \
    addi x1, x1, -3; \
    ld x5, 11(x1); \
  )

  #-------------------------------------------------------------
  # Bypassing tests
  #-------------------------------------------------------------

  TEST_LD_DEST_BYPASS( 12, 0, ld, 0x0ff00ff00ff00ff0, 8, tdat2 );
  TEST_LD_DEST_BYPASS( 13, 1, ld, 0xf00ff00ff00ff00f, 8, tdat3 );
  TEST_LD_DEST_BYPASS( 14, 2, ld, 0xff00ff00ff00ff00, 8, tdat1 );

  TEST_LD_SRC1_BYPASS( 15, 0, ld, 0x0ff00ff00ff00ff0, 8, tdat2 );
  TEST_LD_SRC1_BYPASS( 16, 1, ld, 0xf00ff00ff00ff00f, 8, tdat3 );
  TEST_LD_SRC1_BYPASS( 17, 2, ld, 0xff00ff00ff00ff00, 8, tdat1 );

  #-------------------------------------------------------------
  # Test write-after-write hazard
  #-------------------------------------------------------------

  TEST_CASE( 18, x2, 2, \
    la  x5, tdat; \
    ld  x2, 0(x5); \
    li  x2, 2; \
  )

  TEST_CASE( 19, x2, 2, \
    la  x5, tdat; \
    ld  x2, 0(x5); \
    nop; \
    li  x2, 2; \
  )

  # Test unaligned accesses, if the target supports them.
  # Assume little-endian
  TEST_LD_OP( 1000, ld, 0x00ff00ff00ff00ff, 0,  tdat );
  TEST_LD_OP( 1001, ld, 0x0000ff00ff00ff00, 1,  tdat );
  TEST_LD_OP( 1002, ld, 0xff0000ff00ff00ff, 2,  tdat );
  TEST_LD_OP( 1003, ld, 0x00ff0000ff00ff00, 3,  tdat );
  TEST_LD_OP( 1004, ld, 0xff00ff0000ff00ff, 4,  tdat );
  TEST_LD_OP( 1005, ld, 0x00ff00ff0000ff00, 5,  tdat );
  TEST_LD_OP( 1006, ld, 0xff00ff00ff0000ff, 6,  tdat );
  TEST_LD_OP( 1007, ld, 0x00ff00ff00ff0000, 7,  tdat );

skip_unaligned_tests:
  TEST_PASSFAIL

  .align 2
  .global mtvec_handler
mtvec_handler:
  # Only unaligned access tests should trap
  li t0, 1000
  blt TESTNUM, t0, fail

  li t0, CAUSE_MISALIGNED_LOAD
  csrr t1, mcause
  bne t0, t1, fail

  la t0, skip_unaligned_tests
  csrw mepc, t0
  mret

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
