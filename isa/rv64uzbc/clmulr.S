# See LICENSE for license details.

#*****************************************************************************
# clmulr.S
#-----------------------------------------------------------------------------
#
# Test clmulr instruction.
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV64U
RVTEST_CODE_BEGIN

  #-------------------------------------------------------------
  # Arithmetic tests
  #-------------------------------------------------------------

  TEST_RR_OP(32,  clmulr, 0x0000000000002400, 0x0000000000007e00, 0x6db6db6db6db6db7 );
  TEST_RR_OP(33,  clmulr, 0x0000000000002480, 0x0000000000007fc0, 0x6db6db6db6db6db7 );

  TEST_RR_OP( 2,  clmulr, 0x00000000, 0x00000000, 0x00000000 );
  TEST_RR_OP( 3,  clmulr, 0x00000000, 0x00000001, 0x00000001 );
  TEST_RR_OP( 4,  clmulr, 0x00000000, 0x00000003, 0x00000007 );

  TEST_RR_OP( 5,  clmulr, 0x0000000000000000, 0x0000000000000000, 0xffffffffffff8000 );
  TEST_RR_OP( 6,  clmulr, 0x0000000000000000, 0xffffffff80000000, 0x00000000 );
  TEST_RR_OP( 7,  clmulr, 0xaaaaaaaaffffaaaa, 0xffffffff80000000, 0xffffffffffff8000 );

  TEST_RR_OP(30,  clmulr, 0x000000000002679b, 0xaaaaaaaaaaaaaaab, 0x000000000002fe7d );
  TEST_RR_OP(31,  clmulr, 0x000000000002679b, 0x000000000002fe7d, 0xaaaaaaaaaaaaaaab );

  #-------------------------------------------------------------
  # Source/Destination tests
  #-------------------------------------------------------------

  TEST_RR_SRC1_EQ_DEST( 8, clmulr, 0, 13, 11 );
  TEST_RR_SRC2_EQ_DEST( 9, clmulr, 0, 14, 11 );
  TEST_RR_SRC12_EQ_DEST( 10, clmulr, 0, 13 );

  #-------------------------------------------------------------
  # Bypassing tests
  #-------------------------------------------------------------

  TEST_RR_DEST_BYPASS( 11, 0, clmulr, 0, 13, 11 );
  TEST_RR_DEST_BYPASS( 12, 1, clmulr, 0, 14, 11 );
  TEST_RR_DEST_BYPASS( 13, 2, clmulr, 0, 15, 11 );

  TEST_RR_SRC12_BYPASS( 14, 0, 0, clmulr, 0, 13, 11 );
  TEST_RR_SRC12_BYPASS( 15, 0, 1, clmulr, 0, 14, 11 );
  TEST_RR_SRC12_BYPASS( 16, 0, 2, clmulr, 0, 15, 11 );
  TEST_RR_SRC12_BYPASS( 17, 1, 0, clmulr, 0, 13, 11 );
  TEST_RR_SRC12_BYPASS( 18, 1, 1, clmulr, 0, 14, 11 );
  TEST_RR_SRC12_BYPASS( 19, 2, 0, clmulr, 0, 15, 11 );

  TEST_RR_SRC21_BYPASS( 20, 0, 0, clmulr, 0, 13, 11 );
  TEST_RR_SRC21_BYPASS( 21, 0, 1, clmulr, 0, 14, 11 );
  TEST_RR_SRC21_BYPASS( 22, 0, 2, clmulr, 0, 15, 11 );
  TEST_RR_SRC21_BYPASS( 23, 1, 0, clmulr, 0, 13, 11 );
  TEST_RR_SRC21_BYPASS( 24, 1, 1, clmulr, 0, 14, 11 );
  TEST_RR_SRC21_BYPASS( 25, 2, 0, clmulr, 0, 15, 11 );

  TEST_RR_ZEROSRC1( 26, clmulr, 0, 31 );
  TEST_RR_ZEROSRC2( 27, clmulr, 0, 32 );
  TEST_RR_ZEROSRC12( 28, clmulr, 0 );
  TEST_RR_ZERODEST( 29, clmulr, 33, 34 );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END
