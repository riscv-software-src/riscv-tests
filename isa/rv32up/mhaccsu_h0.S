# See LICENSE for license details.

#*****************************************************************************
# mhaccsu_h0.S
#-----------------------------------------------------------------------------
#
# Test mhaccsu.h0 instruction.
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV32U
RVTEST_CODE_BEGIN

  #-------------------------------------------------------------
  # Arithmetic tests
  #-------------------------------------------------------------

  # mhaccsu.h0: rd = rd + (sext_48(rs1) * zext_48(rs2[15:0]))[47:16]
  # Test: 0 + ((0x10000000 * 0x10)[47:16]) = 0 + 0x10000 = 0x10000
  TEST_CASE( 2, x14, 0x10000, li x14, 0; li a1, 0x10000000; li a2, 0x10; mhaccsu.h0 x14, a1, a2 );

  # Test: 5 + ((0x20000000 * 0x10)[47:16]) = 5 + 0x20000 = 0x20005
  TEST_CASE( 3, x14, 0x20005, li x14, 5; li a1, 0x20000000; li a2, 0x10; mhaccsu.h0 x14, a1, a2 );

  # Test: 10 + ((0x30000000 * 0x10)[47:16]) = 10 + 0x30000 = 0x3000A
  TEST_CASE( 4, x14, 0x3000A, li x14, 10; li a1, 0x30000000; li a2, 0x10; mhaccsu.h0 x14, a1, a2 );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END

