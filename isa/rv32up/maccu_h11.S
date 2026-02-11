# See LICENSE for license details.

#*****************************************************************************
# maccu_h11.S
#-----------------------------------------------------------------------------
#
# Test maccu.h11 instruction.
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV32U
RVTEST_CODE_BEGIN

  #-------------------------------------------------------------
  # Arithmetic tests
  #-------------------------------------------------------------

  # maccu.h11: rd = rd + rs1[31:16](unsigned) * rs2[31:16](unsigned)
  # Test: 10 + 2 * 3 = 16 (rs1 = 0x00020000, rs2 = 0x00030000)
  TEST_CASE( 2, x14, 16, li x14, 10; li a1, 0x00020000; li a2, 0x00030000; maccu.h11 x14, a1, a2 );

  # Test: 0 + 4 * 5 = 20
  TEST_CASE( 3, x14, 20, li x14, 0; li a1, 0x00040000; li a2, 0x00050000; maccu.h11 x14, a1, a2 );

  # Test: 5 + 100 * 10 = 1005
  TEST_CASE( 4, x14, 1005, li x14, 5; li a1, 0x00640000; li a2, 0x000a0000; maccu.h11 x14, a1, a2 );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END

