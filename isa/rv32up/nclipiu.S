# See LICENSE for license details.

#*****************************************************************************
# nclipiu.S
#-----------------------------------------------------------------------------
#
# Test nclipiu instruction (narrow clip immediate unsigned, RV32 only).
# Takes 64-bit input from register pair (rs1, rs1+1), shifts right logical,
# saturates to unsigned 32-bit, outputs result to rd.
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV32U
RVTEST_CODE_BEGIN

  # nclipiu rd, rs1, imm
  # rd = USAT32((uint64_t)(rs1_pair) >> imm)

  # Test case 1: No saturation needed
  # Input: 0x00000000_00000010, shift by 1 = 8
  TEST_CASE( 2, x14, 0x00000008, \
    li x10, 0x00000010; \
    li x11, 0x00000000; \
    nclipiu x14, x10, 1 );

  # Test case 2: Positive saturation
  # Input: 0x00000001_00000000 (2^32), shift by 0 = saturate to 0xFFFFFFFF
  TEST_CASE( 3, x14, 0xFFFFFFFF, \
    li x10, 0x00000000; \
    li x11, 0x00000001; \
    nclipiu x14, x10, 0 );

  # Test case 3: Large value saturation
  # Input: 0xFFFFFFFF_FFFFFFFF, shift by 0 = saturate to 0xFFFFFFFF
  TEST_CASE( 4, x14, 0xFFFFFFFF, \
    li x10, 0xFFFFFFFF; \
    li x11, 0xFFFFFFFF; \
    nclipiu x14, x10, 0 );

  # Test case 4: Shift reduces value to fit
  # Input: 0x00000000_80000000, shift by 31 = 1 (fits)
  TEST_CASE( 5, x14, 0x00000001, \
    li x10, 0x80000000; \
    li x11, 0x00000000; \
    nclipiu x14, x10, 31 );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN
  TEST_DATA
RVTEST_DATA_END

