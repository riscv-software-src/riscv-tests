# See LICENSE for license details.

#*****************************************************************************
# bclri.S
#-----------------------------------------------------------------------------
#
# Test bclri instruction.
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV64U
RVTEST_CODE_BEGIN

  #-------------------------------------------------------------
  # Arithmetic tests
  #-------------------------------------------------------------

  TEST_IMM_OP( 2,  bclri, 0xff00ff00, 0xff00ff00, 0  );
  TEST_IMM_OP( 3,  bclri, 0x00ff00fd, 0x00ff00ff, 1  );
  TEST_IMM_OP( 4,  bclri, 0xff00fe00, 0xff00ff00, 8  );
  TEST_IMM_OP( 5,  bclri, 0x0ff00ff0, 0x0ff00ff0, 14 );
  TEST_IMM_OP( 6,  bclri, 0x07f00ff0, 0x0ff00ff0, 27 );

  TEST_IMM_OP( 7,  bclri, 0xfffffffffffffffe, 0xffffffffffffffff, 0  );
  TEST_IMM_OP( 8,  bclri, 0xfffffffffffffffd, 0xffffffffffffffff, 1  );
  TEST_IMM_OP( 9,  bclri, 0xffffffffffffff7f, 0xffffffffffffffff, 7  );
  TEST_IMM_OP( 10, bclri, 0xffffffffffffbfff, 0xffffffffffffffff, 14 );
  TEST_IMM_OP( 11, bclri, 0xfffffffff7ffffff, 0xffffffffffffffff, 27 );

  TEST_IMM_OP( 12, bclri, 0x21212120, 0x21212121, 0  );
  TEST_IMM_OP( 13, bclri, 0x21212121, 0x21212121, 1  );
  TEST_IMM_OP( 14, bclri, 0x21212121, 0x21212121, 7  );
  TEST_IMM_OP( 15, bclri, 0x21210121, 0x21212121, 13 );
  TEST_IMM_OP( 16, bclri, 0x04848484, 0x84848484, 31 );

#if __riscv_xlen == 64
  TEST_IMM_OP( 50, bclri, 0x0000000000000001, 0x0000000000000001, 63 );
  TEST_IMM_OP( 51, bclri, 0xffffff7fffffffff, 0xffffffffffffffff, 39 );
  TEST_IMM_OP( 52, bclri, 0xfffff7ff00000000, 0xffffffff00000000, 43 );
#endif

  #-------------------------------------------------------------
  # Source/Destination tests
  #-------------------------------------------------------------

  TEST_IMM_SRC1_EQ_DEST( 17, bclri, 0x00000001, 0x00000001, 7 );

  #-------------------------------------------------------------
  # Bypassing tests
  #-------------------------------------------------------------

  TEST_IMM_DEST_BYPASS( 18, 0, bclri, 0xff00fe00, 0xff00ff00, 8  );
  TEST_IMM_DEST_BYPASS( 19, 1, bclri, 0x0ff00ff0, 0x0ff00ff0, 14 );
  TEST_IMM_DEST_BYPASS( 20, 2, bclri, 0x07f00ff0, 0x0ff00ff0, 27 );

  TEST_IMM_SRC1_BYPASS( 21, 0, bclri, 0xff00fe00, 0xff00ff00, 8  );
  TEST_IMM_SRC1_BYPASS( 22, 1, bclri, 0x0ff00ff0, 0x0ff00ff0, 14 );
  TEST_IMM_SRC1_BYPASS( 23, 2, bclri, 0x07f00ff0, 0x0ff00ff0, 27 );

  TEST_IMM_ZEROSRC1( 24, bclri, 0, 31 );
  TEST_IMM_ZERODEST( 25, bclri, 33, 20 );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END
