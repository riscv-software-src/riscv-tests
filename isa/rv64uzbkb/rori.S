# See LICENSE for license details.

#*****************************************************************************
# rori.S
#-----------------------------------------------------------------------------
#
# Test rori instruction.
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV64U
RVTEST_CODE_BEGIN

  #-------------------------------------------------------------
  # Arithmetic tests
  #-------------------------------------------------------------

  TEST_IMM_OP( 2,  rori, 0x0000000000000001, 0x0000000000000001, 0  );
  TEST_IMM_OP( 3,  rori, 0x8000000000000000, 0x0000000000000001, 1  );
  TEST_IMM_OP( 4,  rori, 0x0200000000000000, 0x0000000000000001, 7  );
  TEST_IMM_OP( 5,  rori, 0x0004000000000000, 0x0000000000000001, 14 );
  TEST_IMM_OP( 6,  rori, 0x0000000200000000, 0x0000000000000001, 31 );

  TEST_IMM_OP( 7,  rori, 0xffffffffffffffff, 0xffffffffffffffff, 0  );
  TEST_IMM_OP( 8,  rori, 0xffffffffffffffff, 0xffffffffffffffff, 1  );
  TEST_IMM_OP( 9,  rori, 0xffffffffffffffff, 0xffffffffffffffff, 7  );
  TEST_IMM_OP( 10, rori, 0xffffffffffffffff, 0xffffffffffffffff, 14 );
  TEST_IMM_OP( 11, rori, 0xffffffffffffffff, 0xffffffffffffffff, 31 );

  TEST_IMM_OP( 12, rori, 0x0000000021212121, 0x0000000021212121, 0  );
  TEST_IMM_OP( 13, rori, 0x8000000010909090, 0x0000000021212121, 1  );
  TEST_IMM_OP( 14, rori, 0x4200000000424242, 0x0000000021212121, 7  );
  TEST_IMM_OP( 15, rori, 0x8484000000008484, 0x0000000021212121, 14 );
  TEST_IMM_OP( 16, rori, 0x4242424200000000, 0x0000000021212121, 31 );

  TEST_IMM_OP( 17, rori, 0x0000000000000002, 0x0000000000000001, 63 );
  TEST_IMM_OP( 18, rori, 0xffffffffffffffff, 0xffffffffffffffff, 39 );
  TEST_IMM_OP( 19, rori, 0x0004242424200000, 0x0000000021212121, 43 );

  #-------------------------------------------------------------
  # Source/Destination tests
  #-------------------------------------------------------------

  TEST_IMM_SRC1_EQ_DEST( 20, rori, 0x0200000000000000, 0x00000001, 7  );

  #-------------------------------------------------------------
  # Bypassing tests
  #-------------------------------------------------------------

  TEST_IMM_DEST_BYPASS( 21, 0, rori, 0x0200000000000000, 0x0000000000000001, 7  );
  TEST_IMM_DEST_BYPASS( 22, 1, rori, 0x0004000000000000, 0x0000000000000001, 14 );
  TEST_IMM_DEST_BYPASS( 23, 2, rori, 0x0000000200000000, 0x0000000000000001, 31 );

  TEST_IMM_SRC1_BYPASS( 24, 0, rori, 0x0200000000000000, 0x0000000000000001, 7  );
  TEST_IMM_SRC1_BYPASS( 25, 1, rori, 0x0004000000000000, 0x0000000000000001, 14 );
  TEST_IMM_SRC1_BYPASS( 26, 2, rori, 0x0000000200000000, 0x0000000000000001, 31 );

  TEST_IMM_ZEROSRC1( 27, rori, 0, 31 );
  TEST_IMM_ZERODEST( 28, rori, 33, 20 );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END
