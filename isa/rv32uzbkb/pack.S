# See LICENSE for license details.

#*****************************************************************************
# pack.S
#-----------------------------------------------------------------------------
#
# Test pack instruction.
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV32U
RVTEST_CODE_BEGIN

  #-------------------------------------------------------------
  # Arithmetic tests
  #-------------------------------------------------------------

  TEST_RR_OP( 2, pack, 0xDEF05678, 0x12345678, 0x9ABCDEF0 );
  TEST_RR_OP( 3, pack, 0x0000FFFF, 0x0000FFFF, 0xFFFF0000 );
  TEST_RR_OP( 4, pack, 0xFFFFFFFF, 0xFFFFFFFF, 0xFFFFFFFF );
  TEST_RR_OP( 5, pack, 0x00000000, 0x00000000, 0x00000000 );
  TEST_RR_OP( 6, pack, 0x5555AAAA, 0xAAAAAAAA, 0x55555555 );

  #-------------------------------------------------------------
  # Source/Destination tests
  #-------------------------------------------------------------

  TEST_RR_SRC1_EQ_DEST( 7, pack, 0xDEF05678, 0x12345678, 0x9ABCDEF0 );
  TEST_RR_SRC2_EQ_DEST( 8, pack, 0xDEF05678, 0x12345678, 0x9ABCDEF0 );
  TEST_RR_SRC12_EQ_DEST( 9, pack, 0xFFFFFFFF, 0xFFFFFFFF );

  #-------------------------------------------------------------
  # Bypassing tests
  #-------------------------------------------------------------

  TEST_RR_DEST_BYPASS( 10, 0, pack, 0xDEF05678, 0x12345678, 0x9ABCDEF0 );
  TEST_RR_DEST_BYPASS( 11, 1, pack, 0x0000FFFF, 0x0000FFFF, 0xFFFF0000 );
  TEST_RR_DEST_BYPASS( 12, 2, pack, 0xFFFFFFFF, 0xFFFFFFFF, 0xFFFFFFFF );

  TEST_RR_SRC12_BYPASS( 13, 0, 0, pack, 0xDEF05678, 0x12345678, 0x9ABCDEF0 );
  TEST_RR_SRC12_BYPASS( 14, 0, 1, pack, 0xFFFFFFFF, 0x0000FFFF, 0x0000FFFF );
  TEST_RR_SRC12_BYPASS( 15, 0, 2, pack, 0xFFFFFFFF, 0x0000FFFF, 0x0000FFFF );
  TEST_RR_SRC12_BYPASS( 16, 1, 0, pack, 0xDEF05678, 0x12345678, 0x9ABCDEF0 );
  TEST_RR_SRC12_BYPASS( 17, 1, 1, pack, 0xFFFFFFFF, 0x0000FFFF, 0x0000FFFF );
  TEST_RR_SRC12_BYPASS( 18, 2, 0, pack, 0xFFFFFFFF, 0x0000FFFF, 0x0000FFFF );

  TEST_RR_SRC21_BYPASS( 19, 0, 0, pack, 0xDEF05678, 0x12345678, 0x9ABCDEF0 );
  TEST_RR_SRC21_BYPASS( 20, 0, 1, pack, 0xFFFFFFFF, 0x0000FFFF, 0x0000FFFF );
  TEST_RR_SRC21_BYPASS( 21, 0, 2, pack, 0xFFFFFFFF, 0xFFFFFFFF, 0xFFFFFFFF );
  TEST_RR_SRC21_BYPASS( 22, 1, 0, pack, 0xDEF05678, 0x12345678, 0x9ABCDEF0 );
  TEST_RR_SRC21_BYPASS( 23, 1, 1, pack, 0xFFFFFFFF, 0x0000FFFF, 0x0000FFFF );
  TEST_RR_SRC21_BYPASS( 24, 2, 0, pack, 0xFFFFFFFF, 0xFFFFFFFF, 0xFFFFFFFF );

  TEST_RR_ZEROSRC1( 25, pack, 0xDEF00000, 0x9ABCDEF0 );
  TEST_RR_ZEROSRC2( 26, pack, 0x00005678, 0x12345678 );
  TEST_RR_ZEROSRC12( 27, pack, 0x00000000 );
  TEST_RR_ZERODEST( 28, pack, 0x12345678, 0x9ABCDEF0 );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN
  TEST_DATA
RVTEST_DATA_END
