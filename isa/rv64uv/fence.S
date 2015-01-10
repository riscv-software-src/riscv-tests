# See LICENSE for license details.

#*****************************************************************************
# fence.S
#-----------------------------------------------------------------------------
#
# Test fence instruction in a vf block.
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV64UV
RVTEST_CODE_BEGIN

  # make sure these don't choke at the beginning
  fence
  fence rw,io
  fence io,rw
  fence r,io
  fence w,io
  fence rw,i
  fence rw,o

  li a0,1
  bne a0,x0,skip1
  fence
skip1:

  bne a0,x0,skip3
  fence
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
