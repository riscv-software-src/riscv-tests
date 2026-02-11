# See LICENSE for license details.

#*****************************************************************************
# predsum_dbs.S
#-----------------------------------------------------------------------------
#
# Test predsum.dbs instruction (packed reduction sum, double-word byte, signed).
# RV32 only: rd = rs2 + sum(sign-extended bytes from rs1 register pair)
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV32U
RVTEST_CODE_BEGIN

  #-------------------------------------------------------------
  # Arithmetic tests
  #-------------------------------------------------------------

  # predsum.dbs rd, rs1
  # rd = rs2 + sum of 8 signed bytes from rs1 register pair (x10/x11)

  # Test case 1: All positive bytes
  # rs1 pair: low=0x01020304 (1+2+3+4=10), high=0x05060708 (5+6+7+8=26)
  # Total sum = 10 + 26 = 36 = 0x24, rs2 = 0, result = 0x24
  TEST_CASE( 2, x14, 0x00000024, \
    li x10, 0x01020304; \
    li x11, 0x05060708; \
    li x12, 0x00000000; \
    predsum.dbs x14, x10, x12 );

  # Test case 2: With initial accumulator
  # rs1 pair: low=0x01020304, high=0x05060708
  # sum = 36, rs2 = 100 = 0x64, result = 136 = 0x88
  TEST_CASE( 3, x14, 0x00000088, \
    li x10, 0x01020304; \
    li x11, 0x05060708; \
    li x12, 0x00000064; \
    predsum.dbs x14, x10, x12 );

  # Test case 3: Negative bytes (signed)
  # rs1 pair: low=0xFFFFFFFF (-1*4=-4), high=0xFFFFFFFF (-1*4=-4)
  # Total sum = -8, rs2 = 0, result = -8 = 0xFFFFFFF8
  TEST_CASE( 4, x14, 0xFFFFFFF8, \
    li x10, 0xFFFFFFFF; \
    li x11, 0xFFFFFFFF; \
    li x12, 0x00000000; \
    predsum.dbs x14, x10, x12 );

  # Test case 4: Mixed positive and negative bytes
  # rs1 pair: low=0x01FF02FE (1-1+2-2=0), high=0x03FD04FC (3-3+4-4=0)
  # Total sum = 0, rs2 = 10, result = 10 = 0x0A
  TEST_CASE( 5, x14, 0x0000000A, \
    li x10, 0x01FF02FE; \
    li x11, 0x03FD04FC; \
    li x12, 0x0000000A; \
    predsum.dbs x14, x10, x12 );

  # Test case 5: All zeros
  TEST_CASE( 6, x14, 0x00000000, \
    li x10, 0x00000000; \
    li x11, 0x00000000; \
    li x12, 0x00000000; \
    predsum.dbs x14, x10, x12 );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END

