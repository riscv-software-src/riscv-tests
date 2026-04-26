# See LICENSE for license details.

#*****************************************************************************
# predsum_dhs.S
#-----------------------------------------------------------------------------
#
# Test predsum.dhs instruction (packed reduction sum, double-word halfword, signed).
# RV32 only: rd = rs2 + sum(sign-extended halfwords from rs1 register pair)
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV32U
RVTEST_CODE_BEGIN

  #-------------------------------------------------------------
  # Arithmetic tests
  #-------------------------------------------------------------

  # predsum.dhs rd, rs1
  # rd = rs2 + sum of 4 signed halfwords from rs1 register pair (x10/x11)

  # Test case 1: All positive halfwords
  # rs1 pair: low=0x00010002 (1+2=3), high=0x00030004 (3+4=7)
  # Total sum = 10, rs2 = 0, result = 10 = 0x0A
  TEST_CASE( 2, x14, 0x0000000A, \
    li x10, 0x00010002; \
    li x11, 0x00030004; \
    li x12, 0x00000000; \
    predsum.dhs x14, x10, x12 );

  # Test case 2: With initial accumulator
  # rs1 pair: low=0x00010002, high=0x00030004
  # sum = 10, rs2 = 100 = 0x64, result = 110 = 0x6E
  TEST_CASE( 3, x14, 0x0000006E, \
    li x10, 0x00010002; \
    li x11, 0x00030004; \
    li x12, 0x00000064; \
    predsum.dhs x14, x10, x12 );

  # Test case 3: Negative halfwords (signed)
  # rs1 pair: low=0xFFFFFFFF (-1*2=-2), high=0xFFFFFFFF (-1*2=-2)
  # Total sum = -4, rs2 = 0, result = -4 = 0xFFFFFFFC
  TEST_CASE( 4, x14, 0xFFFFFFFC, \
    li x10, 0xFFFFFFFF; \
    li x11, 0xFFFFFFFF; \
    li x12, 0x00000000; \
    predsum.dhs x14, x10, x12 );

  # Test case 4: Mixed positive and negative halfwords
  # rs1 pair: low=0x0001FFFF (1-1=0), high=0x0002FFFE (2-2=0)
  # Total sum = 0, rs2 = 20, result = 20 = 0x14
  TEST_CASE( 5, x14, 0x00000014, \
    li x10, 0x0001FFFF; \
    li x11, 0x0002FFFE; \
    li x12, 0x00000014; \
    predsum.dhs x14, x10, x12 );

  # Test case 5: All zeros
  TEST_CASE( 6, x14, 0x00000000, \
    li x10, 0x00000000; \
    li x11, 0x00000000; \
    li x12, 0x00000000; \
    predsum.dhs x14, x10, x12 );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END

