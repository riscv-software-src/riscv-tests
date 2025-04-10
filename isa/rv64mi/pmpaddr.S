# See LICENSE for license details.

#*****************************************************************************
# pmpaddr.S
#-----------------------------------------------------------------------------
#
# Test edge cases around the pmpaddr[G-1] bit which sometimes reads as zero
# but is always writable and retains its state. Also test CSRC and CSRS
# modifications to other bits result in a correct read-modify-write.
#
# This test auto-detects G but assumes PMP is available. It supports a
# maximum G of XLEN-1. There's no minimum but if G is 0 then the G-1 bit
# does not exist and this test trivially passes.

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV64M
RVTEST_CODE_BEGIN

  li TESTNUM, 1

  # Software may determine the PMP granularity by writing zero to pmpcfg0,
  # then writing all ones to pmpaddr0, then reading back pmpaddr0.
  # If G is the index of the least-significant bit set, the PMP granularity
  # is 2^(G+2) bytes.
  csrw pmpcfg0, zero
  li t0, -1
  csrw pmpaddr0, t0
  csrr t0, pmpaddr0

  # Isolate the least significant bit.

  neg t1, t0
  and a7, t0, t1

  # a7 now contains only the lowest 1 that was set in pmpaddr0.

  # If a7 is 0 then G is >=XLEN which this test does not support.
  beqz a7, fail
  # Shift so the G-1 bit is set.
  srl a7, a7, 1
  # If no bits are set now then G is 0, which trivially passes.
  beqz a7, pass

#define PMPADDR_Gm1_MASK a7
#define PMPCFG_A_MASK (0x3 << 3)
  # Ok now we can begin the main test!

# Set pmpaddr0[G-1] to `value` (1 or 0).
.macro set_pmpaddr_bit value
.if \value
  csrs pmpaddr0, PMPADDR_Gm1_MASK
.else
  csrc pmpaddr0, PMPADDR_Gm1_MASK
.endif
.endm

# Switch pmpcfg0 to OFF mode so pmpaddr0[G-1] reads as 0.
.macro set_mode_off
  csrc pmpcfg0, PMPCFG_A_MASK
.endm

# Switch pmpcfg0 to NAPOT mode so pmpaddr0[G-1] reads normally.
.macro set_mode_napot
  csrs pmpcfg0, PMPCFG_A_MASK
.endm

# Check that pmpaddr9[G] is set or unset depending on expected_value.
.macro check_pmpaddr_bit expected_value
  # Note when gas 2.43 is common we can use \+ instead of \@ which
  # gives more sensible numbers. \@ still works but it gives 4, 6,
  # 8, 10, 15... instead of 0, 1, 2, 3.
  li TESTNUM, (2 + \@)
  csrr t6, pmpaddr0
  and t6, t6, PMPADDR_Gm1_MASK
.if \expected_value
  beqz t6, fail
.else
  bnez t6, fail
.endif
.endm

.macro check_pmpaddr_bit_clear
  csrr t6, pmpaddr0
  and t6, t6, PMPADDR_Gm1_MASK
  bnez t6, fail
.endm

  # Initialise pmpaddr and pmpcfg.

  # M bit is writable in NAPOT mode.
  set_mode_napot
  # Clear it, it should read 0.
  set_pmpaddr_bit 0
  check_pmpaddr_bit 0
  # Set it, it shouldn't read 0.
  set_pmpaddr_bit 1
  check_pmpaddr_bit 1
  # M bit is writable but reads as 0 in OFF mode.
  set_mode_off
  # Should read as 0.
  check_pmpaddr_bit 0
  # Switch back to NAPOT. The 1 should be readable again.
  set_mode_napot
  check_pmpaddr_bit 1

  # Test writing the bit while it is read-as-zero.
  set_pmpaddr_bit 0
  set_mode_off
  set_pmpaddr_bit 1
  set_mode_napot
  check_pmpaddr_bit 1

  # Test modifying a *different* bit while its underlying
  # value is 1 but it reads as 0. Since csrs and csrc are
  # read-modify-write they reads-as value will be written
  # to the underlying value.
  set_mode_off
  # A csrs or csrc from the zero register does not have
  # any side effects.
  csrc pmpaddr0, zero
  csrs pmpaddr0, zero
  set_mode_napot
  check_pmpaddr_bit 1

  set_mode_off
  # Set other bits. This should result in M being cleared
  # since it currently reads as 0.
  not t0, PMPADDR_Gm1_MASK
  csrs pmpaddr0, t0
  set_mode_napot
  check_pmpaddr_bit 0

  j pass

  TEST_PASSFAIL

  .align 2
  .global mtvec_handler
mtvec_handler:
  # We aren't expecting any exceptions unless PMP is not supported
  # in which case this test is also not supported. There's no
  # way to probe for PMP support so we can't just pass in this case.
  j fail

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END
