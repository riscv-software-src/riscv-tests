#*****************************************************************************
# illegal_tvec_regid.S
#-----------------------------------------------------------------------------
#
# Test illegal tvec regid trap.
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV64S
RVTEST_CODE_BEGIN

  mfpcr a0,cr0
  li a1,1
  slli a2,a1,8
  or a0,a0,a1 # enable traps
  mtpcr a0,cr0

  TEST_ILLEGAL_TVEC_REGID(2, 5, 5, vsd, vx7, a2, 0x931c7)
  TEST_ILLEGAL_TVEC_REGID(3, 5, 5, vld, vx7, a2, 0x831c7)

  TEST_ILLEGAL_TVEC_REGID(4, 5, 5, vfsd, vf7, a2, 0x9b9e7)
  TEST_ILLEGAL_TVEC_REGID(5, 5, 5, vfld, vf7, a2, 0x8b9e7)

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

src1:
  .dword 1
  .dword 2
  .dword 3
  .dword 4
src2:
  .dword 4
  .dword 3
  .dword 2
  .dword 1
dest:
  .dword 0xdeadbeefcafebabe
  .dword 0xdeadbeefcafebabe
  .dword 0xdeadbeefcafebabe
  .dword 0xdeadbeefcafebabe

RVTEST_DATA_END
