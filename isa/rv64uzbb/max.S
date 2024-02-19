# See LICENSE for license details.

#*****************************************************************************
# max.S
#-----------------------------------------------------------------------------
#
# Test max instruction.
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV64U
RVTEST_CODE_BEGIN

  #-------------------------------------------------------------
  # Arithmetic tests
  #-------------------------------------------------------------

  TEST_RR_OP( 2,  max, 0x0000000000000000, 0x0000000000000000, 0x0000000000000000 );
  TEST_RR_OP( 3,  max, 0x0000000000000001, 0x0000000000000001, 0x0000000000000001 );
  TEST_RR_OP( 4,  max, 0x0000000000000007, 0x0000000000000003, 0x0000000000000007 );
  TEST_RR_OP( 5,  max, 0x0000000000000007, 0x0000000000000007, 0x0000000000000003 );

  TEST_RR_OP( 6,  max, 0x0000000000000000, 0x0000000000000000, 0xffffffffffff8000 );
  TEST_RR_OP( 7,  max, 0x0000000000000000, 0xffffffff80000000, 0x0000000000000000 );
  TEST_RR_OP( 8,  max, 0xffffffffffff8000, 0xffffffff80000000, 0xffffffffffff8000 );

  TEST_RR_OP( 9,  max, 0x0000000000007fff, 0x0000000000000000, 0x0000000000007fff );
  TEST_RR_OP( 10, max, 0x000000007fffffff, 0x000000007fffffff, 0x0000000000000000 );
  TEST_RR_OP( 11, max, 0x000000007fffffff, 0x000000007fffffff, 0x0000000000007fff );

  TEST_RR_OP( 12, max, 0x0000000000007fff, 0xffffffff80000000, 0x0000000000007fff );
  TEST_RR_OP( 13, max, 0x000000007fffffff, 0x000000007fffffff, 0xffffffffffff8000 );

  TEST_RR_OP( 14, max, 0x0000000000000000, 0x0000000000000000, 0xffffffffffffffff );
  TEST_RR_OP( 15, max, 0x0000000000000001, 0xffffffffffffffff, 0x0000000000000001 );
  TEST_RR_OP( 16, max, 0xffffffffffffffff, 0xffffffffffffffff, 0xffffffffffffffff );

  #-------------------------------------------------------------
  # Source/Destination tests
  #-------------------------------------------------------------

  TEST_RR_SRC1_EQ_DEST( 17, max, 14, 14, 13 );
  TEST_RR_SRC2_EQ_DEST( 18, max, 13, 11, 13 );
  TEST_RR_SRC12_EQ_DEST( 19, max, 13, 13 );

  #-------------------------------------------------------------
  # Bypassing tests
  #-------------------------------------------------------------

  TEST_RR_DEST_BYPASS( 20, 0, max, 13, 11, 13 );
  TEST_RR_DEST_BYPASS( 21, 1, max, 14, 14, 13 );
  TEST_RR_DEST_BYPASS( 22, 2, max, 13, 12, 13 );

  TEST_RR_SRC12_BYPASS( 23, 0, 0, max, 14, 14, 13 );
  TEST_RR_SRC12_BYPASS( 24, 0, 1, max, 13, 11, 13 );
  TEST_RR_SRC12_BYPASS( 25, 0, 2, max, 15, 15, 13 );
  TEST_RR_SRC12_BYPASS( 26, 1, 0, max, 13, 10, 13 );
  TEST_RR_SRC12_BYPASS( 27, 1, 1, max, 16, 16, 13 );
  TEST_RR_SRC12_BYPASS( 28, 2, 0, max, 13,  9, 13 );

  TEST_RR_SRC21_BYPASS( 29, 0, 0, max, 17, 17, 13 );
  TEST_RR_SRC21_BYPASS( 30, 0, 1, max, 13,  8, 13 );
  TEST_RR_SRC21_BYPASS( 31, 0, 2, max, 18, 18, 13 );
  TEST_RR_SRC21_BYPASS( 32, 1, 0, max, 13,  7, 13 );
  TEST_RR_SRC21_BYPASS( 33, 1, 1, max, 19, 19, 13 );
  TEST_RR_SRC21_BYPASS( 34, 2, 0, max, 13,  6, 13 );

  TEST_RR_ZEROSRC1( 35, max, 0, -1 );
  TEST_RR_ZEROSRC2( 36, max, 0, -1 );
  TEST_RR_ZEROSRC12( 37, max, 0 );
  TEST_RR_ZERODEST( 38, max, 16, 30 );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END
