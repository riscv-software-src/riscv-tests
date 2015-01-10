# See LICENSE for license details.

#*****************************************************************************
# move.S
#-----------------------------------------------------------------------------
#
# This test verifies that mxtf.[s,d], mftx.[s,d], fssr, frsr,
# and fsgnj[x|n].[s|d] work properly.
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV64UF
RVTEST_CODE_BEGIN

li a0, 1
fssr a0

  TEST_CASE(2, a1, 1, li a0, 0x1234; fssr a1, a0)
  TEST_CASE(3, a0, 0x34, frsr a0)
  TEST_CASE(4, a0, 0x34, frsr a0)

  TEST_CASE(5, a0, 0xFFFFFFFFBF812345, li a1, 0xFFFFFFFFBF812345; fmv.s.x f0, a1; fmv.x.s a0, f0)
  TEST_CASE(6, a0, 0x3FF02468A0000000, li a1, 0x3FF02468A0000000; fmv.d.x f1, a1; fmv.x.d a0, f1)

  TEST_CASE(7, a0, 0xFFFFFFFFBF812345, li a1, 0xFFFFFFFFBF812345; fmv.s.x f0, a1; fsgnj.s f1, f0, f0; fmv.x.s a0, f1)
  TEST_CASE(8, a0, 0x000000004BA98765, li a1, 0xFFFFFFFFCBA98765; fmv.s.x f0, a1; fsgnjx.s f1, f0, f0; fmv.x.s a0, f1)
  TEST_CASE(9, a0, 0x000000005EADBEEF, li a1, 0xFFFFFFFFDEADBEEF; fmv.s.x f0, a1; fsgnjn.s f1, f0, f0; fmv.x.s a0, f1)
  TEST_CASE(10, a0, 0xBFF02468A0001000, li a1, 0x3FF02468A0001000; li a2, -1; fmv.d.x f1, a1; fmv.d.x f2, a2; fsgnj.d f0, f1, f2; fmv.x.d a0, f0)

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END
