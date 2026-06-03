# See LICENSE for license details.

#*****************************************************************************
# pm2sub_h.S
#-----------------------------------------------------------------------------
#
# Test pm2sub.h instruction.
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV64U
RVTEST_CODE_BEGIN

  #-------------------------------------------------------------
  # Arithmetic tests
  #-------------------------------------------------------------

  # pm2sub.h: packed multiply 2-way subtract for halfwords (NON-accumulating)
  # rd = (rs1.h0 * rs2.h0) - (rs1.h1 * rs2.h1) for each 32-bit lane

  # Test: 0x0004*0x0005 - 0x0002*0x0003 = 0x14 - 0x06 = 0x0000000E
  TEST_CASE( 2, x14, 0x0000000e0000000e, \
    li x14, 0x0000010000000100; \
    li a1, 0x0002000400020004; \
    li a2, 0x0003000500030005; \
    pm2sub.h x14, a1, a2 );

  # Test: 1 - 1 = 0
  TEST_CASE( 3, x14, 0x0000000000000000, \
    li x14, 0x0000001000000010; \
    li a1, 0x0001000100010001; \
    li a2, 0x0001000100010001; \
    pm2sub.h x14, a1, a2 );

  # Test: 0x100 - 0x100 = 0
  TEST_CASE( 4, x14, 0x0000000000000000, \
    li x14, 0x0000050000000500; \
    li a1, 0x0010001000100010; \
    li a2, 0x0010001000100010; \
    pm2sub.h x14, a1, a2 );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END
