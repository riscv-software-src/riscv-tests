# See LICENSE for license details.

#*****************************************************************************
# zip.S
#-----------------------------------------------------------------------------
#
# Test zip instruction.
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV32U
RVTEST_CODE_BEGIN

  #-------------------------------------------------------------
  # Arithmetic tests
  #-------------------------------------------------------------

  TEST_R_OP( 2, zip, 0x55555555, 0x0000FFFF );
  TEST_R_OP( 3, zip, 0xAAAAAAAA, 0xFFFF0000 );
  TEST_R_OP( 4, zip, 0x00000000, 0x00000000 );
  TEST_R_OP( 5, zip, 0xFFFFFFFF, 0xFFFFFFFF );
  TEST_R_OP( 6, zip, 0x99999999, 0xAAAA5555 );
  TEST_R_OP( 7, zip, 0x00FF00FF, 0x0F0F0F0F );
  TEST_R_OP( 8, zip, 0xDEADBEEF, 0xBEFFE36B );

  #-------------------------------------------------------------
  # Source/Destination tests
  #-------------------------------------------------------------

  TEST_R_SRC1_EQ_DEST( 11, zip, 0x55555555, 0x0000FFFF );
  TEST_R_SRC1_EQ_DEST( 12, zip, 0xAAAAAAAA, 0xFFFF0000 );

  #-------------------------------------------------------------
  # Bypassing tests
  #-------------------------------------------------------------

  TEST_R_DEST_BYPASS( 13, 0, zip, 0x55555555, 0x0000FFFF );
  TEST_R_DEST_BYPASS( 14, 1, zip, 0x55555555, 0x0000FFFF );
  TEST_R_DEST_BYPASS( 15, 2, zip, 0x55555555, 0x0000FFFF );
  TEST_R_DEST_BYPASS( 16, 3, zip, 0x55555555, 0x0000FFFF );

  TEST_R_DEST_BYPASS( 17, 0, zip, 0xAAAAAAAA, 0xFFFF0000 );
  TEST_R_DEST_BYPASS( 18, 1, zip, 0xAAAAAAAA, 0xFFFF0000 );
  TEST_R_DEST_BYPASS( 19, 2, zip, 0xAAAAAAAA, 0xFFFF0000 );
  TEST_R_DEST_BYPASS( 20, 3, zip, 0xAAAAAAAA, 0xFFFF0000 );

  TEST_R_DEST_BYPASS( 21, 0, zip, 0x99999999, 0xAAAA5555 );
  TEST_R_DEST_BYPASS( 22, 1, zip, 0x99999999, 0xAAAA5555 );
  TEST_R_DEST_BYPASS( 23, 2, zip, 0x99999999, 0xAAAA5555 );
  TEST_R_DEST_BYPASS( 24, 3, zip, 0x99999999, 0xAAAA5555 );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN
  TEST_DATA
RVTEST_DATA_END