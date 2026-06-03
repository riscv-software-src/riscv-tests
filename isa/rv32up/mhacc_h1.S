# See LICENSE for license details.

#*****************************************************************************
# mhacc_h1.S
#-----------------------------------------------------------------------------
#
# Test mhacc.h1 instruction.
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV32U
RVTEST_CODE_BEGIN

  #-------------------------------------------------------------
  # Arithmetic tests
  #-------------------------------------------------------------

  # mhacc.h1: rd = rd + (sext_48(rs1) * sext_48(rs2[31:16]))[47:16] (signed*signed)
  # Test: 10 + ((0x10000000 * 0x10)[47:16]) = 10 + 0x10000 = 0x1000A (rs2 = 0x00100000 -> h1 = 0x10)
  TEST_CASE( 2, x14, 0x1000A, li x14, 10; li a1, 0x10000000; li a2, 0x00100000; mhacc.h1 x14, a1, a2 );

  # Test: 0 + ((0x20000000 * 0x10)[47:16]) = 0 + 0x20000 = 0x20000
  TEST_CASE( 3, x14, 0x20000, li x14, 0; li a1, 0x20000000; li a2, 0x00100000; mhacc.h1 x14, a1, a2 );

  # Test: 5 + ((0x30000000 * 0x10)[47:16]) = 5 + 0x30000 = 0x30005
  TEST_CASE( 4, x14, 0x30005, li x14, 5; li a1, 0x30000000; li a2, 0x00100000; mhacc.h1 x14, a1, a2 );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END

