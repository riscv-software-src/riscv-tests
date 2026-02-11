# See LICENSE for license details.

#*****************************************************************************
# pli_h.S
#-----------------------------------------------------------------------------
#
# Test pli.h instruction (packed load immediate halfword).
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV64U
RVTEST_CODE_BEGIN

  #-------------------------------------------------------------
  # Basic tests - pli.h loads 10-bit signed immediate to all halfword elements
  #-------------------------------------------------------------

  # pli.h rd, imm10
  TEST_CASE( 2, x14, 0x0001000100010001, li x14, 0; pli.h x14, 1 );
  TEST_CASE( 3, x14, 0x0000000000000000, li x14, -1; pli.h x14, 0 );
  TEST_CASE( 4, x14, 0x01ff01ff01ff01ff, li x14, 0; pli.h x14, 511 );
  TEST_CASE( 5, x14, 0xffffffffffffffff, li x14, 0; pli.h x14, -1 );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END

