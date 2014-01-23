#*****************************************************************************
# srl.S
#-----------------------------------------------------------------------------
#
# Test srl instruction.
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV32U
RVTEST_CODE_BEGIN

  #-------------------------------------------------------------
  # Arithmetic tests
  #-------------------------------------------------------------

  TEST_RR_OP( 2,  srl, 0x80000000, 0x80000000, 0  );
  TEST_RR_OP( 3,  srl, 0xc0000000, 0x80000000, 1  );
  TEST_RR_OP( 4,  srl, 0xff000000, 0x80000000, 7  );
  TEST_RR_OP( 5,  srl, 0xfffe0000, 0x80000000, 14 );
  TEST_RR_OP( 6,  srl, 0xffffffff, 0x80000001, 31 );

  TEST_RR_OP( 7,  srl, 0xffffffff, 0xffffffff, 0  );
  TEST_RR_OP( 8,  srl, 0xffffffff, 0xffffffff, 1  );
  TEST_RR_OP( 9,  srl, 0xffffffff, 0xffffffff, 7  );
  TEST_RR_OP( 10, srl, 0xffffffff, 0xffffffff, 14 );
  TEST_RR_OP( 11, srl, 0xffffffff, 0xffffffff, 31 );

  TEST_RR_OP( 12, srl, 0x21212121, 0x21212121, 0  );
  TEST_RR_OP( 13, srl, 0x10909090, 0x21212121, 1  );
  TEST_RR_OP( 14, srl, 0x00424242, 0x21212121, 7  );
  TEST_RR_OP( 15, srl, 0x00008484, 0x21212121, 14 );
  TEST_RR_OP( 16, srl, 0x00000000, 0x21212121, 31 );

  # Verify that shifts only use bottom five bits

  TEST_RR_OP( 17, srl, 0x21212121, 0x21212121, 0xffffffc0 );
  TEST_RR_OP( 18, srl, 0x10909090, 0x21212121, 0xffffffc1 );
  TEST_RR_OP( 19, srl, 0x00424242, 0x21212121, 0xffffffc7 );
  TEST_RR_OP( 20, srl, 0x00008484, 0x21212121, 0xffffffce );
  TEST_RR_OP( 21, srl, 0x00000000, 0x21212121, 0xffffffff );

  #-------------------------------------------------------------
  # Source/Destination tests
  #-------------------------------------------------------------

  TEST_RR_SRC1_EQ_DEST( 22, srl, 0xff000000, 0x80000000, 7  );
  TEST_RR_SRC2_EQ_DEST( 23, srl, 0xfffe0000, 0x80000000, 14 );
  TEST_RR_SRC12_EQ_DEST( 24, srl, 0, 7 );

  #-------------------------------------------------------------
  # Bypassing tests
  #-------------------------------------------------------------

  TEST_RR_DEST_BYPASS( 25, 0, srl, 0xff000000, 0x80000000, 7  );
  TEST_RR_DEST_BYPASS( 26, 1, srl, 0xfffe0000, 0x80000000, 14 );
  TEST_RR_DEST_BYPASS( 27, 2, srl, 0xffffffff, 0x80000000, 31 );

  TEST_RR_SRC12_BYPASS( 28, 0, 0, srl, 0xff000000, 0x80000000, 7  );
  TEST_RR_SRC12_BYPASS( 29, 0, 1, srl, 0xfffe0000, 0x80000000, 14 );
  TEST_RR_SRC12_BYPASS( 30, 0, 2, srl, 0xffffffff, 0x80000000, 31 );
  TEST_RR_SRC12_BYPASS( 31, 1, 0, srl, 0xff000000, 0x80000000, 7  );
  TEST_RR_SRC12_BYPASS( 32, 1, 1, srl, 0xfffe0000, 0x80000000, 14 );
  TEST_RR_SRC12_BYPASS( 33, 2, 0, srl, 0xffffffff, 0x80000000, 31 );

  TEST_RR_SRC21_BYPASS( 34, 0, 0, srl, 0xff000000, 0x80000000, 7  );
  TEST_RR_SRC21_BYPASS( 35, 0, 1, srl, 0xfffe0000, 0x80000000, 14 );
  TEST_RR_SRC21_BYPASS( 36, 0, 2, srl, 0xffffffff, 0x80000000, 31 );
  TEST_RR_SRC21_BYPASS( 37, 1, 0, srl, 0xff000000, 0x80000000, 7  );
  TEST_RR_SRC21_BYPASS( 38, 1, 1, srl, 0xfffe0000, 0x80000000, 14 );
  TEST_RR_SRC21_BYPASS( 39, 2, 0, srl, 0xffffffff, 0x80000000, 31 );

  TEST_RR_ZEROSRC1( 40, srl, 0, 15 );
  TEST_RR_ZEROSRC2( 41, srl, 32, 32 );
  TEST_RR_ZEROSRC12( 42, srl, 0 );
  TEST_RR_ZERODEST( 43, srl, 1024, 2048 );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END
