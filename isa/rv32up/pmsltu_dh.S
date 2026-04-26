# See LICENSE for license details.

#*****************************************************************************
# pmsltu_dh.S
#-----------------------------------------------------------------------------
#
# Test pmsltu.dh instruction (packed mask set less than halfword unsigned, double-word, RV32 only).
# Note: rd and rs1 must be even registers (register-pair constraint).
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV32U
RVTEST_CODE_BEGIN

  #-------------------------------------------------------------
  # Arithmetic tests
  #-------------------------------------------------------------

  # pmsltu.dh rd, rs1, rs2
  # Sets mask: rd[i] = 0xffff if rs1[i] < rs2[i] (unsigned), else 0x0000 for each halfword (64-bit)
  # rd and rs1 must be even registers

  # Test case 1: rs1 < rs2 - all masks set (3 < 5)
  TEST_CASE( 2, x14, 0xffffffff, \
    li x10, 0x00030003; \
    li x11, 0x00030003; \
    li x12, 0x00050005; \
    li x13, 0x00050005; \
    pmsltu.dh x14, x10, x12 );
  TEST_CASE( 3, x15, 0xffffffff, nop );

  # Test case 2: rs1 > rs2 - no masks set (5 > 3)
  TEST_CASE( 4, x14, 0x00000000, \
    li x10, 0x00050005; \
    li x11, 0x00050005; \
    li x12, 0x00030003; \
    li x13, 0x00030003; \
    pmsltu.dh x14, x10, x12 );
  TEST_CASE( 5, x15, 0x00000000, nop );

  # Test case 3: rs1 == rs2 - no masks set
  TEST_CASE( 6, x14, 0x00000000, \
    li x10, 0x00040004; \
    li x11, 0x00040004; \
    li x12, 0x00040004; \
    li x13, 0x00040004; \
    pmsltu.dh x14, x10, x12 );
  TEST_CASE( 7, x15, 0x00000000, nop );

  # Test case 4: Unsigned comparison (0x0001 < 0xffff = true, since 1 < 65535)
  TEST_CASE( 8, x14, 0xffffffff, \
    li x10, 0x00010001; \
    li x11, 0x00010001; \
    li x12, 0xffffffff; \
    li x13, 0xffffffff; \
    pmsltu.dh x14, x10, x12 );
  TEST_CASE( 9, x15, 0xffffffff, nop );

  # Test case 5: Unsigned comparison (0xffff < 0x0001 = false, since 65535 > 1)
  TEST_CASE( 10, x14, 0x00000000, \
    li x10, 0xffffffff; \
    li x11, 0xffffffff; \
    li x12, 0x00010001; \
    li x13, 0x00010001; \
    pmsltu.dh x14, x10, x12 );
  TEST_CASE( 11, x15, 0x00000000, nop );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END

