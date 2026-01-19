# See LICENSE for license details.

#*****************************************************************************
# unzip.S
#-----------------------------------------------------------------------------
#
# Test unzip instruction.
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV32U
RVTEST_CODE_BEGIN

  #-------------------------------------------------------------
  # Arithmetic tests
  #-------------------------------------------------------------

  TEST_R_OP( 2, unzip, 0x0000FFFF, 0x55555555 );
  TEST_R_OP( 3, unzip, 0xFFFF0000, 0xAAAAAAAA );
  TEST_R_OP( 4, unzip, 0x00000000, 0x00000000 );
  TEST_R_OP( 5, unzip, 0xFFFFFFFF, 0xFFFFFFFF );
  TEST_R_OP( 6, unzip, 0xAAAA5555, 0x99999999 );
  TEST_R_OP( 7, unzip, 0x0F0F0F0F, 0x00FF00FF );
  TEST_R_OP( 8, unzip, 0xBEFFE36B, 0xDEADBEEF );

  #-------------------------------------------------------------
  # Source/Destination tests
  #-------------------------------------------------------------

  TEST_R_SRC1_EQ_DEST( 11, unzip, 0x0000FFFF, 0x55555555 );
  TEST_R_SRC1_EQ_DEST( 12, unzip, 0xFFFF0000, 0xAAAAAAAA );

  #-------------------------------------------------------------
  # Bypassing tests
  #-------------------------------------------------------------

  TEST_R_DEST_BYPASS( 13, 0, unzip, 0x0000FFFF, 0x55555555 );
  TEST_R_DEST_BYPASS( 14, 1, unzip, 0x0000FFFF, 0x55555555 );
  TEST_R_DEST_BYPASS( 15, 2, unzip, 0x0000FFFF, 0x55555555 );
  TEST_R_DEST_BYPASS( 16, 3, unzip, 0x0000FFFF, 0x55555555 );
  
  TEST_R_DEST_BYPASS( 17, 0, unzip, 0xFFFF0000, 0xAAAAAAAA );
  TEST_R_DEST_BYPASS( 18, 1, unzip, 0xFFFF0000, 0xAAAAAAAA );
  TEST_R_DEST_BYPASS( 19, 2, unzip, 0xFFFF0000, 0xAAAAAAAA );
  TEST_R_DEST_BYPASS( 20, 3, unzip, 0xFFFF0000, 0xAAAAAAAA );

  TEST_R_DEST_BYPASS( 21, 0, unzip, 0xAAAA5555, 0x99999999 );
  TEST_R_DEST_BYPASS( 22, 1, unzip, 0xAAAA5555, 0x99999999 );
  TEST_R_DEST_BYPASS( 23, 2, unzip, 0xAAAA5555, 0x99999999 );
  TEST_R_DEST_BYPASS( 24, 3, unzip, 0xAAAA5555, 0x99999999 );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN
  TEST_DATA
RVTEST_DATA_END