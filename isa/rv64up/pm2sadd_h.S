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

  # pm2sadd.h: packed multiply 2-way Saturating add for halfwords (NON-accumulating)
  # rd = sat32((rs1.h0 * rs2.h0) + (rs1.h1 * rs2.h1)) for each 32-bit lane

  # Test: sat(0x14 + 0x06) = 0x0000001A (no saturation)
  TEST_CASE( 2, x14, 0x0000001a0000001a, \
      TEST_VXSAT_CLEAR; \
    li x14, 0x0000001000000010; \
    li a1, 0x0002000400020004; \
    li a2, 0x0003000500030005; \
    pm2sadd.h x14, a1, a2 );
  TEST_VXSAT_CHECK( 0 );

  # Test: sat(1 + 1) = 0x00000002
  TEST_CASE( 3, x14, 0x0000000200000002, \
      TEST_VXSAT_CLEAR; \
    li x14, 0x0000000000000000; \
    li a1, 0x0001000100010001; \
    li a2, 0x0001000100010001; \
    pm2sadd.h x14, a1, a2 );
  TEST_VXSAT_CHECK( 0 );

  # Test: sat(0x400 + 0x100) = 0x00000500
  TEST_CASE( 4, x14, 0x0000050000000500, \
      TEST_VXSAT_CLEAR; \
    li x14, 0x0000000500000005; \
    li a1, 0x0010002000100020; \
    li a2, 0x0010002000100020; \
    pm2sadd.h x14, a1, a2 );
  TEST_VXSAT_CHECK( 0 );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END
