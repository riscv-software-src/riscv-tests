# See LICENSE for license details.

#*****************************************************************************
# usati64.S
#-----------------------------------------------------------------------------
#
# Test usati64 instruction (saturate unsigned 64-bit, RV64 only).
# Assembler mnemonic: usati
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV64U
RVTEST_CODE_BEGIN

  # usati rd, rs1, width
  # rd = USAT(width, (int64_t)rs1)
  # (assembler encodes width-1 in the uimm6 field)

  # Test case 1: No saturation needed (value fits in width bits unsigned)
  # width=8 means 8-bit unsigned range [0, 255]
  TEST_CASE( 2, x14, 0x0000000000000050, \
      TEST_VXSAT_CLEAR; \
    li x10, 0x0000000000000050; \
    usati x14, x10, 8 );
  TEST_VXSAT_CHECK( 0 );

  # Test case 2: Positive saturation
  # width=8 means 8-bit unsigned max = 255 (0xFF)
  TEST_CASE( 3, x14, 0x00000000000000FF, \
      TEST_VXSAT_CLEAR; \
    li x10, 0x0000000000001000; \
    usati x14, x10, 8 );
  TEST_VXSAT_CHECK( 1 );

  # Test case 3: Negative value saturates to 0
  TEST_CASE( 4, x14, 0x0000000000000000, \
      TEST_VXSAT_CLEAR; \
    li x10, 0xFFFFFFFFFFFFF000; \
    usati x14, x10, 8 );
  TEST_VXSAT_CHECK( 1 );

  # Test case 4: Wider saturation
  # width=32 means 32-bit unsigned max = 0xFFFFFFFF
  TEST_CASE( 5, x14, 0x00000000FFFFFFFF, \
      TEST_VXSAT_CLEAR; \
    li x10, 0x0000000100000000; \
    usati x14, x10, 32 );
  TEST_VXSAT_CHECK( 1 );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN
  TEST_DATA
RVTEST_DATA_END

