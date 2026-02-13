# See LICENSE for license details.

#*****************************************************************************
# pnsrli_h.S
#-----------------------------------------------------------------------------
#
# Test pnsrli.h instruction (packed narrow shift right logical immediate halfword, RV32 only).
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV32U
RVTEST_CODE_BEGIN

  # pnsrli.h rd, rs1, imm
  # Narrows 32-bit packed elements to 16-bit by shifting right logical by immediate
  # Uses rs1 register pair (rs1, rs1+1) as 64-bit input

  # Test case 1: Shift right by 1 (0x00020000 >> 1 = 0x00010000, narrowed to 0x0001)
  TEST_CASE( 2, x14, 0x00010001, \
    li x10, 0x00020000; \
    li x11, 0x00020000; \
    pnsrli.h x14, x10, 1 );

  # Test case 2: Shift right logical (no sign extension: 0xFFFF0000 >> 8 = 0x00FFFF00, narrowed to 0xFF00)
  TEST_CASE( 3, x14, 0xff00ff00, \
    li x10, 0xffff0000; \
    li x11, 0xffff0000; \
    pnsrli.h x14, x10, 8 );

  # Test case 3: Shift right by 16 (0x00010000 >> 16 = 0x00000001, narrowed to 0x0001)
  TEST_CASE( 4, x14, 0x00010001, \
    li x10, 0x00010000; \
    li x11, 0x00010000; \
    pnsrli.h x14, x10, 16 );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN
  TEST_DATA
RVTEST_DATA_END

