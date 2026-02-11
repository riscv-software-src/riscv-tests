# See LICENSE for license details.

#*****************************************************************************
# pli_b.S
#-----------------------------------------------------------------------------
#
# Test pli.b instruction (packed load immediate byte).
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV64U
RVTEST_CODE_BEGIN

  #-------------------------------------------------------------
  # Basic tests - pli.b loads 8-bit immediate to all byte elements
  #-------------------------------------------------------------

  # pli.b rd, imm8
  TEST_CASE( 2, x14, 0x0101010101010101, li x14, 0; pli.b x14, 1 );
  TEST_CASE( 3, x14, 0x0000000000000000, li x14, -1; pli.b x14, 0 );
  TEST_CASE( 4, x14, 0x7f7f7f7f7f7f7f7f, li x14, 0; pli.b x14, 127 );
  TEST_CASE( 5, x14, 0xffffffffffffffff, li x14, 0; pli.b x14, -1 );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END

