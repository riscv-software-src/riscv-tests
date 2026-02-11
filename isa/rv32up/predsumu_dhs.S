# See LICENSE for license details.

#*****************************************************************************
# predsumu_dhs.S
#-----------------------------------------------------------------------------
#
# Test predsumu.dhs instruction (packed reduction sum, double-word halfword, unsigned).
# RV32 only: rd = rs2 + sum(zero-extended halfwords from rs1 register pair)
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV32U
RVTEST_CODE_BEGIN

  #-------------------------------------------------------------
  # Arithmetic tests
  #-------------------------------------------------------------

  # predsumu.dhs rd, rs1
  # rd = rs2 + sum of 4 unsigned halfwords from rs1 register pair (x10/x11)

  # Test case 1: All small positive halfwords
  # rs1 pair: low=0x00010002 (1+2=3), high=0x00030004 (3+4=7)
  # Total sum = 10 = 0x0A, rs2 = 0, result = 0x0A
  TEST_CASE( 2, x14, 0x0000000A, \
    li x10, 0x00010002; \
    li x11, 0x00030004; \
    li x12, 0x00000000; \
    predsumu.dhs x14, x10, x12 );

  # Test case 2: With initial accumulator
  # rs1 pair: low=0x00010002, high=0x00030004
  # sum = 10, rs2 = 100 = 0x64, result = 110 = 0x6E
  TEST_CASE( 3, x14, 0x0000006E, \
    li x10, 0x00010002; \
    li x11, 0x00030004; \
    li x12, 0x00000064; \
    predsumu.dhs x14, x10, x12 );

  # Test case 3: Max unsigned halfwords (0xFFFF = 65535)
  # rs1 pair: low=0xFFFFFFFF (65535*2=131070), high=0xFFFFFFFF (65535*2=131070)
  # Total sum = 262140 = 0x3FFFC, rs2 = 0, result = 0x3FFFC
  TEST_CASE( 4, x14, 0x0003FFFC, \
    li x10, 0xFFFFFFFF; \
    li x11, 0xFFFFFFFF; \
    li x12, 0x00000000; \
    predsumu.dhs x14, x10, x12 );

  # Test case 4: Mixed values
  # rs1 pair: low=0x10002000 (0x1000+0x2000=4096+8192=12288), high=0x30004000 (0x3000+0x4000=12288+16384=28672)
  # Total sum = 40960 = 0xA000, rs2 = 0, result = 0xA000
  TEST_CASE( 5, x14, 0x0000A000, \
    li x10, 0x10002000; \
    li x11, 0x30004000; \
    li x12, 0x00000000; \
    predsumu.dhs x14, x10, x12 );

  # Test case 5: All zeros
  TEST_CASE( 6, x14, 0x00000000, \
    li x10, 0x00000000; \
    li x11, 0x00000000; \
    li x12, 0x00000000; \
    predsumu.dhs x14, x10, x12 );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END

