# See LICENSE for license details.

#*****************************************************************************
# packh.S
#-----------------------------------------------------------------------------
#
# Test packh instruction.
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV32U
RVTEST_CODE_BEGIN

  #-------------------------------------------------------------
  # Arithmetic tests
  #-------------------------------------------------------------

  TEST_RR_OP( 2, packh, 0x0000F078, 0x12345678, 0x9ABCDEF0 );
  TEST_RR_OP( 3, packh, 0x0000FFFF, 0xFFFFFFFF, 0xFFFFFFFF );
  TEST_RR_OP( 4, packh, 0x00000000, 0x00000000, 0x00000000 );
  TEST_RR_OP( 5, packh, 0x0000CDAB, 0x000000AB, 0x000000CD );
  TEST_RR_OP( 6, packh, 0x00003412, 0x00000012, 0x00000034 );

  #-------------------------------------------------------------
  # Source/Destination tests
  #-------------------------------------------------------------

  TEST_RR_SRC1_EQ_DEST( 12, packh, 0x0000F078, 0x12345678, 0x9ABCDEF0 );
  TEST_RR_SRC2_EQ_DEST( 13, packh, 0x0000F078, 0x12345678, 0x9ABCDEF0 );
  TEST_RR_SRC12_EQ_DEST( 14, packh, 0x0000FFFF, 0xFFFFFFFF );

  #-------------------------------------------------------------
  # Bypassing tests
  #-------------------------------------------------------------

  TEST_RR_DEST_BYPASS( 15, 0, packh, 0x0000F078, 0x12345678, 0x9ABCDEF0 );
  TEST_RR_DEST_BYPASS( 16, 1, packh, 0x0000FFFF, 0xFFFFFFFF, 0xFFFFFFFF );
  TEST_RR_DEST_BYPASS( 17, 2, packh, 0x00000000, 0x00000000, 0x00000000 );

  TEST_RR_SRC12_BYPASS( 18, 0, 0, packh, 0x0000F078, 0x12345678, 0x9ABCDEF0 );
  TEST_RR_SRC12_BYPASS( 19, 0, 1, packh, 0x0000FFFF, 0xFFFFFFFF, 0xFFFFFFFF );
  TEST_RR_SRC12_BYPASS( 20, 0, 2, packh, 0x00000000, 0x00000000, 0x00000000 );
  TEST_RR_SRC12_BYPASS( 21, 1, 0, packh, 0x0000F078, 0x12345678, 0x9ABCDEF0 );
  TEST_RR_SRC12_BYPASS( 22, 1, 1, packh, 0x0000FFFF, 0xFFFFFFFF, 0xFFFFFFFF );
  TEST_RR_SRC12_BYPASS( 23, 2, 0, packh, 0x00000000, 0x00000000, 0x00000000 );

  TEST_RR_SRC21_BYPASS( 24, 0, 0, packh, 0x0000F078, 0x12345678, 0x9ABCDEF0 );
  TEST_RR_SRC21_BYPASS( 25, 0, 1, packh, 0x0000FFFF, 0xFFFFFFFF, 0xFFFFFFFF );
  TEST_RR_SRC21_BYPASS( 26, 0, 2, packh, 0x00000000, 0x00000000, 0x00000000 );
  TEST_RR_SRC21_BYPASS( 27, 1, 0, packh, 0x0000F078, 0x12345678, 0x9ABCDEF0 );
  TEST_RR_SRC21_BYPASS( 28, 1, 1, packh, 0x0000FFFF, 0xFFFFFFFF, 0xFFFFFFFF );
  TEST_RR_SRC21_BYPASS( 29, 2, 0, packh, 0x00000000, 0x00000000, 0x00000000 );

  TEST_RR_ZEROSRC1( 30, packh, 0x0000F000, 0x9ABCDEF0 );
  TEST_RR_ZEROSRC2( 31, packh, 0x00000078, 0x12345678 );
  TEST_RR_ZEROSRC12( 32, packh, 0x00000000 );
  TEST_RR_ZERODEST( 33, packh, 0x12345678, 0x9ABCDEF0 );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN
  TEST_DATA
RVTEST_DATA_END
