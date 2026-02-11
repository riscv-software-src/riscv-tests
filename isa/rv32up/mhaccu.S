# See LICENSE for license details.

#*****************************************************************************
# mhaccu.S
#-----------------------------------------------------------------------------
#
# Test mhaccu instruction.
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV32U
RVTEST_CODE_BEGIN

  #-------------------------------------------------------------
  # Arithmetic tests
  #-------------------------------------------------------------

  # mhaccu: rd = rd + (rs1(unsigned) * rs2(unsigned))[63:32]
  # Test: 10 + high32(0x10000 * 0x10000) = 10 + 1 = 11
  TEST_CASE( 2, x14, 11, li x14, 10; li a1, 0x10000; li a2, 0x10000; mhaccu x14, a1, a2 );

  # Test: 0 + high32(0x20000 * 0x20000) = 0 + 4 = 4
  TEST_CASE( 3, x14, 4, li x14, 0; li a1, 0x20000; li a2, 0x20000; mhaccu x14, a1, a2 );

  # Test: 5 + high32(0x10000 * 0x30000) = 5 + 3 = 8
  TEST_CASE( 4, x14, 8, li x14, 5; li a1, 0x10000; li a2, 0x30000; mhaccu x14, a1, a2 );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END

