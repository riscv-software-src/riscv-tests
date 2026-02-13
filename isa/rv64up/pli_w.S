# See LICENSE for license details.

#*****************************************************************************
# pli_w.S
#-----------------------------------------------------------------------------
#
# Test pli.w instruction (packed load immediate word, RV64 only).
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV64U
RVTEST_CODE_BEGIN

  #-------------------------------------------------------------
  # Basic tests - pli.w loads 10-bit signed immediate to all word elements
  #-------------------------------------------------------------

  # pli.w rd, imm10
  # Load 10-bit signed immediate to both 32-bit word elements

  TEST_CASE( 2, x14, 0x0000000100000001, li x14, 0; pli.w x14, 1 );
  TEST_CASE( 3, x14, 0x0000000000000000, li x14, -1; pli.w x14, 0 );
  TEST_CASE( 4, x14, 0x000001ff000001ff, li x14, 0; pli.w x14, 511 );
  TEST_CASE( 5, x14, 0xffffffffffffffff, li x14, 0; pli.w x14, -1 );
  TEST_CASE( 6, x14, 0xfffffe00fffffe00, li x14, 0; pli.w x14, -512 );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END

