# See LICENSE for license details.

#*****************************************************************************
# xperm8.S
#-----------------------------------------------------------------------------
#
# Test xperm8 instruction.
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV32U
RVTEST_CODE_BEGIN

  #-------------------------------------------------------------
  # Arithmetic tests
  #-------------------------------------------------------------

  TEST_RR_OP( 2, xperm8, 0x02010000, 0x00010203, 0x01020304 );
  TEST_RR_OP( 3, xperm8, 0x88776655, 0x88776655, 0x03020100 );
  TEST_RR_OP( 4, xperm8, 0xEFBEADDE, 0xDEADBEEF, 0x00010203 );
  TEST_RR_OP( 5, xperm8, 0xBABABABA, 0xCAFEBABE, 0x01010101 );

  TEST_RR_OP( 6, xperm8, 0x34783478, 0x12345678, 0x02000200 );
  TEST_RR_OP( 7, xperm8, 0x00AA00DD, 0xAABBCCDD, 0x0403FF00 );
  TEST_RR_OP( 8, xperm8, 0x00FF00FF, 0xFFFFFFFF, 0x04030403 );
  TEST_RR_OP( 9, xperm8, 0x00000000, 0xFFFFFFFF, 0x07060504 );

  #-------------------------------------------------------------
  # Source/Destination tests
  #-------------------------------------------------------------

  TEST_RR_SRC1_EQ_DEST( 10, xperm8, 0xEFBEADDE, 0xDEADBEEF, 0x00010203 );
  TEST_RR_SRC2_EQ_DEST( 11, xperm8, 0xEFBEADDE, 0xDEADBEEF, 0x00010203 );
  TEST_RR_SRC12_EQ_DEST( 12, xperm8, 0x03020100, 0x03020100 );

  #-------------------------------------------------------------
  # Bypassing tests
  #-------------------------------------------------------------

  TEST_RR_DEST_BYPASS( 13, 0, xperm8, 0xEFBEADDE, 0xDEADBEEF, 0x00010203 );
  TEST_RR_DEST_BYPASS( 14, 1, xperm8, 0xEFBEADDE, 0xDEADBEEF, 0x00010203 );
  TEST_RR_DEST_BYPASS( 15, 2, xperm8, 0xEFBEADDE, 0xDEADBEEF, 0x00010203 );

  TEST_RR_SRC12_BYPASS( 16, 0, 0, xperm8, 0xEFBEADDE, 0xDEADBEEF, 0x00010203 );
  TEST_RR_SRC12_BYPASS( 17, 0, 1, xperm8, 0xEFBEADDE, 0xDEADBEEF, 0x00010203 );
  TEST_RR_SRC12_BYPASS( 18, 0, 2, xperm8, 0xEFBEADDE, 0xDEADBEEF, 0x00010203 );
  TEST_RR_SRC12_BYPASS( 19, 1, 0, xperm8, 0xEFBEADDE, 0xDEADBEEF, 0x00010203 );
  TEST_RR_SRC12_BYPASS( 20, 1, 1, xperm8, 0xEFBEADDE, 0xDEADBEEF, 0x00010203 );
  TEST_RR_SRC12_BYPASS( 21, 2, 0, xperm8, 0xEFBEADDE, 0xDEADBEEF, 0x00010203 );

  TEST_RR_SRC21_BYPASS( 22, 0, 0, xperm8, 0xEFBEADDE, 0xDEADBEEF, 0x00010203 );
  TEST_RR_SRC21_BYPASS( 23, 0, 1, xperm8, 0xEFBEADDE, 0xDEADBEEF, 0x00010203 );
  TEST_RR_SRC21_BYPASS( 24, 0, 2, xperm8, 0xEFBEADDE, 0xDEADBEEF, 0x00010203 );
  TEST_RR_SRC21_BYPASS( 25, 1, 0, xperm8, 0xEFBEADDE, 0xDEADBEEF, 0x00010203 );
  TEST_RR_SRC21_BYPASS( 26, 1, 1, xperm8, 0xEFBEADDE, 0xDEADBEEF, 0x00010203 );
  TEST_RR_SRC21_BYPASS( 27, 2, 0, xperm8, 0xEFBEADDE, 0xDEADBEEF, 0x00010203 );

  TEST_RR_ZEROSRC1( 28, xperm8, 0x00000000, 0x12345678 );
  TEST_RR_ZEROSRC2( 29, xperm8, 0xBEBEBEBE, 0xCAFEBABE );
  TEST_RR_ZEROSRC12( 30, xperm8, 0x00000000 );
  TEST_RR_ZERODEST( 31, xperm8, 0xDEADBEEF, 0x00010203 );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN
  TEST_DATA
RVTEST_DATA_END
