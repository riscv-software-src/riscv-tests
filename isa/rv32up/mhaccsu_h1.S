# See LICENSE for license details.

#*****************************************************************************
# mhaccsu_h1.S
#-----------------------------------------------------------------------------
#
# Test mhaccsu.h1 instruction.
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV32U
RVTEST_CODE_BEGIN

  #-------------------------------------------------------------
  # Arithmetic tests
  #-------------------------------------------------------------

  # mhaccsu.h1: rd = rd + (rs1(signed) * rs2[31:16](unsigned))[63:32]
  # Test: 0 + high32(0x10000000 * 0x10) = 0 + 1 = 1 (rs2 = 0x00100000)
  TEST_CASE( 2, x14, 1, li x14, 0; li a1, 0x10000000; li a2, 0x00100000; mhaccsu.h1 x14, a1, a2 );

  # Test: 5 + high32(0x20000000 * 0x10) = 5 + 2 = 7
  TEST_CASE( 3, x14, 7, li x14, 5; li a1, 0x20000000; li a2, 0x00100000; mhaccsu.h1 x14, a1, a2 );

  # Test: 10 + high32(0x30000000 * 0x10) = 10 + 3 = 13
  TEST_CASE( 4, x14, 13, li x14, 10; li a1, 0x30000000; li a2, 0x00100000; mhaccsu.h1 x14, a1, a2 );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END

