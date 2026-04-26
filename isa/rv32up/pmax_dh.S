# See LICENSE for license details.

#*****************************************************************************
# pmax_dh.S
#-----------------------------------------------------------------------------
#
# Test pmax.dh instruction (packed max halfword signed, double-word, RV32 only).
# Note: rd and rs1 must be even registers (register-pair constraint).
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV32U
RVTEST_CODE_BEGIN

  #-------------------------------------------------------------
  # Arithmetic tests
  #-------------------------------------------------------------

  # pmax.dh rd, rs1, rs2
  # Performs packed signed max: rd[i] = max(rs1[i], rs2[i]) for each halfword (64-bit)
  # rd and rs1 must be even registers

  # Test case 1: Simple max (5 vs 3 = 5)
  TEST_CASE( 2, x14, 0x00050005, \
    li x10, 0x00050005; \
    li x11, 0x00050005; \
    li x12, 0x00030003; \
    li x13, 0x00030003; \
    pmax.dh x14, x10, x12 );
  TEST_CASE( 3, x15, 0x00050005, nop );

  # Test case 2: Reverse order (3 vs 5 = 5)
  TEST_CASE( 4, x14, 0x00050005, \
    li x10, 0x00030003; \
    li x11, 0x00030003; \
    li x12, 0x00050005; \
    li x13, 0x00050005; \
    pmax.dh x14, x10, x12 );
  TEST_CASE( 5, x15, 0x00050005, nop );

  # Test case 3: Equal values
  TEST_CASE( 6, x14, 0x00040004, \
    li x10, 0x00040004; \
    li x11, 0x00040004; \
    li x12, 0x00040004; \
    li x13, 0x00040004; \
    pmax.dh x14, x10, x12 );
  TEST_CASE( 7, x15, 0x00040004, nop );

  # Test case 4: Mixed positive and negative (signed: -1 vs 1 = 1)
  # 0xffff = -1, 0x0001 = 1
  TEST_CASE( 8, x14, 0x00010001, \
    li x10, 0xffffffff; \
    li x11, 0xffffffff; \
    li x12, 0x00010001; \
    li x13, 0x00010001; \
    pmax.dh x14, x10, x12 );
  TEST_CASE( 9, x15, 0x00010001, nop );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END

