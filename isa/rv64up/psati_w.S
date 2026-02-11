# See LICENSE for license details.

#*****************************************************************************
# psati_w.S
#-----------------------------------------------------------------------------
#
# Test psati.w instruction (packed saturate immediate word, RV64 only).
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV64U
RVTEST_CODE_BEGIN

  #-------------------------------------------------------------
  # Basic tests - psati.w saturates each word to imm+1 bits (signed)
  #-------------------------------------------------------------

  # psati.w rd, rs1, imm5
  # Saturates each 32-bit element to signed (imm+1)-bit range

  # Test case 1: No saturation needed (value fits in 16 bits signed: -32768 to 32767)
  # rs1 = 0x0000000500000005 (5 in each word)
  # imm = 15 (saturate to 16 bits: -32768 to 32767)
  # Expected: 0x0000000500000005 (no change)
  TEST_CASE( 2, x14, 0x0000000500000005, li a1, 0x0000000500000005; psati.w x14, a1, 15 );

  # Test case 2: Positive saturation (value > max for 16 bits signed)
  # rs1 = 0x0001000000010000 (65536 in each word)
  # imm = 15 (saturate to 16 bits: max = 32767)
  # Expected: 0x00007fff00007fff (saturated to 32767)
  TEST_CASE( 3, x14, 0x00007fff00007fff, li a1, 0x0001000000010000; psati.w x14, a1, 15 );

  # Test case 3: Negative saturation (value < min for 16 bits signed)
  # rs1 = 0xffff0000ffff0000 (-65536 in each word)
  # imm = 15 (saturate to 16 bits: min = -32768)
  # Expected: 0xffff8000ffff8000 (-32768 in each word)
  TEST_CASE( 4, x14, 0xffff8000ffff8000, li a1, 0xffff0000ffff0000; psati.w x14, a1, 15 );

  # Test case 4: Zero remains zero
  TEST_CASE( 5, x14, 0x0000000000000000, li a1, 0x0000000000000000; psati.w x14, a1, 15 );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END


