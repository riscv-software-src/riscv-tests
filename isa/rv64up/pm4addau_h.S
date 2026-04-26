# See LICENSE for license details.

#*****************************************************************************
# pm4addau_h.S
#-----------------------------------------------------------------------------
#
# Test pm4addau.h instruction (packed multiply 4-way add accumulate unsigned halfword, RV64 only).
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV64U
RVTEST_CODE_BEGIN

  #-------------------------------------------------------------
  # Arithmetic tests
  #-------------------------------------------------------------

  # pm4addau.h: packed multiply 4-way add accumulate unsigned for halfwords
  # rd = rd + sum(zext(rs1[i]) * zext(rs2[i])) for four 16-bit halfwords -> 64-bit result

  # Test: 0x10 + (1*2) + (2*3) + (3*4) + (4*5) = 16 + 2 + 6 + 12 + 20 = 56 = 0x38
  TEST_CASE( 2, x14, 0x0000000000000038, \
    li x14, 0x0000000000000010; \
    li a1, 0x0001000200030004; \
    li a2, 0x0002000300040005; \
    pm4addau.h x14, a1, a2 );

  # Test: 0x100 + (0xFFFF*1) + (1*1) + (1*1) + (1*1) = 256 + 0xFFFF + 3 = 0x10102
  TEST_CASE( 3, x14, 0x0000000000010102, \
    li x14, 0x0000000000000100; \
    li a1, 0xffff000100010001; \
    li a2, 0x0001000100010001; \
    pm4addau.h x14, a1, a2 );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END

