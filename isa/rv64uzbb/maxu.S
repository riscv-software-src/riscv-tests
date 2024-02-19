# See LICENSE for license details.

#*****************************************************************************
# maxu.S
#-----------------------------------------------------------------------------
#
# Test maxu instruction.
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV64U
RVTEST_CODE_BEGIN

  #-------------------------------------------------------------
  # Arithmetic tests
  #-------------------------------------------------------------

  TEST_RR_OP( 2,  maxu, 0x00000000, 0x00000000, 0x00000000 );
  TEST_RR_OP( 3,  maxu, 0x00000001, 0x00000001, 0x00000001 );
  TEST_RR_OP( 4,  maxu, 0x00000007, 0x00000003, 0x00000007 );
  TEST_RR_OP( 5,  maxu, 0x00000007, 0x00000007, 0x00000003 );

  TEST_RR_OP( 6,  maxu, 0xffff8000, 0x00000000, 0xffff8000 );
  TEST_RR_OP( 7,  maxu, 0x80000000, 0x80000000, 0x00000000 );
  TEST_RR_OP( 8,  maxu, 0xffff8000, 0x80000000, 0xffff8000 );

  TEST_RR_OP( 9,  maxu, 0x00007fff, 0x00000000, 0x00007fff );
  TEST_RR_OP( 10, maxu, 0x7fffffff, 0x7fffffff, 0x00000000 );
  TEST_RR_OP( 11, maxu, 0x7fffffff, 0x7fffffff, 0x00007fff );

  TEST_RR_OP( 12, maxu, 0x80000000, 0x80000000, 0x00007fff );
  TEST_RR_OP( 13, maxu, 0xffff8000, 0x7fffffff, 0xffff8000 );

  TEST_RR_OP( 14, maxu, 0xffffffff, 0x00000000, 0xffffffff );
  TEST_RR_OP( 15, maxu, 0xffffffff, 0xffffffff, 0x00000001 );
  TEST_RR_OP( 16, maxu, 0xffffffff, 0xffffffff, 0xffffffff );

  #-------------------------------------------------------------
  # Source/Destination tests
  #-------------------------------------------------------------

  TEST_RR_SRC1_EQ_DEST( 17, maxu, 14, 14, 13 );
  TEST_RR_SRC2_EQ_DEST( 18, maxu, 13, 11, 13 );
  TEST_RR_SRC12_EQ_DEST( 19, maxu, 13, 13 );

  #-------------------------------------------------------------
  # Bypassing tests
  #-------------------------------------------------------------

  TEST_RR_DEST_BYPASS( 20, 0, maxu, 13, 11, 13 );
  TEST_RR_DEST_BYPASS( 21, 1, maxu, 14, 14, 13 );
  TEST_RR_DEST_BYPASS( 22, 2, maxu, 13, 12, 13 );

  TEST_RR_SRC12_BYPASS( 23, 0, 0, maxu, 14, 14, 13 );
  TEST_RR_SRC12_BYPASS( 24, 0, 1, maxu, 13, 11, 13 );
  TEST_RR_SRC12_BYPASS( 25, 0, 2, maxu, 15, 15, 13 );
  TEST_RR_SRC12_BYPASS( 26, 1, 0, maxu, 13, 10, 13 );
  TEST_RR_SRC12_BYPASS( 27, 1, 1, maxu, 16, 16, 13 );
  TEST_RR_SRC12_BYPASS( 28, 2, 0, maxu, 13,  9, 13 );

  TEST_RR_SRC21_BYPASS( 29, 0, 0, maxu, 17, 17, 13 );
  TEST_RR_SRC21_BYPASS( 30, 0, 1, maxu, 13,  8, 13 );
  TEST_RR_SRC21_BYPASS( 31, 0, 2, maxu, 18, 18, 13 );
  TEST_RR_SRC21_BYPASS( 32, 1, 0, maxu, 13,  7, 13 );
  TEST_RR_SRC21_BYPASS( 33, 1, 1, maxu, 19, 19, 13 );
  TEST_RR_SRC21_BYPASS( 34, 2, 0, maxu, 13,  6, 13 );

  TEST_RR_ZEROSRC1( 35, maxu, -1, -1 );
  TEST_RR_ZEROSRC2( 36, maxu, -1, -1 );
  TEST_RR_ZEROSRC12( 37, maxu, 0 );
  TEST_RR_ZERODEST( 38, maxu, 16, 30 );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END
