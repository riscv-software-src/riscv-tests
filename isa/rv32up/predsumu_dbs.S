# See LICENSE for license details.

#*****************************************************************************
# predsumu_dbs.S
#-----------------------------------------------------------------------------
#
# Test predsumu.dbs instruction (packed reduction sum, double-word byte, unsigned).
# RV32 only: rd = rs2 + sum(zero-extended bytes from rs1 register pair)
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV32U
RVTEST_CODE_BEGIN

  #-------------------------------------------------------------
  # Arithmetic tests
  #-------------------------------------------------------------

  # predsumu.dbs rd, rs1
  # rd = rs2 + sum of 8 unsigned bytes from rs1 register pair (x10/x11)

  # Test case 1: All small positive bytes
  # rs1 pair: low=0x01020304 (1+2+3+4=10), high=0x05060708 (5+6+7+8=26)
  # Total sum = 36 = 0x24, rs2 = 0, result = 0x24
  TEST_CASE( 2, x14, 0x00000024, \
    li x10, 0x01020304; \
    li x11, 0x05060708; \
    li x12, 0x00000000; \
    predsumu.dbs x14, x10, x12 );

  # Test case 2: With initial accumulator
  # rs1 pair: low=0x01020304, high=0x05060708
  # sum = 36, rs2 = 100 = 0x64, result = 136 = 0x88
  TEST_CASE( 3, x14, 0x00000088, \
    li x10, 0x01020304; \
    li x11, 0x05060708; \
    li x12, 0x00000064; \
    predsumu.dbs x14, x10, x12 );

  # Test case 3: Max unsigned bytes (0xFF = 255)
  # rs1 pair: low=0xFFFFFFFF (255*4=1020), high=0xFFFFFFFF (255*4=1020)
  # Total sum = 2040 = 0x7F8, rs2 = 0, result = 0x7F8
  TEST_CASE( 4, x14, 0x000007F8, \
    li x10, 0xFFFFFFFF; \
    li x11, 0xFFFFFFFF; \
    li x12, 0x00000000; \
    predsumu.dbs x14, x10, x12 );

  # Test case 4: Mixed values
  # rs1 pair: low=0x10203040 (16+32+48+64=160), high=0x50607080 (80+96+112+128=416)
  # Total sum = 576 = 0x240, rs2 = 0, result = 0x240
  TEST_CASE( 5, x14, 0x00000240, \
    li x10, 0x10203040; \
    li x11, 0x50607080; \
    li x12, 0x00000000; \
    predsumu.dbs x14, x10, x12 );

  # Test case 5: All zeros
  TEST_CASE( 6, x14, 0x00000000, \
    li x10, 0x00000000; \
    li x11, 0x00000000; \
    li x12, 0x00000000; \
    predsumu.dbs x14, x10, x12 );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END

