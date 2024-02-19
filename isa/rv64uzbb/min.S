# See LICENSE for license details.

#*****************************************************************************
# min.S
#-----------------------------------------------------------------------------
#
# Test min instruction.
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV64U
RVTEST_CODE_BEGIN

  #-------------------------------------------------------------
  # Arithmetic tests
  #-------------------------------------------------------------

  TEST_RR_OP( 2,  min, 0x0000000000000000, 0x0000000000000000, 0x0000000000000000 );
  TEST_RR_OP( 3,  min, 0x0000000000000001, 0x0000000000000001, 0x0000000000000001 );
  TEST_RR_OP( 4,  min, 0x0000000000000003, 0x0000000000000003, 0x0000000000000007 );
  TEST_RR_OP( 5,  min, 0x0000000000000003, 0x0000000000000007, 0x0000000000000003 );

  TEST_RR_OP( 6,  min, 0xffffffffffff8000, 0x0000000000000000, 0xffffffffffff8000 );
  TEST_RR_OP( 7,  min, 0xffffffff80000000, 0xffffffff80000000, 0x0000000000000000 );
  TEST_RR_OP( 8,  min, 0xffffffff80000000, 0xffffffff80000000, 0xffffffffffff8000 );

  TEST_RR_OP( 9,  min, 0x0000000000000000, 0x0000000000000000, 0x0000000000007fff );
  TEST_RR_OP( 10, min, 0x0000000000000000, 0x000000007fffffff, 0x0000000000000000 );
  TEST_RR_OP( 11, min, 0x0000000000007fff, 0x000000007fffffff, 0x0000000000007fff );

  TEST_RR_OP( 12, min, 0xffffffff80000000, 0xffffffff80000000, 0x0000000000007fff );
  TEST_RR_OP( 13, min, 0xffffffffffff8000, 0x000000007fffffff, 0xffffffffffff8000 );

  TEST_RR_OP( 14, min, 0xffffffffffffffff, 0x0000000000000000, 0xffffffffffffffff );
  TEST_RR_OP( 15, min, 0xffffffffffffffff, 0xffffffffffffffff, 0x0000000000000001 );
  TEST_RR_OP( 16, min, 0xffffffffffffffff, 0xffffffffffffffff, 0xffffffffffffffff );

  #-------------------------------------------------------------
  # Source/Destination tests
  #-------------------------------------------------------------

  TEST_RR_SRC1_EQ_DEST( 17, min, 13, 14, 13 );
  TEST_RR_SRC2_EQ_DEST( 18, min, 11, 11, 13 );
  TEST_RR_SRC12_EQ_DEST( 19, min, 13, 13 );

  #-------------------------------------------------------------
  # Bypassing tests
  #-------------------------------------------------------------

  TEST_RR_DEST_BYPASS( 20, 0, min, 11, 11, 13 );
  TEST_RR_DEST_BYPASS( 21, 1, min, 13, 14, 13 );
  TEST_RR_DEST_BYPASS( 22, 2, min, 12, 12, 13 );

  TEST_RR_SRC12_BYPASS( 23, 0, 0, min, 13, 14, 13 );
  TEST_RR_SRC12_BYPASS( 24, 0, 1, min, 11, 11, 13 );
  TEST_RR_SRC12_BYPASS( 25, 0, 2, min, 13, 15, 13 );
  TEST_RR_SRC12_BYPASS( 26, 1, 0, min, 10, 10, 13 );
  TEST_RR_SRC12_BYPASS( 27, 1, 1, min, 13, 16, 13 );
  TEST_RR_SRC12_BYPASS( 28, 2, 0, min, 9,  9, 13 );

  TEST_RR_SRC21_BYPASS( 29, 0, 0, min, 13, 17, 13 );
  TEST_RR_SRC21_BYPASS( 30, 0, 1, min, 8,  8, 13 );
  TEST_RR_SRC21_BYPASS( 31, 0, 2, min, 13, 18, 13 );
  TEST_RR_SRC21_BYPASS( 32, 1, 0, min, 7,  7, 13 );
  TEST_RR_SRC21_BYPASS( 33, 1, 1, min, 13, 19, 13 );
  TEST_RR_SRC21_BYPASS( 34, 2, 0, min, 6,  6, 13 );

  TEST_RR_ZEROSRC1( 35, min, -1, -1 );
  TEST_RR_ZEROSRC2( 36, min, -1, -1 );
  TEST_RR_ZEROSRC12( 37, min, 0 );
  TEST_RR_ZERODEST( 38, min, 16, 30 );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END
