# See LICENSE for license details.

#*****************************************************************************
# pwaddu_b.S
#-----------------------------------------------------------------------------
#
# Test pwaddu.b instruction (packed unsigned widening byte add, RV32 only).
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV32U
RVTEST_CODE_BEGIN

  #-------------------------------------------------------------
  # Arithmetic tests
  #-------------------------------------------------------------

  # pwaddu.b rd, rs1, rs2
  # Packed unsigned widening add: 8-bit to 16-bit, unsigned
  # rd_pair[i] = zero_ext(rs1[i]) + zero_ext(rs2[i])

  # Test case 1: Simple widening add
  TEST_CASE( 2, x14, 0x00030003, \
    li x10, 0x01010101; \
    li x12, 0x02020202; \
    pwaddu.b x14, x10, x12 );
  TEST_CASE( 3, x15, 0x00030003, nop );

  # Test case 2: Unsigned add with high values
  # 0xFF + 0x01 = 0x0100 (unsigned)
  TEST_CASE( 4, x14, 0x01000100, \
    li x10, 0xFFFFFFFF; \
    li x12, 0x01010101; \
    pwaddu.b x14, x10, x12 );
  TEST_CASE( 5, x15, 0x01000100, nop );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END

