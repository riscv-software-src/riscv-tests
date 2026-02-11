# See LICENSE for license details.

#*****************************************************************************
# psa_dhx.S
#-----------------------------------------------------------------------------
#
# Test psa.dhx instruction (packed cross sub-add halfword, double-word, RV32 only).
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV32U
RVTEST_CODE_BEGIN

  #-------------------------------------------------------------
  # Arithmetic tests
  #-------------------------------------------------------------

  # psa.dhx rd, rs1, rs2 (per spec PSA.DHX -> PSA.HX)
  # Even halfword (low):  s1.lo + s2.hi
  # Odd  halfword (high): s1.hi - s2.lo

  # Test case 1: Simple cross sub-add
  # rs1 word = 0x00040008 (hi=0x0004, lo=0x0008)
  # rs2 word = 0x00020004 (hi=0x0002, lo=0x0004)
  # Even = 0x0008 + 0x0002 = 0x000a
  # Odd  = 0x0004 - 0x0004 = 0x0000
  # Word = 0x0000000a
  TEST_CASE( 2, x14, 0x0000000a, \
    li x10, 0x00040008; \
    li x11, 0x00040008; \
    li x12, 0x00020004; \
    li x13, 0x00020004; \
    psa.dhx x14, x10, x12 );
  TEST_CASE( 3, x15, 0x0000000a, nop );

  # Test case 2: Zero - Zero = Zero
  TEST_CASE( 4, x14, 0x00000000, \
    li x10, 0x00000000; \
    li x11, 0x00000000; \
    li x12, 0x00000000; \
    li x13, 0x00000000; \
    psa.dhx x14, x10, x12 );
  TEST_CASE( 5, x15, 0x00000000, nop );

  # Test case 3: Same values in rs1 and rs2
  # rs1 word = 0x00040004 (hi=lo=0x0004)
  # rs2 word = 0x00020002 (hi=lo=0x0002)
  # Even = 0x0004 + 0x0002 = 0x0006
  # Odd  = 0x0004 - 0x0002 = 0x0002
  # Word = 0x00020006
  TEST_CASE( 6, x14, 0x00020006, \
    li x10, 0x00040004; \
    li x11, 0x00040004; \
    li x12, 0x00020002; \
    li x13, 0x00020002; \
    psa.dhx x14, x10, x12 );
  TEST_CASE( 7, x15, 0x00020006, nop );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END

