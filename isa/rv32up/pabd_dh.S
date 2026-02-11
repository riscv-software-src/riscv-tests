# See LICENSE for license details.

#*****************************************************************************
# pabd_dh.S
#-----------------------------------------------------------------------------
#
# Test pabd.dh instruction (Packed Absolute Difference - Double-word Halfword, RV32 only).
# Note: rd and rs1 must be even registers (register-pair constraint).
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV32U
RVTEST_CODE_BEGIN

  # pabd.dh rd, rs1, rs2
  # Computes |rs1[i] - rs2[i]| for each signed halfword element
  # rd and rs1 must be even registers

  # Test case 2: Basic test - small positive differences
  # rs1 = 0x0004000300020001, rs2 = 0x0002000100000000
  # Result low: 0x00020001, Result high: 0x00020002
  TEST_CASE( 2, x14, 0x00020001, \
    li x10, 0x00020001; \
    li x11, 0x00040003; \
    li x12, 0x00000000; \
    li x13, 0x00020001; \
    pabd.dh x14, x10, x12 );
  TEST_CASE( 3, x15, 0x00020002, nop );

  # Test case 4: Both operands same - result should be all zeros
  TEST_CASE( 4, x14, 0x00000000, \
    li x10, 0x12345678; \
    li x11, 0x12345678; \
    li x12, 0x12345678; \
    li x13, 0x12345678; \
    pabd.dh x14, x10, x12 );
  TEST_CASE( 5, x15, 0x00000000, nop );

  # Test case 6: Saturation case: -32768 - 0 = -32768, saturates to 32767
  # rs1 = 0x8000800080008000 (all -32768), rs2 = 0x0000000000000000
  TEST_CASE( 6, x14, 0x7fff7fff, \
    li x10, 0x80008000; \
    li x11, 0x80008000; \
    li x12, 0x00000000; \
    li x13, 0x00000000; \
    pabd.dh x14, x10, x12 );
  TEST_CASE( 7, x15, 0x7fff7fff, nop );

  # Test case 8: Another saturation case: 0 - (-32768) saturates to 32767
  TEST_CASE( 8, x14, 0x7fff7fff, \
    li x10, 0x00000000; \
    li x11, 0x00000000; \
    li x12, 0x80008000; \
    li x13, 0x80008000; \
    pabd.dh x14, x10, x12 );
  TEST_CASE( 9, x15, 0x7fff7fff, nop );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END

