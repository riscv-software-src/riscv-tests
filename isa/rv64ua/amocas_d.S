# See LICENSE for license details.

#*****************************************************************************
# amocas_d.S
#-----------------------------------------------------------------------------
#
# Test amocas.d instruction.
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV64U
RVTEST_CODE_BEGIN

  TEST_CASE(2, a4, 0xffffffff80000000, \
    li a0, 0xffffffff80000000; \
    li a1, 0xfffffffffffff800; \
    la a3, amo_operand; \
    sd a0, 0(a3); \
    mv a4, a0; \
    .word 0x28b6b72f;\
    #amocas.d	a4, a1, 0(a3); \
  )

  TEST_CASE(3, a5, 0xffffffff80000000, mv a5, a4)
  TEST_CASE(4, a5, 0xfffffffffffff800, ld a5, 0(a3))

  # try again after a cache miss
  TEST_CASE(5, a4, 0xfffffffffffff800, \
    li  a1, 0xffffffff80000000; \
    li  a4, 0xfffffffffffff800; \
    .word 0x28b6b72f;\
    #amocas.d a4, a1, 0(a3); \
  )

  TEST_CASE(6, a5, 0xfffffffffffff800, mv a5, a4)
  TEST_CASE(7, a5, 0xffffffff80000000, ld a5, 0(a3))

  # try a cas mismatch
  TEST_CASE(8, a4, 0xfffffffffffff800, \
    li a1, 0xfffffffffffff800; \
    li a4, 0xfffffffff8000001; \
    .word 0x28b6b72f;\
    #amocas.d a4, a1, 0(a3); \
  )

  TEST_CASE(9, a5, 0xffffffff80000000, mv a5, a4)
  TEST_CASE(10, a5, 0xffffffff80000000, ld a5, 0(a3))


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
