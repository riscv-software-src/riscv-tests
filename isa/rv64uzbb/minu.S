# See LICENSE for license details.

#*****************************************************************************
# minu.S
#-----------------------------------------------------------------------------
#
# Test minu instruction.
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV64U
RVTEST_CODE_BEGIN

  #-------------------------------------------------------------
  # Arithmetic tests
  #-------------------------------------------------------------

  TEST_RR_OP( 2,  minu, 0x00000000, 0x00000000, 0x00000000 );
  TEST_RR_OP( 3,  minu, 0x00000001, 0x00000001, 0x00000001 );
  TEST_RR_OP( 4,  minu, 0x00000003, 0x00000003, 0x00000007 );
  TEST_RR_OP( 5,  minu, 0x00000003, 0x00000007, 0x00000003 );

  TEST_RR_OP( 6,  minu, 0x00000000, 0x00000000, 0xffff8000 );
  TEST_RR_OP( 7,  minu, 0x00000000, 0x80000000, 0x00000000 );
  TEST_RR_OP( 8,  minu, 0x80000000, 0x80000000, 0xffff8000 );

  TEST_RR_OP( 9,  minu, 0x00000000, 0x00000000, 0x00007fff );
  TEST_RR_OP( 10, minu, 0x00000000, 0x7fffffff, 0x00000000 );
  TEST_RR_OP( 11, minu, 0x00007fff, 0x7fffffff, 0x00007fff );

  TEST_RR_OP( 12, minu, 0x00007fff, 0x80000000, 0x00007fff );
  TEST_RR_OP( 13, minu, 0x7fffffff, 0x7fffffff, 0xffff8000 );

  TEST_RR_OP( 14, minu, 0x00000000, 0x00000000, 0xffffffff );
  TEST_RR_OP( 15, minu, 0x00000001, 0xffffffff, 0x00000001 );
  TEST_RR_OP( 16, minu, 0xffffffff, 0xffffffff, 0xffffffff );

  #-------------------------------------------------------------
  # Source/Destination tests
  #-------------------------------------------------------------

  TEST_RR_SRC1_EQ_DEST( 17, minu, 13, 14, 13 );
  TEST_RR_SRC2_EQ_DEST( 18, minu, 11, 11, 13 );
  TEST_RR_SRC12_EQ_DEST( 19, minu, 13, 13 );

  #-------------------------------------------------------------
  # Bypassing tests
  #-------------------------------------------------------------

  TEST_RR_DEST_BYPASS( 20, 0, minu, 11, 11, 13 );
  TEST_RR_DEST_BYPASS( 21, 1, minu, 13, 14, 13 );
  TEST_RR_DEST_BYPASS( 22, 2, minu, 12, 12, 13 );

  TEST_RR_SRC12_BYPASS( 23, 0, 0, minu, 13, 14, 13 );
  TEST_RR_SRC12_BYPASS( 24, 0, 1, minu, 11, 11, 13 );
  TEST_RR_SRC12_BYPASS( 25, 0, 2, minu, 13, 15, 13 );
  TEST_RR_SRC12_BYPASS( 26, 1, 0, minu, 10, 10, 13 );
  TEST_RR_SRC12_BYPASS( 27, 1, 1, minu, 13, 16, 13 );
  TEST_RR_SRC12_BYPASS( 28, 2, 0, minu, 9,  9, 13 );

  TEST_RR_SRC21_BYPASS( 29, 0, 0, minu, 13, 17, 13 );
  TEST_RR_SRC21_BYPASS( 30, 0, 1, minu, 8,  8, 13 );
  TEST_RR_SRC21_BYPASS( 31, 0, 2, minu, 13, 18, 13 );
  TEST_RR_SRC21_BYPASS( 32, 1, 0, minu, 7,  7, 13 );
  TEST_RR_SRC21_BYPASS( 33, 1, 1, minu, 13, 19, 13 );
  TEST_RR_SRC21_BYPASS( 34, 2, 0, minu, 6,  6, 13 );

  TEST_RR_ZEROSRC1( 35, minu, 0, -1 );
  TEST_RR_ZEROSRC2( 36, minu, 0, -1 );
  TEST_RR_ZEROSRC12( 37, minu, 0 );
  TEST_RR_ZERODEST( 38, minu, 16, 30 );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END
