# See LICENSE for license details.

#*****************************************************************************
# clmulh.S
#-----------------------------------------------------------------------------
#
# Test clmulh instruction.
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV32U
RVTEST_CODE_BEGIN

  #-------------------------------------------------------------
  # Arithmetic tests
  #-------------------------------------------------------------

  TEST_RR_OP(32,  clmulh, 0x00003600, 0x00007e00, 0xb6db6db7 );
  TEST_RR_OP(33,  clmulh, 0x000036c0, 0x00007fc0, 0xb6db6db7 );

  TEST_RR_OP( 2,  clmulh, 0x00000000, 0x00000000, 0x00000000 );
  TEST_RR_OP( 3,  clmulh, 0x00000000, 0x00000001, 0x00000001 );
  TEST_RR_OP( 4,  clmulh, 0x00000000, 0x00000003, 0x00000007 );

  TEST_RR_OP( 5,  clmulh, 0x00000000, 0x00000000, 0xffff8000 );
  TEST_RR_OP( 6,  clmulh, 0x00000000, 0x80000000, 0x00000000 );
  TEST_RR_OP( 7,  clmulh, 0x7fffc000, 0x80000000, 0xffff8000 );

  TEST_RR_OP(30,  clmulh, 0x000133cd, 0xaaaaaaab, 0x0002fe7d );
  TEST_RR_OP(31,  clmulh, 0x000133cd, 0x0002fe7d, 0xaaaaaaab );

  TEST_RR_OP(34,  clmulh, 0x55550000, 0xff000000, 0xff000000 );

  TEST_RR_OP(35,  clmulh, 0x55555555, 0xffffffff, 0xffffffff );
  TEST_RR_OP(36,  clmulh, 0x00000000, 0xffffffff, 0x00000001 );
  TEST_RR_OP(37,  clmulh, 0x00000000, 0x00000001, 0xffffffff );

  #-------------------------------------------------------------
  # Source/Destination tests
  #-------------------------------------------------------------

  TEST_RR_SRC1_EQ_DEST( 8, clmulh, 0, 13, 11 );
  TEST_RR_SRC2_EQ_DEST( 9, clmulh, 0, 14, 11 );
  TEST_RR_SRC12_EQ_DEST( 10, clmulh, 0, 13 );

  #-------------------------------------------------------------
  # Bypassing tests
  #-------------------------------------------------------------

  TEST_RR_DEST_BYPASS( 11, 0, clmulh, 0, 13, 11 );
  TEST_RR_DEST_BYPASS( 12, 1, clmulh, 0, 14, 11 );
  TEST_RR_DEST_BYPASS( 13, 2, clmulh, 0, 15, 11 );

  TEST_RR_SRC12_BYPASS( 14, 0, 0, clmulh, 0, 13, 11 );
  TEST_RR_SRC12_BYPASS( 15, 0, 1, clmulh, 0, 14, 11 );
  TEST_RR_SRC12_BYPASS( 16, 0, 2, clmulh, 0, 15, 11 );
  TEST_RR_SRC12_BYPASS( 17, 1, 0, clmulh, 0, 13, 11 );
  TEST_RR_SRC12_BYPASS( 18, 1, 1, clmulh, 0, 14, 11 );
  TEST_RR_SRC12_BYPASS( 19, 2, 0, clmulh, 0, 15, 11 );

  TEST_RR_SRC21_BYPASS( 20, 0, 0, clmulh, 0, 13, 11 );
  TEST_RR_SRC21_BYPASS( 21, 0, 1, clmulh, 0, 14, 11 );
  TEST_RR_SRC21_BYPASS( 22, 0, 2, clmulh, 0, 15, 11 );
  TEST_RR_SRC21_BYPASS( 23, 1, 0, clmulh, 0, 13, 11 );
  TEST_RR_SRC21_BYPASS( 24, 1, 1, clmulh, 0, 14, 11 );
  TEST_RR_SRC21_BYPASS( 25, 2, 0, clmulh, 0, 15, 11 );

  TEST_RR_ZEROSRC1( 26, clmulh, 0, 31 );
  TEST_RR_ZEROSRC2( 27, clmulh, 0, 32 );
  TEST_RR_ZEROSRC12( 28, clmulh, 0 );
  TEST_RR_ZERODEST( 29, clmulh, 33, 34 );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END
