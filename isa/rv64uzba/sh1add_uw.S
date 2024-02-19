# See LICENSE for license details.

#*****************************************************************************
# sh1add.uw.S
#-----------------------------------------------------------------------------
#
# Test sh1add.uw instruction.
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV64U
RVTEST_CODE_BEGIN

  #-------------------------------------------------------------
  # Arithmetic tests
  #-------------------------------------------------------------

  TEST_RR_OP( 2,  sh1add.uw, 0x00000000, 0x00000000, 0x00000000 );
  TEST_RR_OP( 3,  sh1add.uw, 0x00000003, 0x00000001, 0x00000001 );
  TEST_RR_OP( 4,  sh1add.uw, 0x0000000d, 0x00000003, 0x00000007 );

  TEST_RR_OP( 5,  sh1add.uw, 0xffffffffffff8000, 0x0000000000000000, 0xffffffffffff8000 );
  TEST_RR_OP( 6,  sh1add.uw, 0x0000000100000000, 0xffffffff80000000, 0x00000000 );
  TEST_RR_OP( 7,  sh1add.uw, 0x00000000ffff8000, 0xffffffff80000000, 0xffffffffffff8000 );

  TEST_RR_OP( 8,  sh1add.uw, 0x0000000000007fff, 0x0000000000000000, 0x0000000000007fff );
  TEST_RR_OP( 9,  sh1add.uw, 0x00000000fffffffe, 0x000000007fffffff, 0x0000000000000000 );
  TEST_RR_OP( 10, sh1add.uw, 0x0000000100007ffd, 0x000000007fffffff, 0x0000000000007fff );

  TEST_RR_OP( 11, sh1add.uw, 0x0000000100007fff, 0xffffffff80000000, 0x0000000000007fff );
  TEST_RR_OP( 12, sh1add.uw, 0x00000000ffff7ffe, 0x000000007fffffff, 0xffffffffffff8000 );

  TEST_RR_OP( 13, sh1add.uw, 0xffffffffffffffff, 0x0000000000000000, 0xffffffffffffffff );
  TEST_RR_OP( 14, sh1add.uw, 0x00000001ffffffff, 0xffffffffffffffff, 0x0000000000000001 );
  TEST_RR_OP( 15, sh1add.uw, 0x00000001fffffffd, 0xffffffffffffffff, 0xffffffffffffffff );

  TEST_RR_OP( 16, sh1add.uw, 0x0000000080000001, 0x0000000000000001, 0x000000007fffffff );

  #-------------------------------------------------------------
  # Source/Destination tests
  #-------------------------------------------------------------

  TEST_RR_SRC1_EQ_DEST( 17, sh1add.uw, 37, 13, 11 );
  TEST_RR_SRC2_EQ_DEST( 18, sh1add.uw, 39, 14, 11 );
  TEST_RR_SRC12_EQ_DEST( 19, sh1add.uw, 39, 13 );

  #-------------------------------------------------------------
  # Bypassing tests
  #-------------------------------------------------------------

  TEST_RR_DEST_BYPASS( 20, 0, sh1add.uw, 37, 13, 11 );
  TEST_RR_DEST_BYPASS( 21, 1, sh1add.uw, 39, 14, 11 );
  TEST_RR_DEST_BYPASS( 22, 2, sh1add.uw, 41, 15, 11 );

  TEST_RR_SRC12_BYPASS( 23, 0, 0, sh1add.uw, 37, 13, 11 );
  TEST_RR_SRC12_BYPASS( 24, 0, 1, sh1add.uw, 39, 14, 11 );
  TEST_RR_SRC12_BYPASS( 25, 0, 2, sh1add.uw, 41, 15, 11 );
  TEST_RR_SRC12_BYPASS( 26, 1, 0, sh1add.uw, 37, 13, 11 );
  TEST_RR_SRC12_BYPASS( 27, 1, 1, sh1add.uw, 39, 14, 11 );
  TEST_RR_SRC12_BYPASS( 28, 2, 0, sh1add.uw, 41, 15, 11 );

  TEST_RR_SRC21_BYPASS( 29, 0, 0, sh1add.uw, 37, 13, 11 );
  TEST_RR_SRC21_BYPASS( 30, 0, 1, sh1add.uw, 39, 14, 11 );
  TEST_RR_SRC21_BYPASS( 31, 0, 2, sh1add.uw, 41, 15, 11 );
  TEST_RR_SRC21_BYPASS( 32, 1, 0, sh1add.uw, 37, 13, 11 );
  TEST_RR_SRC21_BYPASS( 33, 1, 1, sh1add.uw, 39, 14, 11 );
  TEST_RR_SRC21_BYPASS( 34, 2, 0, sh1add.uw, 41, 15, 11 );

  TEST_RR_ZEROSRC1( 35, sh1add.uw, 15, 15 );
  TEST_RR_ZEROSRC2( 36, sh1add.uw, 64, 32 );
  TEST_RR_ZEROSRC12( 37, sh1add.uw, 0 );
  TEST_RR_ZERODEST( 38, sh1add.uw, 16, 30 );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END
