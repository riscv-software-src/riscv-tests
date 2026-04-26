# See LICENSE for license details.

#*****************************************************************************
# rev.S
#-----------------------------------------------------------------------------
#
# Test rev instruction (bit reverse, RV32).
# rev rd, rs1 - reverses all bits in rs1
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV32U
RVTEST_CODE_BEGIN

  #-------------------------------------------------------------
  # Arithmetic tests
  #-------------------------------------------------------------

  # Test case 1: All zeros
  TEST_CASE( 2, x14, 0x00000000, li a1, 0x00000000; rev x14, a1 );

  # Test case 2: All ones
  TEST_CASE( 3, x14, 0xffffffff, li a1, 0xffffffff; rev x14, a1 );

  # Test case 3: Single bit (bit 0 -> bit 31)
  TEST_CASE( 4, x14, 0x80000000, li a1, 0x00000001; rev x14, a1 );

  # Test case 4: Single bit (bit 31 -> bit 0)
  TEST_CASE( 5, x14, 0x00000001, li a1, 0x80000000; rev x14, a1 );

  # Test case 5: Alternating pattern
  # 0x55555555 = 0101_0101_... -> 1010_1010_... = 0xaaaaaaaa
  TEST_CASE( 6, x14, 0xaaaaaaaa, li a1, 0x55555555; rev x14, a1 );

  # Test case 6: Reverse alternating pattern
  # 0xaaaaaaaa = 1010_1010_... -> 0101_0101_... = 0x55555555
  TEST_CASE( 7, x14, 0x55555555, li a1, 0xaaaaaaaa; rev x14, a1 );

  # Test case 7: 0x12345678 reversed
  # 0x12345678 = 0001_0010_0011_0100_0101_0110_0111_1000
  # reversed  = 0001_1110_0110_1010_0010_1100_0100_1000 = 0x1e6a2c48
  TEST_CASE( 8, x14, 0x1e6a2c48, li a1, 0x12345678; rev x14, a1 );

  # Test case 8: 0xdeadbeef reversed
  # reversed = 0xf77db57b
  TEST_CASE( 9, x14, 0xf77db57b, li a1, 0xdeadbeef; rev x14, a1 );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END


