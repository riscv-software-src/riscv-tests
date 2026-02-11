# See LICENSE for license details.

#*****************************************************************************
# pm2add_hx.S
#-----------------------------------------------------------------------------
#
# Test pm2add.hx instruction.
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV64U
RVTEST_CODE_BEGIN

  #-------------------------------------------------------------
  # Arithmetic tests
  #-------------------------------------------------------------

  # pm2add.hx: packed multiply 2-way add for halfwords with crossed operands
  # rd = rd + sum(rs1[i] * rs2[crossed_i]) for each 32-bit segment
  # Test: 0x00000010 + (0x0002 * 0x0005) + (0x0004 * 0x0003) = 0x10 + 0x0A + 0x0C = 0x00000026
  TEST_CASE( 2, x14, 0x0000002600000026, \
    li x14, 0x0000001000000010; \
    li a1, 0x0002000400020004; \
    li a2, 0x0003000500030005; \
    pm2add.hx x14, a1, a2 );

  # Test: 0x00000000 + (0x0001 * 0x0001) + (0x0001 * 0x0001) = 0x00 + 0x01 + 0x01 = 0x00000002
  TEST_CASE( 3, x14, 0x0000000200000002, \
    li x14, 0x0000000000000000; \
    li a1, 0x0001000100010001; \
    li a2, 0x0001000100010001; \
    pm2add.hx x14, a1, a2 );

  # Test: 0x00000005 + (0x0010 * 0x0020) + (0x0020 * 0x0010) = 0x05 + 0x200 + 0x200 = 0x00000405
  TEST_CASE( 4, x14, 0x0000040500000405, \
    li x14, 0x0000000500000005; \
    li a1, 0x0010002000100020; \
    li a2, 0x0010002000100020; \
    pm2add.hx x14, a1, a2 );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END

