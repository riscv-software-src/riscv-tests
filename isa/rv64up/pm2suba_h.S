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

  # pm2suba.h: accumulating multiply add-low / subtract-high for halfwords
  # rd = X[rd] + (rs1.h0 * rs2.h0) - (rs1.h1 * rs2.h1) per 32-bit lane

  # Test: 0x100 + 0x14 - 0x06 = 0x0000010E
  TEST_CASE( 2, x14, 0x0000010e0000010e, \
    li x14, 0x0000010000000100; \
    li a1, 0x0002000400020004; \
    li a2, 0x0003000500030005; \
    pm2suba.h x14, a1, a2 );

  # Test: 0x10 + 1 - 1 = 0x10
  TEST_CASE( 3, x14, 0x0000001000000010, \
    li x14, 0x0000001000000010; \
    li a1, 0x0001000100010001; \
    li a2, 0x0001000100010001; \
    pm2suba.h x14, a1, a2 );

  # Test: 0x500 + 0x100 - 0x100 = 0x500
  TEST_CASE( 4, x14, 0x0000050000000500, \
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
