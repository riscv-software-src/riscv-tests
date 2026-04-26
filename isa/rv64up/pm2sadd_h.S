# See LICENSE for license details.

#*****************************************************************************
# pm2sadd_h.S
#-----------------------------------------------------------------------------
#
# Test pm2sadd.h instruction.
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV64U
RVTEST_CODE_BEGIN

  #-------------------------------------------------------------
  # Arithmetic tests
  #-------------------------------------------------------------

  # pm2sadd.h: packed multiply 2-way subtract-add for halfwords
  # rd = rd + (rs1[odd] * rs2[odd]) - (rs1[even] * rs2[even]) for each 32-bit segment
  # Test: 0x00000010 + (0x0004 * 0x0005) - (0x0002 * 0x0003) = 0x10 + 0x14 - 0x06 = 0x0000001E
  TEST_CASE( 2, x14, 0x0000001e0000001e, \
    li x14, 0x0000001000000010; \
    li a1, 0x0002000400020004; \
    li a2, 0x0003000500030005; \
    pm2sadd.h x14, a1, a2 );

  # Test: 0x00000000 + (0x0001 * 0x0001) - (0x0001 * 0x0001) = 0x00 + 0x01 - 0x01 = 0x00000000
  TEST_CASE( 3, x14, 0x0000000000000000, \
    li x14, 0x0000000000000000; \
    li a1, 0x0001000100010001; \
    li a2, 0x0001000100010001; \
    pm2sadd.h x14, a1, a2 );

  # Test: 0x00000005 + (0x0020 * 0x0020) - (0x0010 * 0x0010) = 0x05 + 0x400 - 0x100 = 0x00000305
  TEST_CASE( 4, x14, 0x0000030500000305, \
    li x14, 0x0000000500000005; \
    li a1, 0x0010002000100020; \
    li a2, 0x0010002000100020; \
    pm2sadd.h x14, a1, a2 );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END

