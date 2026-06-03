# See LICENSE for license details.

#*****************************************************************************
# pm4adda_h.S
#-----------------------------------------------------------------------------
#
# Test pm4adda.h instruction (packed multiply 4-way add accumulate halfword, RV64 only).
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV64U
RVTEST_CODE_BEGIN

  #-------------------------------------------------------------
  # Arithmetic tests
  #-------------------------------------------------------------

  # pm4adda.h: packed multiply 4-way add accumulate for halfwords
  # rd = rd + sum(rs1[i] * rs2[i]) for four 16-bit halfwords -> 64-bit result

  # Test: 0x10 + (1*2) + (2*3) + (3*4) + (4*5) = 16 + 2 + 6 + 12 + 20 = 56 = 0x38
  TEST_CASE( 2, x14, 0x0000000000000038, \
    li x14, 0x0000000000000010; \
    li a1, 0x0001000200030004; \
    li a2, 0x0002000300040005; \
    pm4adda.h x14, a1, a2 );

  # Test: 0x100 + (1*1) + (1*1) + (1*1) + (1*1) = 256 + 4 = 260 = 0x104
  TEST_CASE( 3, x14, 0x0000000000000104, \
    li x14, 0x0000000000000100; \
    li a1, 0x0001000100010001; \
    li a2, 0x0001000100010001; \
    pm4adda.h x14, a1, a2 );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END

