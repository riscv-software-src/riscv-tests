# See LICENSE for license details.

#*****************************************************************************
# pwaddau_h.S
#-----------------------------------------------------------------------------
#
# Test pwaddau.h instruction (packed unsigned widening halfword add accumulate, RV32 only).
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV32U
RVTEST_CODE_BEGIN

  #-------------------------------------------------------------
  # Arithmetic tests
  #-------------------------------------------------------------

  # pwaddau.h rd, rs1, rs2
  # Packed unsigned widening add accumulate: rd_pair[i] += zero_ext(rs1[i]) + zero_ext(rs2[i])

  # Test case 1: Accumulate with initial value
  TEST_CASE( 2, x14, 0x00000013, \
    li x14, 0x00000010; \
    li x15, 0x00000010; \
    li x10, 0x00010001; \
    li x12, 0x00020002; \
    pwaddau.h x14, x10, x12 );
  TEST_CASE( 3, x15, 0x00000013, nop );

  # Test case 2: Unsigned accumulate with high values
  # 0x00000010 + 0xFFFF + 0x0001 = 0x00010010
  TEST_CASE( 4, x14, 0x00010010, \
    li x14, 0x00000010; \
    li x15, 0x00000010; \
    li x10, 0xFFFFFFFF; \
    li x12, 0x00010001; \
    pwaddau.h x14, x10, x12 );
  TEST_CASE( 5, x15, 0x00010010, nop );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END

