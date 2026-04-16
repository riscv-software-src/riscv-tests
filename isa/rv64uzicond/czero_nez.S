# See LICENSE for license details.

#*****************************************************************************
# czero_nez.S
#-----------------------------------------------------------------------------
#
# Test czero.nez instruction.
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV64U
RVTEST_CODE_BEGIN

  #-------------------------------------------------------------
  # Arithmetic tests
  #-------------------------------------------------------------

  # czero.nez rd, rs1, rs2 -> if (rs2 != 0) rd = 0; else rd = rs1;
  TEST_RR_OP( 2,  czero.nez, 0x12345678, 0x12345678, 0x00000000 );
  TEST_RR_OP( 3,  czero.nez, 0x00000000, 0x12345678, 0x00000001 );
  TEST_RR_OP( 4,  czero.nez, 0x00000000, 0x12345678, 0xffffffff );

  TEST_RR_OP( 5,  czero.nez, 0x00000000, 0x00000000, 0x00000000 );
  TEST_RR_OP( 6,  czero.nez, 0x00000000, 0x00000000, 0x00000001 );

  #-------------------------------------------------------------
  # Source/Destination tests
  #-------------------------------------------------------------

  TEST_RR_SRC1_EQ_DEST( 7, czero.nez, 13, 13, 0 );
  TEST_RR_SRC1_EQ_DEST( 8, czero.nez, 0, 13, 11 );
  TEST_RR_SRC2_EQ_DEST( 9, czero.nez, 14, 14, 0 );
  TEST_RR_SRC2_EQ_DEST( 10, czero.nez, 0, 14, 11 );
  TEST_RR_SRC12_EQ_DEST( 11, czero.nez, 0, 0 );
  TEST_RR_SRC12_EQ_DEST( 12, czero.nez, 0, 13 );

  #-------------------------------------------------------------
  # Bypassing tests
  #-------------------------------------------------------------

  TEST_RR_DEST_BYPASS( 13, 0, czero.nez, 13, 13, 0 );
  TEST_RR_DEST_BYPASS( 14, 1, czero.nez, 0, 14, 11 );
  TEST_RR_DEST_BYPASS( 15, 2, czero.nez, 15, 15, 0 );

  TEST_RR_SRC12_BYPASS( 16, 0, 0, czero.nez, 13, 13, 0 );
  TEST_RR_SRC12_BYPASS( 17, 0, 1, czero.nez, 0, 14, 11 );
  TEST_RR_SRC12_BYPASS( 18, 0, 2, czero.nez, 15, 15, 0 );
  TEST_RR_SRC12_BYPASS( 19, 1, 0, czero.nez, 13, 13, 0 );
  TEST_RR_SRC12_BYPASS( 20, 1, 1, czero.nez, 0, 14, 11 );
  TEST_RR_SRC12_BYPASS( 21, 2, 0, czero.nez, 15, 15, 0 );

  TEST_RR_SRC21_BYPASS( 22, 0, 0, czero.nez, 13, 13, 0 );
  TEST_RR_SRC21_BYPASS( 23, 0, 1, czero.nez, 0, 14, 11 );
  TEST_RR_SRC21_BYPASS( 24, 0, 2, czero.nez, 15, 15, 0 );
  TEST_RR_SRC21_BYPASS( 25, 1, 0, czero.nez, 13, 13, 0 );
  TEST_RR_SRC21_BYPASS( 26, 1, 1, czero.nez, 0, 14, 11 );
  TEST_RR_SRC21_BYPASS( 27, 2, 0, czero.nez, 15, 15, 0 );

  TEST_RR_ZEROSRC1( 28, czero.nez, 0, 0 );
  TEST_RR_ZEROSRC1( 29, czero.nez, 0, 1 );
  TEST_RR_ZEROSRC2( 30, czero.nez, 15, 15 );
  TEST_RR_ZEROSRC12( 31, czero.nez, 0 );
  TEST_RR_ZERODEST( 32, czero.nez, 16, 30 );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END
