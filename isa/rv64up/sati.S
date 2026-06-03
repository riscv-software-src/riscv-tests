# See LICENSE for license details.

#*****************************************************************************
# sati64.S
#-----------------------------------------------------------------------------
#
# Test sati64 instruction (saturate signed 64-bit, RV64 only).
# Assembler mnemonic: sati
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV64U
RVTEST_CODE_BEGIN

  # sati rd, rs1, width
  # rd = SAT(width, (int64_t)rs1)
  # (assembler encodes width-1 in the uimm6 field)

  # Test case 1: No saturation needed (value fits in width bits signed)
  # width=8 means 8-bit signed range [-128, 127]
  TEST_CASE( 2, x14, 0x0000000000000050, \
      TEST_VXSAT_CLEAR; \
    li x10, 0x0000000000000050; \
    sati x14, x10, 8 );
  TEST_VXSAT_CHECK( 0 );

  # Test case 2: Positive saturation
  # width=8 means 8-bit signed max = 127 (0x7F)
  TEST_CASE( 3, x14, 0x000000000000007F, \
      TEST_VXSAT_CLEAR; \
    li x10, 0x0000000000001000; \
    sati x14, x10, 8 );
  TEST_VXSAT_CHECK( 1 );

  # Test case 3: Negative saturation
  # width=8 means 8-bit signed min = -128 (0xFFFFFFFFFFFFFF80)
  TEST_CASE( 4, x14, 0xFFFFFFFFFFFFFF80, \
      TEST_VXSAT_CLEAR; \
    li x10, 0xFFFFFFFFFFFFF000; \
    sati x14, x10, 8 );
  TEST_VXSAT_CHECK( 1 );

  # Test case 4: Wider saturation
  # width=32 means 32-bit signed range
  TEST_CASE( 5, x14, 0x000000007FFFFFFF, \
      TEST_VXSAT_CLEAR; \
    li x10, 0x0000000100000000; \
    sati x14, x10, 32 );
  TEST_VXSAT_CHECK( 1 );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN
  TEST_DATA
RVTEST_DATA_END

