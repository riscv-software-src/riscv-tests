# See LICENSE for license details.

#*****************************************************************************
# rev.S
#-----------------------------------------------------------------------------
#
# Test rev instruction (bit reverse, RV64).
# rev rd, rs1 - reverses all 64 bits in rs1
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV64U
RVTEST_CODE_BEGIN

  #-------------------------------------------------------------
  # Arithmetic tests
  #-------------------------------------------------------------

  # Test case 1: All zeros
  TEST_CASE( 2, x14, 0x0000000000000000, li a1, 0x0000000000000000; rev x14, a1 );

  # Test case 2: All ones
  TEST_CASE( 3, x14, 0xffffffffffffffff, li a1, 0xffffffffffffffff; rev x14, a1 );

  # Test case 3: Single bit (bit 0 -> bit 63)
  TEST_CASE( 4, x14, 0x8000000000000000, li a1, 0x0000000000000001; rev x14, a1 );

  # Test case 4: Single bit (bit 63 -> bit 0)
  TEST_CASE( 5, x14, 0x0000000000000001, li a1, 0x8000000000000000; rev x14, a1 );

  # Test case 5: Alternating pattern
  # 0x5555555555555555 -> 0xaaaaaaaaaaaaaaaa
  TEST_CASE( 6, x14, 0xaaaaaaaaaaaaaaaa, li a1, 0x5555555555555555; rev x14, a1 );

  # Test case 6: Reverse alternating pattern
  # 0xaaaaaaaaaaaaaaaa -> 0x5555555555555555
  TEST_CASE( 7, x14, 0x5555555555555555, li a1, 0xaaaaaaaaaaaaaaaa; rev x14, a1 );

  # Test case 7: 0x123456789abcdef0 reversed
  # 0x0f7b3d591e6a2c48
  TEST_CASE( 8, x14, 0x0f7b3d591e6a2c48, li a1, 0x123456789abcdef0; rev x14, a1 );

  # Test case 8: 0xdeadbeefcafebabe reversed
  # 0x7d5d7f53f77db57b
  TEST_CASE( 9, x14, 0x7d5d7f53f77db57b, li a1, 0xdeadbeefcafebabe; rev x14, a1 );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END


