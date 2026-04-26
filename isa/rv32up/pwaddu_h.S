# See LICENSE for license details.

#*****************************************************************************
# pwaddu_h.S
#-----------------------------------------------------------------------------
#
# Test pwaddu.h instruction (packed unsigned widening halfword add, RV32 only).
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV32U
RVTEST_CODE_BEGIN

  #-------------------------------------------------------------
  # Arithmetic tests
  #-------------------------------------------------------------

  # pwaddu.h rd, rs1, rs2
  # Packed unsigned widening add: 16-bit to 32-bit, unsigned
  # rd_pair[i] = zero_ext(rs1[i]) + zero_ext(rs2[i])

  # Test case 1: Simple widening add
  TEST_CASE( 2, x14, 0x00000003, \
    li x10, 0x00010001; \
    li x12, 0x00020002; \
    pwaddu.h x14, x10, x12 );
  TEST_CASE( 3, x15, 0x00000003, nop );

  # Test case 2: Unsigned add with high values
  # 0xFFFF + 0x0001 = 0x00010000 (unsigned)
  TEST_CASE( 4, x14, 0x00010000, \
    li x10, 0xFFFFFFFF; \
    li x12, 0x00010001; \
    pwaddu.h x14, x10, x12 );
  TEST_CASE( 5, x15, 0x00010000, nop );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END

