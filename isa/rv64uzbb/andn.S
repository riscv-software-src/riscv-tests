# See LICENSE for license details.

#*****************************************************************************
# andn.S
#-----------------------------------------------------------------------------
#
# Test and instruction.
# This test is forked from and.S
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV64U
RVTEST_CODE_BEGIN

  #-------------------------------------------------------------
  # Logical tests
  #-------------------------------------------------------------

  TEST_RR_OP( 2, andn, 0xfffffffff000f000, 0xffffffffff00ff00, 0x000000000f0f0f0f );
  TEST_RR_OP( 3, andn, 0x000000000f000f00, 0x000000000ff00ff0, 0xfffffffff0f0f0f0 );
  TEST_RR_OP( 4, andn, 0x0000000000f000f0, 0x0000000000ff00ff, 0x000000000f0f0f0f );
  TEST_RR_OP( 5, andn, 0x00000000000f000f, 0xfffffffff00ff00f, 0xfffffffff0f0f0f0 );

#if __riscv_xlen == 64
  TEST_RR_OP( 50, andn, 0x0f000f000f000f00, 0x0ff00ff00ff00ff0, 0xf0f0f0f0f0f0f0f0 );
  TEST_RR_OP( 51, andn, 0x00f000f000f000f0, 0x00ff00ff00ff00ff, 0x0f0f0f0f0f0f0f0f );
  TEST_RR_OP( 52, andn, 0x000f000f000f000f, 0xf00ff00ff00ff00f, 0xf0f0f0f0f0f0f0f0 );
#endif

  #-------------------------------------------------------------
  # Source/Destination tests
  #-------------------------------------------------------------

  TEST_RR_SRC1_EQ_DEST( 6, andn, 0xfffffffff000f000, 0xffffffffff00ff00, 0x000000000f0f0f0f );
  TEST_RR_SRC2_EQ_DEST( 7, andn, 0x000000000f000f00, 0x000000000ff00ff0, 0xfffffffff0f0f0f0 );
  TEST_RR_SRC12_EQ_DEST( 8, andn, 0x0000000000000000, 0xffffffffff00ff00 );

  #-------------------------------------------------------------
  # Bypassing tests
  #-------------------------------------------------------------

  TEST_RR_DEST_BYPASS( 9,  0, andn, 0xfffffffff000f000, 0xffffffffff00ff00, 0x000000000f0f0f0f );
  TEST_RR_DEST_BYPASS( 10, 1, andn, 0x000000000f000f00, 0x000000000ff00ff0, 0xfffffffff0f0f0f0 );
  TEST_RR_DEST_BYPASS( 11, 2, andn, 0x0000000000f000f0, 0x0000000000ff00ff, 0x000000000f0f0f0f );

  TEST_RR_SRC12_BYPASS( 12, 0, 0, andn, 0xfffffffff000f000, 0xffffffffff00ff00, 0x000000000f0f0f0f );
  TEST_RR_SRC12_BYPASS( 13, 0, 1, andn, 0x000000000f000f00, 0x000000000ff00ff0, 0xfffffffff0f0f0f0 );
  TEST_RR_SRC12_BYPASS( 14, 0, 2, andn, 0x0000000000f000f0, 0x0000000000ff00ff, 0x000000000f0f0f0f );
  TEST_RR_SRC12_BYPASS( 15, 1, 0, andn, 0xfffffffff000f000, 0xffffffffff00ff00, 0x000000000f0f0f0f );
  TEST_RR_SRC12_BYPASS( 16, 1, 1, andn, 0x000000000f000f00, 0x000000000ff00ff0, 0xfffffffff0f0f0f0 );
  TEST_RR_SRC12_BYPASS( 17, 2, 0, andn, 0x0000000000f000f0, 0x0000000000ff00ff, 0x000000000f0f0f0f );

  TEST_RR_SRC21_BYPASS( 18, 0, 0, andn, 0xfffffffff000f000, 0xffffffffff00ff00, 0x000000000f0f0f0f );
  TEST_RR_SRC21_BYPASS( 19, 0, 1, andn, 0x000000000f000f00, 0x000000000ff00ff0, 0xfffffffff0f0f0f0 );
  TEST_RR_SRC21_BYPASS( 20, 0, 2, andn, 0x0000000000f000f0, 0x0000000000ff00ff, 0x000000000f0f0f0f );
  TEST_RR_SRC21_BYPASS( 21, 1, 0, andn, 0xfffffffff000f000, 0xffffffffff00ff00, 0x000000000f0f0f0f );
  TEST_RR_SRC21_BYPASS( 22, 1, 1, andn, 0x000000000f000f00, 0x000000000ff00ff0, 0xfffffffff0f0f0f0 );
  TEST_RR_SRC21_BYPASS( 23, 2, 0, andn, 0x0000000000f000f0, 0x0000000000ff00ff, 0x000000000f0f0f0f );

  TEST_RR_ZEROSRC1( 24, andn, 0, 0xffffffffff00ff00 );
  TEST_RR_ZEROSRC2( 25, andn, 0x0000000000ff00ff, 0x0000000000ff00ff );
  TEST_RR_ZEROSRC12( 26, andn, 0 );
  TEST_RR_ZERODEST( 27, andn, 0x0000000011111111, 0x0000000022222222 );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END
