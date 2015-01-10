# See LICENSE for license details.

#*****************************************************************************
# ldst.S
#-----------------------------------------------------------------------------
#
# This test verifies that flw, fld, fsw, and fsd work properly.
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV64UF
RVTEST_CODE_BEGIN

  TEST_CASE(2, a0, 0x4000000040400000, la a1, tdat; flw f1, 4(a1); fsw f1, 12(a1); ld a0, 8(a1))
  TEST_CASE(3, a0, 0x400000003f800000, la a1, tdat; fld f2, 0(a1); fsd f2, 8(a1); ld a0, 8(a1))

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

tdat:
.word 0x3f800000
.word 0x40000000
.word 0x40400000
.word 0x40800000

RVTEST_DATA_END
