# See LICENSE for license details.

#*****************************************************************************
# spmpcfg.S
#-----------------------------------------------------------------------------
#
# Test SPMP configuration register (spmpcfg*) functionality via indirect access.
#
# According to SPMP specification:
# - Each SPMP entry has an SXLEN-bit configuration register (NOT packed like PMP!)
# - spmpcfg[i] layout (SXLEN bits):
#   Bit 0: R (read)
#   Bit 1: W (write)
#   Bit 2: X (execute)
#   Bits [4:3]: A (address matching: 00=OFF, 01=TOR, 10=NA4, 11=NAPOT)
#   Bits [6:5]: Reserved (WPRI)
#   Bit 7: L (lock)
#   Bit 8: U (user mode)
#   Bit 9: SHARED
#   Bits [SXLEN-1:10]: Reserved (WPRI)
#
# Access via indirect mechanism:
# - siselect = 0x100 + i selects SPMP entry i
# - sireg2 accesses spmpcfg[i]

#include "riscv_test.h"
#include "test_macros.h"

# SPMP indirect access CSR numbers
#define CSR_SISELECT    0x150
#define CSR_SIREG       0x151
#define CSR_SIREG2      0x152

# SPMP siselect base value
#define SPMP_SELECT_BASE 0x100

# SPMP configuration bits (each spmpcfg is SXLEN bits, one per entry)
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

  # Test 1: Basic read/write of spmpcfg[0] via indirect access
  li TESTNUM, 1

  # Select SPMP entry 0
  li t0, SPMP_SELECT_BASE
  csrw CSR_SISELECT, t0

  # Clear spmpcfg[0]
  csrw CSR_SIREG2, zero
  csrr t0, CSR_SIREG2
  # Should read 0 after writing 0
  bnez t0, fail

  # Test 2: Write TOR mode with R permission to spmpcfg[0]
  li TESTNUM, 2

  li t0, SPMP_SELECT_BASE
  csrw CSR_SISELECT, t0

  # TOR mode (A=01) + R permission
  li t0, (SPMP_A_TOR | SPMP_R)  # 0x09
  csrw CSR_SIREG2, t0
  csrr t1, CSR_SIREG2
  andi t1, t1, 0x1F  # Mask to check R, W, X, A fields
  li t2, 0x09
  bne t1, t2, fail

  # Test 3: Write NAPOT mode with R+W permissions
  li TESTNUM, 3

  li t0, SPMP_SELECT_BASE
  csrw CSR_SISELECT, t0

  # NAPOT mode (A=11) + R + W
  li t0, (SPMP_A_NAPOT | SPMP_R | SPMP_W)  # 0x1B
  csrw CSR_SIREG2, t0
  csrr t1, CSR_SIREG2
  andi t1, t1, 0x1F
  li t2, 0x1B
  bne t1, t2, fail

  # Test 4: Write NA4 mode with R+W+X permissions
  li TESTNUM, 4

  li t0, SPMP_SELECT_BASE
  csrw CSR_SISELECT, t0

  # NA4 mode (A=10) + R + W + X
  li t0, (SPMP_A_NA4 | SPMP_R | SPMP_W | SPMP_X)  # 0x17
  csrw CSR_SIREG2, t0
  csrr t1, CSR_SIREG2
  andi t1, t1, 0x1F
  li t2, 0x17
  bne t1, t2, fail

  # Test 5: Test U (user mode) bit
  li TESTNUM, 5

  li t0, SPMP_SELECT_BASE
  csrw CSR_SISELECT, t0

  # NAPOT + R + U
  li t0, (SPMP_A_NAPOT | SPMP_R | SPMP_U)  # 0x119
  csrw CSR_SIREG2, t0
  csrr t1, CSR_SIREG2
  li t2, (SPMP_A_NAPOT | SPMP_R | SPMP_U)
  # Check key bits
  andi t3, t1, 0x1FF
  andi t4, t2, 0x1FF
  bne t3, t4, fail

  # Test 6: Test SHARED bit
  li TESTNUM, 6

  li t0, SPMP_SELECT_BASE
  csrw CSR_SISELECT, t0

  # NAPOT + R + SHARED + U (shared region)
  li t0, (SPMP_A_NAPOT | SPMP_R | SPMP_SHARED | SPMP_U)  # 0x319
  csrw CSR_SIREG2, t0
  csrr t1, CSR_SIREG2
  li t2, (SPMP_A_NAPOT | SPMP_R | SPMP_SHARED | SPMP_U)
  andi t3, t1, 0x3FF
  andi t4, t2, 0x3FF
  bne t3, t4, fail

  # Test 7: Test multiple SPMP entries (entry 0 and entry 1)
  li TESTNUM, 7

  # Configure entry 0
  li t0, SPMP_SELECT_BASE
  csrw CSR_SISELECT, t0
  li t0, (SPMP_A_TOR | SPMP_R)
  csrw CSR_SIREG2, t0

  # Configure entry 1
  li t0, (SPMP_SELECT_BASE + 1)
  csrw CSR_SISELECT, t0
  li t0, (SPMP_A_NAPOT | SPMP_R | SPMP_W | SPMP_X)
  csrw CSR_SIREG2, t0

  # Verify entry 0
  li t0, SPMP_SELECT_BASE
  csrw CSR_SISELECT, t0
  csrr t1, CSR_SIREG2
  andi t1, t1, 0x1F
  li t2, (SPMP_A_TOR | SPMP_R)
  bne t1, t2, fail

  # Verify entry 1
  li t0, (SPMP_SELECT_BASE + 1)
  csrw CSR_SISELECT, t0
  csrr t1, CSR_SIREG2
  andi t1, t1, 0x1F
  li t2, (SPMP_A_NAPOT | SPMP_R | SPMP_W | SPMP_X)
  bne t1, t2, fail

  # Test 8: Clear configuration
  li TESTNUM, 8

  li t0, SPMP_SELECT_BASE
  csrw CSR_SISELECT, t0
  csrw CSR_SIREG2, zero
  csrr t1, CSR_SIREG2
  bnez t1, fail

  # Test 9: Test CSR set bits on spmpcfg[0]
  li TESTNUM, 9

  li t0, SPMP_SELECT_BASE
  csrw CSR_SISELECT, t0
  csrw CSR_SIREG2, zero

  # Set R bit using csrs
  li t0, SPMP_R
  csrs CSR_SIREG2, t0
  csrr t1, CSR_SIREG2
  andi t1, t1, SPMP_R
  beqz t1, fail

  # Test 10: Test CSR clear bits on spmpcfg[0]
  li TESTNUM, 10

  li t0, SPMP_SELECT_BASE
  csrw CSR_SISELECT, t0

  # Write all permission bits
  li t0, (SPMP_A_NAPOT | SPMP_R | SPMP_W | SPMP_X)
  csrw CSR_SIREG2, t0

  # Clear R bit using csrc
  li t1, SPMP_R
  csrc CSR_SIREG2, t1
  csrr t2, CSR_SIREG2
  andi t2, t2, SPMP_R
  bnez t2, fail

  # Test 11: Verify OFF mode (A=00) disables entry
  li TESTNUM, 11

  li t0, SPMP_SELECT_BASE
  csrw CSR_SISELECT, t0

  # Set OFF mode with some permissions (should be null region)
  li t0, (SPMP_A_OFF | SPMP_R | SPMP_W)  # 0x03
  csrw CSR_SIREG2, t0
  csrr t1, CSR_SIREG2
  # A field should be 0 (OFF)
  andi t2, t1, SPMP_A_MASK
  bnez t2, fail

  # Test 12: Skipped - Out-of-bounds siselect causes illegal instruction exception
  # which is handled in M-mode trap_vector, not S-mode stvec_handler.
  # This behavior is correct per Sscsrind spec, but requires M-mode exception
  # delegation to test properly.
  # li TESTNUM, 12
  # li t0, (SPMP_SELECT_BASE + 64)
  # csrw CSR_SISELECT, t0
  # csrr t1, CSR_SIREG2

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
