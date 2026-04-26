# See LICENSE for license details.

#*****************************************************************************
# pwsubu_b.S
#-----------------------------------------------------------------------------
#
# Test pwsubu.b instruction (packed unsigned widening byte subtract, RV32 only).
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV32U
RVTEST_CODE_BEGIN

  #-------------------------------------------------------------
  # Arithmetic tests
  #-------------------------------------------------------------

  # pwsubu.b rd, rs1, rs2
  # Packed unsigned widening subtract: 8-bit to 16-bit, unsigned
  # rd_pair[i] = zero_ext(rs1[i]) - zero_ext(rs2[i])

  # Test case 1: Simple widening subtract
  TEST_CASE( 2, x14, 0x00020002, \
    li x10, 0x03030303; \
    li x12, 0x01010101; \
    pwsubu.b x14, x10, x12 );
  TEST_CASE( 3, x15, 0x00020002, nop );

  # Test case 2: Unsigned subtract with high values
  # 0xFF - 0x01 = 0x00FE (unsigned)
  TEST_CASE( 4, x14, 0x00FE00FE, \
    li x10, 0xFFFFFFFF; \
    li x12, 0x01010101; \
    pwsubu.b x14, x10, x12 );
  TEST_CASE( 5, x15, 0x00FE00FE, nop );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END

