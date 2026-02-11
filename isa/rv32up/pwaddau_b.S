# See LICENSE for license details.

#*****************************************************************************
# pwaddau_b.S
#-----------------------------------------------------------------------------
#
# Test pwaddau.b instruction (packed unsigned widening byte add accumulate, RV32 only).
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV32U
RVTEST_CODE_BEGIN

  #-------------------------------------------------------------
  # Arithmetic tests
  #-------------------------------------------------------------

  # pwaddau.b rd, rs1, rs2
  # Packed unsigned widening add accumulate: rd_pair[i] += zero_ext(rs1[i]) + zero_ext(rs2[i])

  # Test case 1: Accumulate with initial value
  TEST_CASE( 2, x14, 0x00130013, \
    li x14, 0x00100010; \
    li x15, 0x00100010; \
    li x10, 0x01010101; \
    li x12, 0x02020202; \
    pwaddau.b x14, x10, x12 );
  TEST_CASE( 3, x15, 0x00130013, nop );

  # Test case 2: Unsigned accumulate with high values
  # 0x0010 + 0xFF + 0x01 = 0x0110
  TEST_CASE( 4, x14, 0x01100110, \
    li x14, 0x00100010; \
    li x15, 0x00100010; \
    li x10, 0xFFFFFFFF; \
    li x12, 0x01010101; \
    pwaddau.b x14, x10, x12 );
  TEST_CASE( 5, x15, 0x01100110, nop );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END

