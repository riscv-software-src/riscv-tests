# See LICENSE for license details.

#*****************************************************************************
# rolw.S
#-----------------------------------------------------------------------------
#
# Test rolw instruction.
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV64U
RVTEST_CODE_BEGIN

  #-------------------------------------------------------------
  # Arithmetic tests
  #-------------------------------------------------------------

  TEST_RR_OP( 2,  rolw, 0x0000000000000001, 0x0000000000000001, 0  );
  TEST_RR_OP( 3,  rolw, 0x0000000000000002, 0x0000000000000001, 1  );
  TEST_RR_OP( 4,  rolw, 0x0000000000000080, 0x0000000000000001, 7  );
  TEST_RR_OP( 5,  rolw, 0x0000000000004000, 0x0000000000000001, 14 );
  TEST_RR_OP( 6,  rolw, 0xffffffff80000000, 0x0000000000000001, 31 );

  TEST_RR_OP( 7,  rolw, 0xffffffffffffffff, 0xffffffffffffffff, 0  );
  TEST_RR_OP( 8,  rolw, 0xffffffffffffffff, 0xffffffffffffffff, 1  );
  TEST_RR_OP( 9,  rolw, 0xffffffffffffffff, 0xffffffffffffffff, 7  );
  TEST_RR_OP( 10, rolw, 0xffffffffffffffff, 0xffffffffffffffff, 14 );
  TEST_RR_OP( 11, rolw, 0xffffffffffffffff, 0xffffffffffffffff, 31 );

  TEST_RR_OP( 12, rolw, 0x0000000021212121, 0x0000000021212121, 0  );
  TEST_RR_OP( 13, rolw, 0x0000000042424242, 0x0000000021212121, 1  );
  TEST_RR_OP( 14, rolw, 0xffffffff90909090, 0x0000000021212121, 7  );
  TEST_RR_OP( 15, rolw, 0x0000000048484848, 0x0000000021212121, 14 );
  TEST_RR_OP( 16, rolw, 0xffffffff90909090, 0x0000000021212121, 31 );

  # Verify that rotates only use bottom five bits

  TEST_RR_OP( 17, rolw, 0x0000000021212121, 0x0000000021212121, 0xffffffffffffffe0 );
  TEST_RR_OP( 18, rolw, 0x0000000042424242, 0x0000000021212121, 0xffffffffffffffe1 );
  TEST_RR_OP( 19, rolw, 0xffffffff90909090, 0x0000000021212121, 0xffffffffffffffe7 );
  TEST_RR_OP( 20, rolw, 0x0000000048484848, 0x0000000021212121, 0xffffffffffffffee );
  TEST_RR_OP( 21, rolw, 0xffffffff90909090, 0x0000000021212121, 0xffffffffffffffff );

  # Verify that rotates ignore top 32 (using true 64-bit values)

  TEST_RR_OP( 44, rolw, 0x0000000012345678, 0xffffffff12345678, 0 );
  TEST_RR_OP( 45, rolw, 0x0000000023456781, 0xffffffff12345678, 4 );
  TEST_RR_OP( 46, rolw, 0xffffffff92345678, 0x0000000092345678, 0 );
  TEST_RR_OP( 47, rolw, 0xffffffff93456789, 0x0000000099345678, 4 );

  #-------------------------------------------------------------
  # Source/Destination tests
  #-------------------------------------------------------------

  TEST_RR_SRC1_EQ_DEST( 22, rolw, 0x00000080, 0x00000001, 7  );
  TEST_RR_SRC2_EQ_DEST( 23, rolw, 0x00004000, 0x00000001, 14 );
  TEST_RR_SRC12_EQ_DEST( 24, rolw, 24, 3 );

  #-------------------------------------------------------------
  # Bypassing tests
  #-------------------------------------------------------------

  TEST_RR_DEST_BYPASS( 25, 0, rolw, 0x0000000000000080, 0x0000000000000001, 7  );
  TEST_RR_DEST_BYPASS( 26, 1, rolw, 0x0000000000004000, 0x0000000000000001, 14 );
  TEST_RR_DEST_BYPASS( 27, 2, rolw, 0xffffffff80000000, 0x0000000000000001, 31 );

  TEST_RR_SRC12_BYPASS( 28, 0, 0, rolw, 0x0000000000000080, 0x0000000000000001, 7  );
  TEST_RR_SRC12_BYPASS( 29, 0, 1, rolw, 0x0000000000004000, 0x0000000000000001, 14 );
  TEST_RR_SRC12_BYPASS( 30, 0, 2, rolw, 0xffffffff80000000, 0x0000000000000001, 31 );
  TEST_RR_SRC12_BYPASS( 31, 1, 0, rolw, 0x0000000000000080, 0x0000000000000001, 7  );
  TEST_RR_SRC12_BYPASS( 32, 1, 1, rolw, 0x0000000000004000, 0x0000000000000001, 14 );
  TEST_RR_SRC12_BYPASS( 33, 2, 0, rolw, 0xffffffff80000000, 0x0000000000000001, 31 );

  TEST_RR_SRC21_BYPASS( 34, 0, 0, rolw, 0x0000000000000080, 0x0000000000000001, 7  );
  TEST_RR_SRC21_BYPASS( 35, 0, 1, rolw, 0x0000000000004000, 0x0000000000000001, 14 );
  TEST_RR_SRC21_BYPASS( 36, 0, 2, rolw, 0xffffffff80000000, 0x0000000000000001, 31 );
  TEST_RR_SRC21_BYPASS( 37, 1, 0, rolw, 0x0000000000000080, 0x0000000000000001, 7  );
  TEST_RR_SRC21_BYPASS( 38, 1, 1, rolw, 0x0000000000004000, 0x0000000000000001, 14 );
  TEST_RR_SRC21_BYPASS( 39, 2, 0, rolw, 0xffffffff80000000, 0x0000000000000001, 31 );

  TEST_RR_ZEROSRC1( 40, rolw, 0, 15 );
  TEST_RR_ZEROSRC2( 41, rolw, 32, 32 );
  TEST_RR_ZEROSRC12( 42, rolw, 0 );
  TEST_RR_ZERODEST( 43, rolw, 1024, 2048 );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END
