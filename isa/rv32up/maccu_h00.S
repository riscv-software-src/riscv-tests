# See LICENSE for license details.

#*****************************************************************************
# maccu_h00.S
#-----------------------------------------------------------------------------
#
# Test maccu.h00 instruction.
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV32U
RVTEST_CODE_BEGIN

  #-------------------------------------------------------------
  # Arithmetic tests
  #-------------------------------------------------------------

  # maccu.h00: rd = rd + rs1[15:0](unsigned) * rs2[15:0](unsigned)
  # Test: 10 + 2 * 3 = 16
  TEST_CASE( 2, x14, 16, li x14, 10; li a1, 2; li a2, 3; maccu.h00 x14, a1, a2 );

  # Test: 0 + 4 * 5 = 20
  TEST_CASE( 3, x14, 20, li x14, 0; li a1, 4; li a2, 5; maccu.h00 x14, a1, a2 );

  # Test: 5 + 100 * 10 = 1005
  TEST_CASE( 4, x14, 1005, li x14, 5; li a1, 100; li a2, 10; maccu.h00 x14, a1, a2 );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END

