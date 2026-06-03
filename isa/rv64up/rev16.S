# See LICENSE for license details.

#*****************************************************************************
# rev16.S
#-----------------------------------------------------------------------------
#
# Test rev16 instruction (grevi with shamt=48, RV64 only).
# rev16 rd, rs1 - swaps 32-bit halves, then swaps 16-bit halves within each 32-bit
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV64U
RVTEST_CODE_BEGIN

  #-------------------------------------------------------------
  # Arithmetic tests
  #-------------------------------------------------------------

  # Test case 1: All zeros
  TEST_CASE( 2, x14, 0x0000000000000000, li a1, 0x0000000000000000; rev16 x14, a1 );

  # Test case 2: All ones
  TEST_CASE( 3, x14, 0xffffffffffffffff, li a1, 0xffffffffffffffff; rev16 x14, a1 );

  # Test case 3: 0x0102030405060708 -> 0x0708050603040102
  # Step 1: swap 32-bit halves: 0x0506070801020304
  # Step 2: swap 16-bit within each 32-bit: 0x0708050603040102
  TEST_CASE( 4, x14, 0x0708050603040102, li a1, 0x0102030405060708; rev16 x14, a1 );

  # Test case 4: 0xaabbccddeeff0011 -> 0x0011eeffccddaabb
  TEST_CASE( 5, x14, 0x0011eeffccddaabb, li a1, 0xaabbccddeeff0011; rev16 x14, a1 );

  # Test case 5: Symmetric pattern stays same
  # 0x00ff00ff00ff00ff -> 0x00ff00ff00ff00ff
  TEST_CASE( 6, x14, 0x00ff00ff00ff00ff, li a1, 0x00ff00ff00ff00ff; rev16 x14, a1 );

  # Test case 6: 0x123456789abcdef0 -> 0xdef09abc56781234
  TEST_CASE( 7, x14, 0xdef09abc56781234, li a1, 0x123456789abcdef0; rev16 x14, a1 );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END


