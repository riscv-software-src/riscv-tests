# See LICENSE for license details.

#*****************************************************************************
# amocas_b.S
#-----------------------------------------------------------------------------
#
# Test amocas.b instruction.
#

#include "riscv_test.h"
#include "test_macros.h"

.option arch, +zacas, +zabha

RVTEST_RV64U
RVTEST_CODE_BEGIN

  TEST_CASE(2, a4, 0xffffffffffffff80, \
    li a0, 0xffffffffffffff80; \
    li a1, 0xfffffffffffffff8; \
    la a3, amo_operand; \
    sb a0, 0(a3); \
    mv a4, a0; \
    amocas.b a4, a1, 0(a3); \
  )

  TEST_CASE(3, a5, 0xfffffffffffffff8, lb a5, 0(a3))

  # Try again. Restore the original value.
  TEST_CASE(4, a4, 0xfffffffffffffff8, \
    li  a1, 0xffffffffffffff80; \
    li  a4, 0xfffffffffffffff8; \
    amocas.b a4, a1, 0(a3); \
  )

  TEST_CASE(5, a5, 0xffffffffffffff80, lb a5, 0(a3))

  # try a CAS mismatch
  TEST_CASE(6, a4, 0xffffffffffffff80, \
    li a1, 0xfffffffffffffff8; \
    li a4, 0xfffffffff8000001; \
    amocas.b a4, a1, 0(a3); \
  )

  TEST_CASE(7, a5, 0xffffffffffffff80, lb a5, 0(a3))


  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END

  .bss
  .align 3
amo_operand:
  .dword 0
