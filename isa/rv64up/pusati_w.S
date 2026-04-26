# See LICENSE for license details.

#*****************************************************************************
# pusati_w.S
#-----------------------------------------------------------------------------
#
# Test pusati.w instruction (packed unsigned saturate immediate word, RV64 only).
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV64U
RVTEST_CODE_BEGIN

  #-------------------------------------------------------------
  # Basic tests - pusati.w saturates each word to imm+1 bits (unsigned)
  #-------------------------------------------------------------

  # pusati.w rd, rs1, imm5
  # Saturates each 32-bit element to unsigned (imm+1)-bit range
  # Negative values saturate to 0, positive values saturate to max

  # Test case 1: No saturation needed (value fits in 16 bits unsigned: 0 to 32767)
  # rs1 = 0x0000000500000005 (5 in each word)
  # imm = 15 (saturate to 16 bits: 0 to 32767)
  # Expected: 0x0000000500000005 (no change)
  TEST_CASE( 2, x14, 0x0000000500000005, li a1, 0x0000000500000005; pusati.w x14, a1, 15 );

  # Test case 2: Positive saturation (value > max for 16 bits unsigned)
  # rs1 = 0x0001000000010000 (65536 in each word)
  # imm = 15 (saturate to 16 bits: max = 32767)
  # Expected: 0x00007fff00007fff (saturated to 32767)
  TEST_CASE( 3, x14, 0x00007fff00007fff, li a1, 0x0001000000010000; pusati.w x14, a1, 15 );

  # Test case 3: Negative values saturate to 0
  # rs1 = 0xffffffffffffffff (-1 in each word when signed)
  # imm = 15 (saturate to 16 bits)
  # Expected: 0x0000000000000000 (negative saturates to 0)
  TEST_CASE( 4, x14, 0x0000000000000000, li a1, 0xffffffffffffffff; pusati.w x14, a1, 15 );

  # Test case 4: Zero remains zero
  TEST_CASE( 5, x14, 0x0000000000000000, li a1, 0x0000000000000000; pusati.w x14, a1, 15 );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END


