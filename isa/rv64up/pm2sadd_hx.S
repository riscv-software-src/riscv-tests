# See LICENSE for license details.

#*****************************************************************************
# pm2sadd_hx.S
#-----------------------------------------------------------------------------
#
# Test pm2sadd.hx instruction.
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV64U
RVTEST_CODE_BEGIN

  #-------------------------------------------------------------
  # Arithmetic tests
  #-------------------------------------------------------------

  # pm2sadd.hx: packed multiply 2-way Saturating add (cross) for halfwords (NON-accumulating)
  # rd = sat32((rs1.h0 * rs2.h1) + (rs1.h1 * rs2.h0)) for each 32-bit lane

  # Test: sat(0x0C + 0x0A) = 0x00000016
  TEST_CASE( 2, x14, 0x0000001600000016, \
      TEST_VXSAT_CLEAR; \
    li x14, 0x0000001000000010; \
    li a1, 0x0002000400020004; \
    li a2, 0x0003000500030005; \
    pm2sadd.hx x14, a1, a2 );
  TEST_VXSAT_CHECK( 0 );

  # Test: sat(1 + 1) = 0x00000002
  TEST_CASE( 3, x14, 0x0000000200000002, \
      TEST_VXSAT_CLEAR; \
    li x14, 0x0000000000000000; \
    li a1, 0x0001000100010001; \
    li a2, 0x0001000100010001; \
    pm2sadd.hx x14, a1, a2 );
  TEST_VXSAT_CHECK( 0 );

  # Test: sat(0x200 + 0x200) = 0x00000400
  TEST_CASE( 4, x14, 0x0000040000000400, \
      TEST_VXSAT_CLEAR; \
    li x14, 0x0000000500000005; \
    li a1, 0x0010002000100020; \
    li a2, 0x0010002000100020; \
    pm2sadd.hx x14, a1, a2 );
  TEST_VXSAT_CHECK( 0 );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END
