# See LICENSE for license details.

#*****************************************************************************
# pwsubu_h.S
#-----------------------------------------------------------------------------
#
# Test pwsubu.h instruction (packed unsigned widening halfword subtract, RV32 only).
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV32U
RVTEST_CODE_BEGIN

  #-------------------------------------------------------------
  # Arithmetic tests
  #-------------------------------------------------------------

  # pwsubu.h rd, rs1, rs2
  # Packed unsigned widening subtract: 16-bit to 32-bit, unsigned
  # rd_pair[i] = zero_ext(rs1[i]) - zero_ext(rs2[i])

  # Test case 1: Simple widening subtract
  TEST_CASE( 2, x14, 0x00000002, \
    li x10, 0x00030003; \
    li x12, 0x00010001; \
    pwsubu.h x14, x10, x12 );
  TEST_CASE( 3, x15, 0x00000002, nop );

  # Test case 2: Unsigned subtract with high values
  # 0xFFFF - 0x0001 = 0x0000FFFE (unsigned)
  TEST_CASE( 4, x14, 0x0000FFFE, \
    li x10, 0xFFFFFFFF; \
    li x12, 0x00010001; \
    pwsubu.h x14, x10, x12 );
  TEST_CASE( 5, x15, 0x0000FFFE, nop );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END

