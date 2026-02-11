# See LICENSE for license details.

#*****************************************************************************
# pmsltu_dw.S
#-----------------------------------------------------------------------------
#
# Test pmsltu.dw instruction (packed mask set less than word unsigned, double-word, RV32 only).
# Note: rd and rs1 must be even registers (register-pair constraint).
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV32U
RVTEST_CODE_BEGIN

  #-------------------------------------------------------------
  # Arithmetic tests
  #-------------------------------------------------------------

  # pmsltu.dw rd, rs1, rs2
  # Sets mask: rd[i] = 0xffffffff if rs1[i] < rs2[i] (unsigned), else 0x00000000 for each word (64-bit)
  # rd and rs1 must be even registers

  # Test case 1: rs1 < rs2 - all masks set (3 < 5)
  TEST_CASE( 2, x14, 0xffffffff, \
    li x10, 0x00000003; \
    li x11, 0x00000003; \
    li x12, 0x00000005; \
    li x13, 0x00000005; \
    pmsltu.dw x14, x10, x12 );
  TEST_CASE( 3, x15, 0xffffffff, nop );

  # Test case 2: rs1 > rs2 - no masks set (5 > 3)
  TEST_CASE( 4, x14, 0x00000000, \
    li x10, 0x00000005; \
    li x11, 0x00000005; \
    li x12, 0x00000003; \
    li x13, 0x00000003; \
    pmsltu.dw x14, x10, x12 );
  TEST_CASE( 5, x15, 0x00000000, nop );

  # Test case 3: rs1 == rs2 - no masks set
  TEST_CASE( 6, x14, 0x00000000, \
    li x10, 0x00000004; \
    li x11, 0x00000004; \
    li x12, 0x00000004; \
    li x13, 0x00000004; \
    pmsltu.dw x14, x10, x12 );
  TEST_CASE( 7, x15, 0x00000000, nop );

  # Test case 4: Unsigned comparison (0x00000001 < 0xffffffff = true)
  TEST_CASE( 8, x14, 0xffffffff, \
    li x10, 0x00000001; \
    li x11, 0x00000001; \
    li x12, 0xffffffff; \
    li x13, 0xffffffff; \
    pmsltu.dw x14, x10, x12 );
  TEST_CASE( 9, x15, 0xffffffff, nop );

  # Test case 5: Unsigned comparison (0xffffffff < 0x00000001 = false)
  TEST_CASE( 10, x14, 0x00000000, \
    li x10, 0xffffffff; \
    li x11, 0xffffffff; \
    li x12, 0x00000001; \
    li x13, 0x00000001; \
    pmsltu.dw x14, x10, x12 );
  TEST_CASE( 11, x15, 0x00000000, nop );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END

