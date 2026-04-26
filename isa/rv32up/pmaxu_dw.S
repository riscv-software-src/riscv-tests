# See LICENSE for license details.

#*****************************************************************************
# pmaxu_dw.S
#-----------------------------------------------------------------------------
#
# Test pmaxu.dw instruction (packed max word unsigned, double-word, RV32 only).
# Note: rd and rs1 must be even registers (register-pair constraint).
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV32U
RVTEST_CODE_BEGIN

  #-------------------------------------------------------------
  # Arithmetic tests
  #-------------------------------------------------------------

  # pmaxu.dw rd, rs1, rs2
  # Performs packed unsigned max: rd[i] = max(rs1[i], rs2[i]) for each word (64-bit)
  # rd and rs1 must be even registers

  # Test case 1: Simple max (5 vs 3 = 5)
  TEST_CASE( 2, x14, 0x00000005, \
    li x10, 0x00000005; \
    li x11, 0x00000005; \
    li x12, 0x00000003; \
    li x13, 0x00000003; \
    pmaxu.dw x14, x10, x12 );
  TEST_CASE( 3, x15, 0x00000005, nop );

  # Test case 2: Reverse order (3 vs 5 = 5)
  TEST_CASE( 4, x14, 0x00000005, \
    li x10, 0x00000003; \
    li x11, 0x00000003; \
    li x12, 0x00000005; \
    li x13, 0x00000005; \
    pmaxu.dw x14, x10, x12 );
  TEST_CASE( 5, x15, 0x00000005, nop );

  # Test case 3: Equal values
  TEST_CASE( 6, x14, 0x00000004, \
    li x10, 0x00000004; \
    li x11, 0x00000004; \
    li x12, 0x00000004; \
    li x13, 0x00000004; \
    pmaxu.dw x14, x10, x12 );
  TEST_CASE( 7, x15, 0x00000004, nop );

  # Test case 4: Unsigned comparison (0xffffffff vs 0x00000001 = 0xffffffff)
  TEST_CASE( 8, x14, 0xffffffff, \
    li x10, 0xffffffff; \
    li x11, 0xffffffff; \
    li x12, 0x00000001; \
    li x13, 0x00000001; \
    pmaxu.dw x14, x10, x12 );
  TEST_CASE( 9, x15, 0xffffffff, nop );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END

