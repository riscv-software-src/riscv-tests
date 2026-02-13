# See LICENSE for license details.

#*****************************************************************************
# pm2addu_h.S
#-----------------------------------------------------------------------------
#
# Test pm2addu.h instruction.
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV64U
RVTEST_CODE_BEGIN

  #-------------------------------------------------------------
  # Arithmetic tests
  #-------------------------------------------------------------

  # pm2addu.h: packed multiply 2-way add (unsigned*unsigned) for halfwords (NON-accumulating)
  # rd = (unsigned(rs1.h0) * unsigned(rs2.h0)) + (unsigned(rs1.h1) * unsigned(rs2.h1))

  # Test: (0x0004 * 0x0005) + (0x0002 * 0x0003) = 0x14 + 0x06 = 0x0000001A
  TEST_CASE( 2, x14, 0x0000001a0000001a, \
    li x14, 0x0000001000000010; \
    li a1, 0x0002000400020004; \
    li a2, 0x0003000500030005; \
    pm2addu.h x14, a1, a2 );

  # Test: (1*1) + (1*1) = 0x00000002
  TEST_CASE( 3, x14, 0x0000000200000002, \
    li x14, 0x0000000000000000; \
    li a1, 0x0001000100010001; \
    li a2, 0x0001000100010001; \
    pm2addu.h x14, a1, a2 );

  # Test: (0x0010 * 0x0010) + (0x0010 * 0x0010) = 0x100 + 0x100 = 0x00000200
  TEST_CASE( 4, x14, 0x0000020000000200, \
    li x14, 0x0000000500000005; \
    li a1, 0x0010001000100010; \
    li a2, 0x0010001000100010; \
    pm2addu.h x14, a1, a2 );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END
