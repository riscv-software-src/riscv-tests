# See LICENSE for license details.

#*****************************************************************************
# sh2add.S
#-----------------------------------------------------------------------------
#
# Test sh2add instruction.
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV32U
RVTEST_CODE_BEGIN

  #-------------------------------------------------------------
  # Arithmetic tests
  #-------------------------------------------------------------

  TEST_RR_OP( 2,  sh2add, 0x00000000, 0x00000000, 0x00000000 );
  TEST_RR_OP( 3,  sh2add, 0x00000005, 0x00000001, 0x00000001 );
  TEST_RR_OP( 4,  sh2add, 0x00000013, 0x00000003, 0x00000007 );

  TEST_RR_OP( 5,  sh2add, 0xffff8000, 0x00000000, 0xffff8000 );
  TEST_RR_OP( 6,  sh2add, 0x00000000, 0x80000000, 0x00000000 );
  TEST_RR_OP( 7,  sh2add, 0xffff8000, 0x80000000, 0xffff8000 );

  TEST_RR_OP( 8,  sh2add, 0x00007fff, 0x00000000, 0x00007fff );
  TEST_RR_OP( 9,  sh2add, 0xfffffffc, 0x7fffffff, 0x00000000 );
  TEST_RR_OP( 10, sh2add, 0x00007ffb, 0x7fffffff, 0x00007fff );

  TEST_RR_OP( 11, sh2add, 0x00007fff, 0x80000000, 0x00007fff );
  TEST_RR_OP( 12, sh2add, 0xffff7ffc, 0x7fffffff, 0xffff8000 );

  TEST_RR_OP( 13, sh2add, 0xffffffff, 0x00000000, 0xffffffff );
  TEST_RR_OP( 14, sh2add, 0xfffffffd, 0xffffffff, 0x00000001 );
  TEST_RR_OP( 15, sh2add, 0xfffffffb, 0xffffffff, 0xffffffff );

  TEST_RR_OP( 16, sh2add, 0x80000003, 0x00000001, 0x7fffffff );

  #-------------------------------------------------------------
  # Source/Destination tests
  #-------------------------------------------------------------

  TEST_RR_SRC1_EQ_DEST( 17, sh2add, 63, 13, 11 );
  TEST_RR_SRC2_EQ_DEST( 18, sh2add, 67, 14, 11 );
  TEST_RR_SRC12_EQ_DEST( 19, sh2add, 65, 13 );

  #-------------------------------------------------------------
  # Bypassing tests
  #-------------------------------------------------------------

  TEST_RR_DEST_BYPASS( 20, 0, sh2add, 63, 13, 11 );
  TEST_RR_DEST_BYPASS( 21, 1, sh2add, 67, 14, 11 );
  TEST_RR_DEST_BYPASS( 22, 2, sh2add, 71, 15, 11 );

  TEST_RR_SRC12_BYPASS( 23, 0, 0, sh2add, 63, 13, 11 );
  TEST_RR_SRC12_BYPASS( 24, 0, 1, sh2add, 67, 14, 11 );
  TEST_RR_SRC12_BYPASS( 25, 0, 2, sh2add, 71, 15, 11 );
  TEST_RR_SRC12_BYPASS( 26, 1, 0, sh2add, 63, 13, 11 );
  TEST_RR_SRC12_BYPASS( 27, 1, 1, sh2add, 67, 14, 11 );
  TEST_RR_SRC12_BYPASS( 28, 2, 0, sh2add, 71, 15, 11 );

  TEST_RR_SRC21_BYPASS( 29, 0, 0, sh2add, 63, 13, 11 );
  TEST_RR_SRC21_BYPASS( 30, 0, 1, sh2add, 67, 14, 11 );
  TEST_RR_SRC21_BYPASS( 31, 0, 2, sh2add, 71, 15, 11 );
  TEST_RR_SRC21_BYPASS( 32, 1, 0, sh2add, 63, 13, 11 );
  TEST_RR_SRC21_BYPASS( 33, 1, 1, sh2add, 67, 14, 11 );
  TEST_RR_SRC21_BYPASS( 34, 2, 0, sh2add, 71, 15, 11 );

  TEST_RR_ZEROSRC1( 35, sh2add, 15, 15 );
  TEST_RR_ZEROSRC2( 36, sh2add, 128, 32 );
  TEST_RR_ZEROSRC12( 37, sh2add, 0 );
  TEST_RR_ZERODEST( 38, sh2add, 16, 30 );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END
