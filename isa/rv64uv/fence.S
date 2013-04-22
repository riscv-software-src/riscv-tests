#*****************************************************************************
# fence.S
#-----------------------------------------------------------------------------
#
# Test fence instruction in a vf block.
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV64U
RVTEST_CODE_BEGIN

  # make sure these don't choke at the beginning
  fence.v.l
  fence.v.g

  li a0,1
  bne a0,x0,skip1
  fence.v.l
skip1:

  bne a0,x0,skip3
  fence.v.g
skip3:

  j pass

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
