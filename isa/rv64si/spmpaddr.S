# See LICENSE for license details.

#*****************************************************************************
# spmpaddr.S
#-----------------------------------------------------------------------------
#
# Test SPMP address register (spmpaddr*) functionality via indirect access.
#
# According to SPMP specification:
# - SPMP registers are accessed ONLY via indirect access mechanism
# - siselect = 0x100 + i selects SPMP entry i (i = 0..63)
# - sireg accesses spmpaddr[i]
# - sireg2 accesses spmpcfg[i]
#
# This test verifies:
# - Indirect access to spmpaddr registers works correctly
# - Address granularity detection
# - Read/write behavior of spmpaddr via sireg

#include "riscv_test.h"
#include "test_macros.h"

# SPMP indirect access CSR numbers (from Sscsrind extension)
#define CSR_SISELECT    0x150
#define CSR_SIREG       0x151
#define CSR_SIREG2      0x152

# SPMP siselect base value for SPMP entries (0x100..0x13F for entries 0..63)
#define SPMP_SELECT_BASE 0x100

# SPMP configuration bits layout (SXLEN-bit register per entry):
# Bits [1:0]: R, W
# Bit 2: X
# Bits [4:3]: A (address matching mode)
# Bits [6:5]: Reserved (WPRI)
# Bit 7: L (lock)
# Bit 8: U (user mode)
# Bit 9: SHARED
# Bits [SXLEN-1:10]: Reserved (WPRI)
#define SPMP_R          0x01
#define SPMP_W          0x02
#define SPMP_X          0x04
#define SPMP_A_OFF      0x00
#define SPMP_A_TOR      0x08
#define SPMP_A_NA4      0x10
#define SPMP_A_NAPOT    0x18
#define SPMP_A_MASK     0x18
#define SPMP_L          0x80
#define SPMP_U          0x100
#define SPMP_SHARED     0x200

RVTEST_RV64S
RVTEST_CODE_BEGIN

  li TESTNUM, 1

  # Select SPMP entry 0 (siselect = 0x100)
  li t0, SPMP_SELECT_BASE
  csrw CSR_SISELECT, t0

  # Verify siselect was written correctly
  csrr t1, CSR_SISELECT
  bne t0, t1, fail

  li TESTNUM, 2

  # Software may determine the SPMP granularity by:
  # 1. Writing zero to spmpcfg[i] (via sireg2)
  # 2. Writing all ones to spmpaddr[i] (via sireg)
  # 3. Reading back spmpaddr[i]
  # If G is the index of the least-significant bit set, the granularity is 2^(G+2) bytes.

  # Clear spmpcfg[0] via sireg2
  csrw CSR_SIREG2, zero

  # Write all ones to spmpaddr[0] via sireg
  li t0, -1
  csrw CSR_SIREG, t0

  # Read back spmpaddr[0] via sireg
  csrr t0, CSR_SIREG

  # Isolate the least significant bit set
  neg t1, t0
  and a7, t0, t1

  # a7 now contains only the lowest 1 that was set in spmpaddr[0].

  li TESTNUM, 3

  # If a7 is 0 then G is >=XLEN which this test does not support.
  beqz a7, fail

  # Shift so the G-1 bit is set.
  srl a7, a7, 1

  # If no bits are set now then G is 0, which trivially passes.
  beqz a7, pass

#define SPMPADDR_Gm1_MASK a7

  # Ok now we can begin the main test!

# Set spmpaddr[0][G-1] to `value` (1 or 0) via indirect access.
.macro set_spmpaddr_bit value
  li t5, SPMP_SELECT_BASE
  csrw CSR_SISELECT, t5
.if \value
  csrs CSR_SIREG, SPMPADDR_Gm1_MASK
.else
  csrc CSR_SIREG, SPMPADDR_Gm1_MASK
.endif
.endm

# Switch spmpcfg[0] to OFF mode (A=00) so spmpaddr[0][G-1] reads as 0.
.macro set_mode_off
  li t5, SPMP_SELECT_BASE
  csrw CSR_SISELECT, t5
  csrw CSR_SIREG2, zero
.endm

# Switch spmpcfg[0] to NAPOT mode (A=11) so spmpaddr[0][G-1] reads normally.
.macro set_mode_napot
  li t5, SPMP_SELECT_BASE
  csrw CSR_SISELECT, t5
  li t5, SPMP_A_NAPOT
  csrw CSR_SIREG2, t5
.endm

# Check that spmpaddr[0][G-1] is set or unset depending on expected_value.
.macro check_spmpaddr_bit expected_value
  li TESTNUM, (4 + \@)
  li t5, SPMP_SELECT_BASE
  csrw CSR_SISELECT, t5
  csrr t6, CSR_SIREG
  and t6, t6, SPMPADDR_Gm1_MASK
.if \expected_value
  beqz t6, fail
.else
  bnez t6, fail
.endif
.endm

  # Test: Bit is writable in NAPOT mode
  set_mode_napot
  # Clear it, it should read 0
  set_spmpaddr_bit 0
  check_spmpaddr_bit 0
  # Set it, it should read 1
  set_spmpaddr_bit 1
  check_spmpaddr_bit 1

  # Test: Bit is writable but reads as 0 in OFF mode
  set_mode_off
  # Should read as 0 in OFF mode
  check_spmpaddr_bit 0
  # Switch back to NAPOT. The 1 should be readable again
  set_mode_napot
  check_spmpaddr_bit 1

  # Test: Writing the bit while in read-as-zero mode
  set_spmpaddr_bit 0
  set_mode_off
  set_spmpaddr_bit 1
  set_mode_napot
  check_spmpaddr_bit 1

  # Test: Modifying a *different* bit while its underlying
  # value is 1 but it reads as 0
  set_mode_off
  # A csrs or csrc from the zero register does not have any side effects
  li t5, SPMP_SELECT_BASE
  csrw CSR_SISELECT, t5
  csrc CSR_SIREG, zero
  csrs CSR_SIREG, zero
  set_mode_napot
  check_spmpaddr_bit 1

  # Test: Setting other bits clears the read-as-zero bit
  set_mode_off
  not t0, SPMPADDR_Gm1_MASK
  li t5, SPMP_SELECT_BASE
  csrw CSR_SISELECT, t5
  csrs CSR_SIREG, t0
  set_mode_napot
  check_spmpaddr_bit 0

  j pass

  TEST_PASSFAIL

  .align 2
  .global stvec_handler
stvec_handler:
  # Check for illegal instruction (SPMP/Sscsrind not supported)
  csrr t0, scause
  li t1, CAUSE_ILLEGAL_INSTRUCTION
  beq t0, t1, pass
  j fail

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END
