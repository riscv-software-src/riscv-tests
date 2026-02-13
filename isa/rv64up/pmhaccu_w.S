# See LICENSE for license details.

#*****************************************************************************
# pmhaccu_w.S
#-----------------------------------------------------------------------------
#
# Test pmhaccu.w instruction (packed multiply-high accumulate word unsigned, RV64 only).
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV64U
RVTEST_CODE_BEGIN

  #-------------------------------------------------------------
  # Arithmetic tests
  #-------------------------------------------------------------

  # pmhaccu.w: packed multiply-high accumulate unsigned for words
  # rd[i] += (zext(rs1[i]) * zext(rs2[i])) >> 32 for each 32-bit word

  # Test: 0x10 + (0x10000 * 0x10000) >> 32 = 0x10 + 0x01 = 0x11
  TEST_CASE( 2, x14, 0x0000001100000011, \
    li x14, 0x0000001000000010; \
    li a1, 0x0001000000010000; \
    li a2, 0x0001000000010000; \
    pmhaccu.w x14, a1, a2 );

  # Test: 0x00 + (0xFFFFFFFF * 0x2) >> 32 = 0x00 + 0x01 = 0x01
  TEST_CASE( 3, x14, 0x0000000100000001, \
    li x14, 0x0000000000000000; \
    li a1, 0xffffffffffffffff; \
    li a2, 0x0000000200000002; \
    pmhaccu.w x14, a1, a2 );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END

