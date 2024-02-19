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

  TEST_IMM_OP( 2,  roriw, 0x0000000000000001, 0x0000000000000001, 0  );
  TEST_IMM_OP( 3,  roriw, 0xffffffff80000000, 0x0000000000000001, 1  );
  TEST_IMM_OP( 4,  roriw, 0x0000000002000000, 0x0000000000000001, 7  );
  TEST_IMM_OP( 5,  roriw, 0x0000000000040000, 0x0000000000000001, 14 );
  TEST_IMM_OP( 6,  roriw, 0x0000000000000002, 0x0000000000000001, 31 );

  TEST_IMM_OP( 7,  roriw, 0xffffffffffffffff, 0xffffffffffffffff, 0  );
  TEST_IMM_OP( 8,  roriw, 0xffffffffffffffff, 0xffffffffffffffff, 1  );
  TEST_IMM_OP( 9,  roriw, 0xffffffffffffffff, 0xffffffffffffffff, 7  );
  TEST_IMM_OP( 10, roriw, 0xffffffffffffffff, 0xffffffffffffffff, 14 );
  TEST_IMM_OP( 11, roriw, 0xffffffffffffffff, 0xffffffffffffffff, 31 );

  TEST_IMM_OP( 12, roriw, 0x0000000021212121, 0x0000000021212121, 0  );
  TEST_IMM_OP( 13, roriw, 0xffffffff90909090, 0x0000000021212121, 1  );
  TEST_IMM_OP( 14, roriw, 0x0000000042424242, 0x0000000021212121, 7  );
  TEST_IMM_OP( 15, roriw, 0xffffffff84848484, 0x0000000021212121, 14 );
  TEST_IMM_OP( 16, roriw, 0x0000000042424242, 0x0000000021212121, 31 );

  #-------------------------------------------------------------
  # Source/Destination tests
  #-------------------------------------------------------------

  TEST_IMM_SRC1_EQ_DEST( 20, roriw, 0x0000000002000000, 0x00000001, 7  );

  #-------------------------------------------------------------
  # Bypassing tests
  #-------------------------------------------------------------

  TEST_IMM_DEST_BYPASS( 21, 0, roriw, 0x0000000002000000, 0x0000000000000001, 7  );
  TEST_IMM_DEST_BYPASS( 22, 1, roriw, 0x0000000000040000, 0x0000000000000001, 14 );
  TEST_IMM_DEST_BYPASS( 23, 2, roriw, 0x0000000000000002, 0x0000000000000001, 31 );

  TEST_IMM_SRC1_BYPASS( 24, 0, roriw, 0x0000000002000000, 0x0000000000000001, 7  );
  TEST_IMM_SRC1_BYPASS( 25, 1, roriw, 0x0000000000040000, 0x0000000000000001, 14 );
  TEST_IMM_SRC1_BYPASS( 26, 2, roriw, 0x0000000000000002, 0x0000000000000001, 31 );

  TEST_IMM_ZEROSRC1( 27, roriw, 0, 31 );
  TEST_IMM_ZERODEST( 28, roriw, 33, 20 );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END
