# See LICENSE for license details.

#*****************************************************************************
# bclr.S
#-----------------------------------------------------------------------------
#
# Test bclr instruction.
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV64U
RVTEST_CODE_BEGIN

  #-------------------------------------------------------------
  # Arithmetic tests
  #-------------------------------------------------------------

  TEST_RR_OP( 2,  bclr, 0xff00ff00, 0xff00ff00, 0  );
  TEST_RR_OP( 3,  bclr, 0x00ff00fd, 0x00ff00ff, 1  );
  TEST_RR_OP( 4,  bclr, 0xff00fe00, 0xff00ff00, 8  );
  TEST_RR_OP( 5,  bclr, 0x0ff00ff0, 0x0ff00ff0, 14 );
  TEST_RR_OP( 6,  bclr, 0x07f00ff0, 0x0ff00ff0, 27 );

  TEST_RR_OP( 7,  bclr, 0xfffffffffffffffe, 0xffffffffffffffff, 0  );
  TEST_RR_OP( 8,  bclr, 0xfffffffffffffffd, 0xffffffffffffffff, 1  );
  TEST_RR_OP( 9,  bclr, 0xffffffffffffff7f, 0xffffffffffffffff, 7  );
  TEST_RR_OP( 10, bclr, 0xffffffffffffbfff, 0xffffffffffffffff, 14 );
  TEST_RR_OP( 11, bclr, 0xfffffffff7ffffff, 0xffffffffffffffff, 27 );

  TEST_RR_OP( 12, bclr, 0x21212120, 0x21212121, 0  );
  TEST_RR_OP( 13, bclr, 0x21212121, 0x21212121, 1  );
  TEST_RR_OP( 14, bclr, 0x21212121, 0x21212121, 7  );
  TEST_RR_OP( 15, bclr, 0x21210121, 0x21212121, 13 );
  TEST_RR_OP( 16, bclr, 0x04848484, 0x84848484, 31 );

  # Verify that shifts only use bottom six(rv64) or five(rv32) bits

  TEST_RR_OP( 17, bclr, 0x21212120, 0x21212121, 0xffffffffffffffc0 );
  TEST_RR_OP( 18, bclr, 0x21212121, 0x21212121, 0xffffffffffffffc1 );
  TEST_RR_OP( 19, bclr, 0x21212121, 0x21212121, 0xffffffffffffffc7 );
  TEST_RR_OP( 20, bclr, 0x84848484, 0x84848484, 0xffffffffffffffce );

#if __riscv_xlen == 64
  TEST_RR_OP( 21, bclr, 0x4484848421212121, 0xc484848421212121, 0xffffffffffffffff );
  TEST_RR_OP( 50, bclr, 0x0000000000000001, 0x0000000000000001, 63 );
  TEST_RR_OP( 51, bclr, 0xffffff7fffffffff, 0xffffffffffffffff, 39 );
  TEST_RR_OP( 52, bclr, 0xfffff7ff00000000, 0xffffffff00000000, 43 );
#endif

  #-------------------------------------------------------------
  # Source/Destination tests
  #-------------------------------------------------------------

  TEST_RR_SRC1_EQ_DEST( 22, bclr, 0x00000001, 0x00000001, 7  );
  TEST_RR_SRC2_EQ_DEST( 23, bclr, 0x00001551, 0x00005551, 14 );
  TEST_RR_SRC12_EQ_DEST( 24, bclr, 3, 3 );

  #-------------------------------------------------------------
  # Bypassing tests
  #-------------------------------------------------------------

  TEST_RR_DEST_BYPASS( 25, 0, bclr, 0xff00ff00, 0xff00ff00, 0  );
  TEST_RR_DEST_BYPASS( 26, 1, bclr, 0x00ff00fd, 0x00ff00ff, 1  );
  TEST_RR_DEST_BYPASS( 27, 2, bclr, 0xff00fe00, 0xff00ff00, 8  );

  TEST_RR_SRC12_BYPASS( 28, 0, 0, bclr, 0xff00ff00, 0xff00ff00, 0  );
  TEST_RR_SRC12_BYPASS( 29, 0, 1, bclr, 0x00ff00fd, 0x00ff00ff, 1  );
  TEST_RR_SRC12_BYPASS( 30, 0, 2, bclr, 0xff00fe00, 0xff00ff00, 8  );
  TEST_RR_SRC12_BYPASS( 31, 1, 0, bclr, 0xff00ff00, 0xff00ff00, 0  );
  TEST_RR_SRC12_BYPASS( 32, 1, 1, bclr, 0x00ff00fd, 0x00ff00ff, 1  );
  TEST_RR_SRC12_BYPASS( 33, 2, 0, bclr, 0xff00fe00, 0xff00ff00, 8  );

  TEST_RR_SRC21_BYPASS( 34, 0, 0, bclr, 0xff00fe00, 0xff00ff00, 8  );
  TEST_RR_SRC21_BYPASS( 35, 0, 1, bclr, 0x0ff00ff0, 0x0ff00ff0, 14 );
  TEST_RR_SRC21_BYPASS( 36, 0, 2, bclr, 0x07f00ff0, 0x0ff00ff0, 27 );
  TEST_RR_SRC21_BYPASS( 37, 1, 0, bclr, 0xff00fe00, 0xff00ff00, 8  );
  TEST_RR_SRC21_BYPASS( 38, 1, 1, bclr, 0x0ff00ff0, 0x0ff00ff0, 14 );
  TEST_RR_SRC21_BYPASS( 39, 2, 0, bclr, 0x07f00ff0, 0x0ff00ff0, 27 );

  TEST_RR_ZEROSRC1( 40, bclr, 0, 15 );
  TEST_RR_ZEROSRC2( 41, bclr, 32, 32 );
  TEST_RR_ZEROSRC12( 42, bclr, 0 );
  TEST_RR_ZERODEST( 43, bclr, 1024, 2048 );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END
