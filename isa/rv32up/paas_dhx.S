# See LICENSE for license details.

#*****************************************************************************
# paas_dhx.S
#-----------------------------------------------------------------------------
#
# Test paas.dhx instruction (packed averaging cross add-sub halfword, double-word, RV32 only).
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV32U
RVTEST_CODE_BEGIN

  #-------------------------------------------------------------
  # Arithmetic tests
  #-------------------------------------------------------------

  # paas.dhx rd, rs1, rs2 (per spec PAAS.DHX -> PAAS.HX)
  # Even halfword (low):  (s1.lo - s2.hi) >> 1
  # Odd  halfword (high): (s1.hi + s2.lo) >> 1

  # Test case 1: Simple averaging cross add-sub
  # rs1 word = 0x00040008 (hi=0x0004, lo=0x0008)
  # rs2 word = 0x00020004 (hi=0x0002, lo=0x0004)
  # Even = (0x0008 - 0x0002) >> 1 = 0x0006 >> 1 = 0x0003
  # Odd  = (0x0004 + 0x0004) >> 1 = 0x0008 >> 1 = 0x0004
  # Word = 0x00040003
  TEST_CASE( 2, x14, 0x00040003, \
    li x10, 0x00040008; \
    li x11, 0x00040008; \
    li x12, 0x00020004; \
    li x13, 0x00020004; \
    paas.dhx x14, x10, x12 );
  TEST_CASE( 3, x15, 0x00040003, nop );

  # Test case 2: Zero averaging = Zero
  TEST_CASE( 4, x14, 0x00000000, \
    li x10, 0x00000000; \
    li x11, 0x00000000; \
    li x12, 0x00000000; \
    li x13, 0x00000000; \
    paas.dhx x14, x10, x12 );
  TEST_CASE( 5, x15, 0x00000000, nop );

  # Test case 3: Same values in rs1 and rs2
  # rs1 word = 0x00040004 (hi=lo=0x0004)
  # rs2 word = 0x00020002 (hi=lo=0x0002)
  # Even = (0x0004 - 0x0002) >> 1 = 0x0001
  # Odd  = (0x0004 + 0x0002) >> 1 = 0x0003
  # Word = 0x00030001
  TEST_CASE( 6, x14, 0x00030001, \
    li x10, 0x00040004; \
    li x11, 0x00040004; \
    li x12, 0x00020002; \
    li x13, 0x00020002; \
    paas.dhx x14, x10, x12 );
  TEST_CASE( 7, x15, 0x00030001, nop );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END

