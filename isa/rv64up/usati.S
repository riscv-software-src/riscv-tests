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

  # usati rd, rs1, imm
  # rd = USAT(imm+1, (int64_t)rs1)

  # Test case 1: No saturation needed (value fits in imm+1 bits unsigned)
  # imm=7 means 8-bit unsigned range [0, 255]
  TEST_CASE( 2, x14, 0x0000000000000050, \
    li x10, 0x0000000000000050; \
    usati x14, x10, 7 );

  # Test case 2: Positive saturation
  # imm=7 means 8-bit unsigned max = 255 (0xFF)
  TEST_CASE( 3, x14, 0x00000000000000FF, \
    li x10, 0x0000000000001000; \
    usati x14, x10, 7 );

  # Test case 3: Negative value saturates to 0
  TEST_CASE( 4, x14, 0x0000000000000000, \
    li x10, 0xFFFFFFFFFFFFF000; \
    usati x14, x10, 7 );

  # Test case 4: Large immediate (31 bits)
  # imm=31 means 32-bit unsigned max = 0xFFFFFFFF
  TEST_CASE( 5, x14, 0x00000000FFFFFFFF, \
    li x10, 0x0000000100000000; \
    usati x14, x10, 31 );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN
  TEST_DATA
RVTEST_DATA_END

