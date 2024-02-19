# See LICENSE for license details.

#*****************************************************************************
# xnor.S
#-----------------------------------------------------------------------------
#
# Test xnor instruction.
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV64U
RVTEST_CODE_BEGIN

  #-------------------------------------------------------------
  # Logical tests
  #-------------------------------------------------------------

  TEST_RR_OP( 2, xnor, 0x000000000ff00ff0, 0xffffffffff00ff00, 0x000000000f0f0f0f );
  TEST_RR_OP( 3, xnor, 0x0000000000ff00ff, 0x000000000ff00ff0, 0xfffffffff0f0f0f0 );
  TEST_RR_OP( 4, xnor, 0xfffffffff00ff00f, 0x0000000000ff00ff, 0x000000000f0f0f0f );
  TEST_RR_OP( 5, xnor, 0xffffffffff00ff00, 0xfffffffff00ff00f, 0xfffffffff0f0f0f0 );

#if __riscv_xlen == 64
  TEST_RR_OP( 50, xnor, 0x00ff00ff00ff00ff, 0x0ff00ff00ff00ff0, 0xf0f0f0f0f0f0f0f0 );
  TEST_RR_OP( 51, xnor, 0xf00ff00ff00ff00f, 0x00ff00ff00ff00ff, 0x0f0f0f0f0f0f0f0f );
  TEST_RR_OP( 52, xnor, 0xff00ff00ff00ff00, 0xf00ff00ff00ff00f, 0xf0f0f0f0f0f0f0f0 );
#endif

  #-------------------------------------------------------------
  # Source/Destination tests
  #-------------------------------------------------------------

  TEST_RR_SRC1_EQ_DEST( 6, xnor, 0x000000000ff00ff0, 0xffffffffff00ff00, 0x000000000f0f0f0f );
  TEST_RR_SRC2_EQ_DEST( 7, xnor, 0x000000000ff00ff0, 0xffffffffff00ff00, 0x000000000f0f0f0f );
  TEST_RR_SRC12_EQ_DEST( 8, xnor, 0xffffffffffffffff, 0xffffffffff00ff00 );

  #-------------------------------------------------------------
  # Bypassing tests
  #-------------------------------------------------------------

  TEST_RR_DEST_BYPASS( 9,  0, xnor, 0x000000000ff00ff0, 0xffffffffff00ff00, 0x000000000f0f0f0f );
  TEST_RR_DEST_BYPASS( 10, 1, xnor, 0x0000000000ff00ff, 0x000000000ff00ff0, 0xfffffffff0f0f0f0 );
  TEST_RR_DEST_BYPASS( 11, 2, xnor, 0xfffffffff00ff00f, 0x0000000000ff00ff, 0x000000000f0f0f0f );

  TEST_RR_SRC12_BYPASS( 12, 0, 0, xnor, 0x000000000ff00ff0, 0xffffffffff00ff00, 0x000000000f0f0f0f );
  TEST_RR_SRC12_BYPASS( 13, 0, 1, xnor, 0x0000000000ff00ff, 0x000000000ff00ff0, 0xfffffffff0f0f0f0 );
  TEST_RR_SRC12_BYPASS( 14, 0, 2, xnor, 0xfffffffff00ff00f, 0x0000000000ff00ff, 0x000000000f0f0f0f );
  TEST_RR_SRC12_BYPASS( 15, 1, 0, xnor, 0x000000000ff00ff0, 0xffffffffff00ff00, 0x000000000f0f0f0f );
  TEST_RR_SRC12_BYPASS( 16, 1, 1, xnor, 0x0000000000ff00ff, 0x000000000ff00ff0, 0xfffffffff0f0f0f0 );
  TEST_RR_SRC12_BYPASS( 17, 2, 0, xnor, 0xfffffffff00ff00f, 0x0000000000ff00ff, 0x000000000f0f0f0f );

  TEST_RR_SRC21_BYPASS( 18, 0, 0, xnor, 0x000000000ff00ff0, 0xffffffffff00ff00, 0x000000000f0f0f0f );
  TEST_RR_SRC21_BYPASS( 19, 0, 1, xnor, 0x0000000000ff00ff, 0x000000000ff00ff0, 0xfffffffff0f0f0f0 );
  TEST_RR_SRC21_BYPASS( 20, 0, 2, xnor, 0xfffffffff00ff00f, 0x0000000000ff00ff, 0x000000000f0f0f0f );
  TEST_RR_SRC21_BYPASS( 21, 1, 0, xnor, 0x000000000ff00ff0, 0xffffffffff00ff00, 0x000000000f0f0f0f );
  TEST_RR_SRC21_BYPASS( 22, 1, 1, xnor, 0x0000000000ff00ff, 0x000000000ff00ff0, 0xfffffffff0f0f0f0 );
  TEST_RR_SRC21_BYPASS( 23, 2, 0, xnor, 0xfffffffff00ff00f, 0x0000000000ff00ff, 0x000000000f0f0f0f );

  TEST_RR_ZEROSRC1( 24, xnor, 0x0000000000ff00ff, 0xffffffffff00ff00 );
  TEST_RR_ZEROSRC2( 25, xnor, 0xffffffffff00ff00, 0x0000000000ff00ff );
  TEST_RR_ZEROSRC12( 26, xnor, -1 );
  TEST_RR_ZERODEST( 27, xnor, 0x0000000011111111, 0x0000000022222222 );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END
