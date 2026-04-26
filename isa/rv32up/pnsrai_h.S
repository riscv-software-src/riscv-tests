# See LICENSE for license details.

#*****************************************************************************
# pnsrai_h.S
#-----------------------------------------------------------------------------
#
# Test pnsrai.h instruction (packed narrow shift right arithmetic immediate halfword, RV32 only).
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV32U
RVTEST_CODE_BEGIN

  # pnsrai.h rd, rs1, imm
  # Narrows 32-bit packed elements to 16-bit by shifting right arithmetic by immediate
  # Uses rs1 register pair (rs1, rs1+1) as 64-bit input

  # Test case 1: Shift right by 1
  TEST_CASE( 2, x14, 0x00010001, \
    li x10, 0x00020000; \
    li x11, 0x00020000; \
    pnsrai.h x14, x10, 1 );

  # Test case 2: Shift right with sign extension
  TEST_CASE( 3, x14, 0xff00ff00, \
    li x10, 0xffff0000; \
    li x11, 0xffff0000; \
    pnsrai.h x14, x10, 8 );

  # Test case 3: Shift right by 16
  TEST_CASE( 4, x14, 0x00010001, \
    li x10, 0x00010000; \
    li x11, 0x00010000; \
    pnsrai.h x14, x10, 16 );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN
  TEST_DATA
RVTEST_DATA_END

