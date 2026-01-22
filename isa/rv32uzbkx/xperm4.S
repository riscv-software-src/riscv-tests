# See LICENSE for license details.

#*****************************************************************************
# xperm4.S
#-----------------------------------------------------------------------------
#
# Test xperm4 instruction.
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV32U
RVTEST_CODE_BEGIN

  #-------------------------------------------------------------
  # Arithmetic tests
  #-------------------------------------------------------------

  TEST_RR_OP( 2, xperm4, 0x65432100, 0x01234567, 0x12345678 );
  TEST_RR_OP( 3, xperm4, 0xFFFFFFF0, 0xFFFFFFFF, 0x12345678 );
  TEST_RR_OP( 4, xperm4, 0x00000000, 0x00000000, 0x12345678 );
  TEST_RR_OP( 5, xperm4, 0x12345670, 0x76543210, 0x12345678 );
  TEST_RR_OP( 6, xperm4, 0x65432100, 0x01234567, 0x12345678 );

  TEST_RR_OP( 7, xperm4, 0x0000000F, 0x89ABCDEF, 0x9ABCDEF0 );
  TEST_RR_OP( 8, xperm4, 0x0000000F, 0xFFFFFFFF, 0x9ABCDEF0 );
  TEST_RR_OP( 9, xperm4, 0x00000000, 0x00000000, 0x9ABCDEF0 );
  TEST_RR_OP( 10, xperm4, 0x00000000, 0x76543210, 0x9ABCDEF0 );
  TEST_RR_OP( 11, xperm4, 0x0000000F, 0x89ABCDEF, 0x9ABCDEF0 );

  #-------------------------------------------------------------
  # Source/Destination tests
  #-------------------------------------------------------------

  TEST_RR_SRC1_EQ_DEST( 12, xperm4, 0x65432100, 0x01234567, 0x12345678 );
  TEST_RR_SRC2_EQ_DEST( 13, xperm4, 0x65432100, 0x01234567, 0x12345678 );
  TEST_RR_SRC12_EQ_DEST( 14, xperm4, 0x00000000, 0xFFFFFFFF );

  #-------------------------------------------------------------
  # Bypassing tests
  #-------------------------------------------------------------

  TEST_RR_DEST_BYPASS( 15, 0, xperm4, 0x65432100, 0x01234567, 0x12345678 );
  TEST_RR_DEST_BYPASS( 16, 1, xperm4, 0xFFFFFFF0, 0xFFFFFFFF, 0x12345678 );
  TEST_RR_DEST_BYPASS( 17, 2, xperm4, 0x00000000, 0x00000000, 0x12345678 );

  TEST_RR_SRC12_BYPASS( 18, 0, 0, xperm4, 0x65432100, 0x01234567, 0x12345678 );
  TEST_RR_SRC12_BYPASS( 19, 0, 1, xperm4, 0xFFFFFFF0, 0xFFFFFFFF, 0x12345678 );
  TEST_RR_SRC12_BYPASS( 20, 0, 2, xperm4, 0x00000000, 0x00000000, 0x12345678 );
  TEST_RR_SRC12_BYPASS( 21, 1, 0, xperm4, 0x65432100, 0x01234567, 0x12345678 );
  TEST_RR_SRC12_BYPASS( 22, 1, 1, xperm4, 0xFFFFFFF0, 0xFFFFFFFF, 0x12345678 );
  TEST_RR_SRC12_BYPASS( 23, 2, 0, xperm4, 0x00000000, 0x00000000, 0x12345678 );

  TEST_RR_SRC21_BYPASS( 24, 0, 0, xperm4, 0x65432100, 0x01234567, 0x12345678 );
  TEST_RR_SRC21_BYPASS( 25, 0, 1, xperm4, 0xFFFFFFF0, 0xFFFFFFFF, 0x12345678 );
  TEST_RR_SRC21_BYPASS( 26, 0, 2, xperm4, 0x00000000, 0x00000000, 0x12345678 );
  TEST_RR_SRC21_BYPASS( 27, 1, 0, xperm4, 0x65432100, 0x01234567, 0x12345678 );
  TEST_RR_SRC21_BYPASS( 28, 1, 1, xperm4, 0xFFFFFFF0, 0xFFFFFFFF, 0x12345678 );
  TEST_RR_SRC21_BYPASS( 29, 2, 0, xperm4, 0x00000000, 0x00000000, 0x12345678 );

  TEST_RR_ZEROSRC1( 30, xperm4, 0x00000000, 0x12345678 );
  TEST_RR_ZEROSRC2( 31, xperm4, 0x77777777, 0x01234567 );
  TEST_RR_ZEROSRC12( 32, xperm4, 0x00000000 );
  TEST_RR_ZERODEST( 33, xperm4, 0x01234567, 0x12345678 );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN
  TEST_DATA
RVTEST_DATA_END
