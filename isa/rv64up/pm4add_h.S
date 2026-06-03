# See LICENSE for license details.

#*****************************************************************************
# pm4add_h.S
#-----------------------------------------------------------------------------
#
# Test pm4add.h instruction (packed multiply 4-way add halfword, RV64 only).
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV64U
RVTEST_CODE_BEGIN

  #-------------------------------------------------------------
  # Arithmetic tests
  #-------------------------------------------------------------

  # pm4add.h: packed multiply 4-way add for halfwords
  # rd = sum(rs1[i] * rs2[i]) for four 16-bit halfwords -> 64-bit result

  # Test: (1*2) + (2*3) + (3*4) + (4*5) = 2 + 6 + 12 + 20 = 40 = 0x28
  TEST_CASE( 2, x14, 0x0000000000000028, \
    li x14, 0x0000000000000000; \
    li a1, 0x0001000200030004; \
    li a2, 0x0002000300040005; \
    pm4add.h x14, a1, a2 );

  # Test: (1*1) + (1*1) + (1*1) + (1*1) = 4
  TEST_CASE( 3, x14, 0x0000000000000004, \
    li x14, 0x0000000000000000; \
    li a1, 0x0001000100010001; \
    li a2, 0x0001000100010001; \
    pm4add.h x14, a1, a2 );

  # Test: (0x10*0x10) + (0x10*0x10) + (0x10*0x10) + (0x10*0x10) = 0x100*4 = 0x400
  TEST_CASE( 4, x14, 0x0000000000000400, \
    li x14, 0x0000000000000000; \
    li a1, 0x0010001000100010; \
    li a2, 0x0010001000100010; \
    pm4add.h x14, a1, a2 );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END

