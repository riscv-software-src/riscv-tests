# See LICENSE for license details.

#*****************************************************************************
# pm2suba_h.S
#-----------------------------------------------------------------------------
#
# Test pm2suba.h instruction.
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV64U
RVTEST_CODE_BEGIN

  #-------------------------------------------------------------
  # Arithmetic tests
  #-------------------------------------------------------------

  # pm2suba.h: packed multiply 2-way subtract accumulate for halfwords
  # rd = rd - sum(rs1[i] * rs2[i]) for each 32-bit segment (with accumulator)
  # Test: 0x00000100 - (0x0002 * 0x0003) - (0x0004 * 0x0005) = 0x100 - 0x06 - 0x14 = 0x000000E6
  TEST_CASE( 2, x14, 0x000000e6000000e6, \
    li x14, 0x0000010000000100; \
    li a1, 0x0002000400020004; \
    li a2, 0x0003000500030005; \
    pm2suba.h x14, a1, a2 );

  # Test: 0x00000010 - (0x0001 * 0x0001) - (0x0001 * 0x0001) = 0x10 - 0x01 - 0x01 = 0x0000000E
  TEST_CASE( 3, x14, 0x0000000e0000000e, \
    li x14, 0x0000001000000010; \
    li a1, 0x0001000100010001; \
    li a2, 0x0001000100010001; \
    pm2suba.h x14, a1, a2 );

  # Test: 0x00000500 - (0x0010 * 0x0010) - (0x0010 * 0x0010) = 0x500 - 0x100 - 0x100 = 0x00000300
  TEST_CASE( 4, x14, 0x0000030000000300, \
    li x14, 0x0000050000000500; \
    li a1, 0x0010001000100010; \
    li a2, 0x0010001000100010; \
    pm2suba.h x14, a1, a2 );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END

