# See LICENSE for license details.

#*****************************************************************************
# amocas_q.S
#-----------------------------------------------------------------------------
#
# Test amocas.q instruction.
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV64U
RVTEST_CODE_BEGIN

  TEST_CASE(2, a2, 0xffffffff80000000, \
    li a2, 0xffffffff80000000; \
    li a3, 0xfffffffffffff800; \
    la a0, amo_operand; \
    sd a2, 0(a0); \
    sd a3, 8(a0); \
    addi a4, a2, 1; \
    addi a5, a3, 0; \
    .word 0x28e5462f;\
    #amocas.q	a2, a4, 0(a0); \
  )

  TEST_CASE(3, a5, 0xfffffffffffff800, mv a5, a3)
  TEST_CASE(4, a5, 0xffffffff80000001, ld a5, 0(a0))
  TEST_CASE(5, a5, 0xfffffffffffff800, ld a5, 8(a0))

  # try again after a cache miss
  TEST_CASE(6, a2, 0xffffffff80000001, \
    addi a2, a2, 1; \
    addi a4, a4, 1; \
    .word 0x28e5462f;\
    #amocas.q a2, a4, 0(a0); \
  )
  TEST_CASE(7, a5, 0xfffffffffffff800, mv a5, a3)
  TEST_CASE(8, a5, 0xffffffff80000002, ld a5, 0(a0))
  TEST_CASE(9, a5, 0xfffffffffffff800, ld a5, 8(a0))

  # try a cas mismatch
  TEST_CASE(10, a2, 0xffffffff80000001, \
    addi a4, a4, 1; \
    .word 0x28e5462f;\
    #amocas.q a2, a4, 0(a0); \
  )

  TEST_CASE(11, a5, 0xfffffffffffff800, mv a5, a3)
  TEST_CASE(12, a5, 0xffffffff80000002, ld a5, 0(a0))
  TEST_CASE(13, a5, 0xfffffffffffff800, ld a5, 8(a0))

  # Zero rs2 means zero.
  TEST_CASE(14, a4, 0x80000000, \
    li x1, 0x1; \
    li a2, 0xffffffff80000000; \
    li a3, 0xffffffff70000000; \
    la a0, amo_operand; \
    sd a2, 0(a0); \
    sd a3, 8(a0); \
    .word 0x2805462f;\
    #amocas.q a2, zero, 0(a0); \
  )
  TEST_CASE(15, a7, 0, ld a7, 0(a0))
  TEST_CASE(16, a7, 0, ld a7, 8(a0))

  # Zero rd means zero
  TEST_CASE(18, x1, 1, \
    li x1, 1; \
    li a4, 0xfffffffffffff800; \
    li a5, 0xfffffffffffff700; \
    la a0, amo_operand; \
    sd x0, 0(a0); \
    sd x0, 8(a0); \
    .word 0x28e5402f;\
    #amocas.q zero, a4, 0(a0); \
  )
  TEST_CASE(19, a7, 0xfffffffffffff800, ld a7, 0(a0))
  TEST_CASE(20, a7, 0xfffffffffffff700, ld a7, 8(a0))

#ifndef _ENV_VIRTUAL_SINGLE_CORE_H
  # only even registers can be encoded in rd pair
  TEST_CASE(21, x0, x0, \
    .word 0x28e540af; \
    #amocas.q x1, a4, 0(a0); \
  )

  # only even registers can be encoded in rs2 pair
  TEST_CASE(22, x0, x0, \
    .word 0x2815402f; \
    #amocas.q zero, x1, 0(a0); \
  )
#endif

  TEST_PASSFAIL

#ifndef _ENV_VIRTUAL_SINGLE_CORE_H
  .align 2
  .global mtvec_handler
mtvec_handler:
  # only test 21 and 22 expected to cause an illegal-inst
  li t1, CAUSE_ILLEGAL_INSTRUCTION
  csrr t0, mcause
  bne t0, t1, unexpected
  li t0, 21
  beq TESTNUM, t0, expected
  li t0, 22
  beq TESTNUM, t0, expected
unexpected:
  la t0, fail
  csrw mepc, t0
  mret
expected:
  csrr t0, mepc
  addi t0, t0, 4
  csrw mepc, t0
  mret
#endif

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END

  .bss
  .align 3
amo_operand:
  .dword 0
  .dword 0
