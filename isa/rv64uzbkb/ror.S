# See LICENSE for license details.

#*****************************************************************************
# ror.S
#-----------------------------------------------------------------------------
#
# Test ror instruction.
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV64U
RVTEST_CODE_BEGIN

  #-------------------------------------------------------------
  # Arithmetic tests
  #-------------------------------------------------------------

  TEST_RR_OP( 2,  ror, 0x0000000000000001, 0x0000000000000001, 0  );
  TEST_RR_OP( 3,  ror, 0x8000000000000000, 0x0000000000000001, 1  );
  TEST_RR_OP( 4,  ror, 0x0200000000000000, 0x0000000000000001, 7  );
  TEST_RR_OP( 5,  ror, 0x0004000000000000, 0x0000000000000001, 14 );
  TEST_RR_OP( 6,  ror, 0x0000000200000000, 0x0000000000000001, 31 );

  TEST_RR_OP( 7,  ror, 0xffffffffffffffff, 0xffffffffffffffff, 0  );
  TEST_RR_OP( 8,  ror, 0xffffffffffffffff, 0xffffffffffffffff, 1  );
  TEST_RR_OP( 9,  ror, 0xffffffffffffffff, 0xffffffffffffffff, 7  );
  TEST_RR_OP( 10, ror, 0xffffffffffffffff, 0xffffffffffffffff, 14 );
  TEST_RR_OP( 11, ror, 0xffffffffffffffff, 0xffffffffffffffff, 31 );

  TEST_RR_OP( 12, ror, 0x0000000021212121, 0x0000000021212121, 0  );
  TEST_RR_OP( 13, ror, 0x8000000010909090, 0x0000000021212121, 1  );
  TEST_RR_OP( 14, ror, 0x4200000000424242, 0x0000000021212121, 7  );
  TEST_RR_OP( 15, ror, 0x8484000000008484, 0x0000000021212121, 14 );
  TEST_RR_OP( 16, ror, 0x4242424200000000, 0x0000000021212121, 31 );

  # Verify that shifts only use bottom six(rv64) or five(rv32) bits

  TEST_RR_OP( 17, ror, 0x0000000021212121, 0x0000000021212121, 0xffffffffffffffc0 );
  TEST_RR_OP( 18, ror, 0x8000000010909090, 0x0000000021212121, 0xffffffffffffffc1 );
  TEST_RR_OP( 19, ror, 0x4200000000424242, 0x0000000021212121, 0xffffffffffffffc7 );
  TEST_RR_OP( 20, ror, 0x8484000000008484, 0x0000000021212121, 0xffffffffffffffce );

  TEST_RR_OP( 21, ror, 0x0000000042424242, 0x0000000021212121, 0xffffffffffffffff );
  TEST_RR_OP( 50, ror, 0x0000000000000002, 0x0000000000000001, 63 );
  TEST_RR_OP( 51, ror, 0xffffffffffffffff, 0xffffffffffffffff, 39 );
  TEST_RR_OP( 52, ror, 0x0004242424200000, 0x0000000021212121, 43 );

  #-------------------------------------------------------------
  # Source/Destination tests
  #-------------------------------------------------------------

  TEST_RR_SRC1_EQ_DEST( 22, ror, 0x0200000000000000, 0x00000001, 7  );
  TEST_RR_SRC2_EQ_DEST( 23, ror, 0x0004000000000000, 0x00000001, 14 );
  TEST_RR_SRC12_EQ_DEST( 24, ror, 0x6000000000000000, 3 );

  #-------------------------------------------------------------
  # Bypassing tests
  #-------------------------------------------------------------

  TEST_RR_DEST_BYPASS( 25, 0, ror, 0x0200000000000000, 0x0000000000000001, 7  );
  TEST_RR_DEST_BYPASS( 26, 1, ror, 0x0004000000000000, 0x0000000000000001, 14 );
  TEST_RR_DEST_BYPASS( 27, 2, ror, 0x0000000200000000, 0x0000000000000001, 31 );

  TEST_RR_SRC12_BYPASS( 28, 0, 0, ror, 0x0200000000000000, 0x0000000000000001, 7  );
  TEST_RR_SRC12_BYPASS( 29, 0, 1, ror, 0x0004000000000000, 0x0000000000000001, 14 );
  TEST_RR_SRC12_BYPASS( 30, 0, 2, ror, 0x0000000200000000, 0x0000000000000001, 31 );
  TEST_RR_SRC12_BYPASS( 31, 1, 0, ror, 0x0200000000000000, 0x0000000000000001, 7  );
  TEST_RR_SRC12_BYPASS( 32, 1, 1, ror, 0x0004000000000000, 0x0000000000000001, 14 );
  TEST_RR_SRC12_BYPASS( 33, 2, 0, ror, 0x0000000200000000, 0x0000000000000001, 31 );

  TEST_RR_SRC21_BYPASS( 34, 0, 0, ror, 0x0200000000000000, 0x0000000000000001, 7  );
  TEST_RR_SRC21_BYPASS( 35, 0, 1, ror, 0x0004000000000000, 0x0000000000000001, 14 );
  TEST_RR_SRC21_BYPASS( 36, 0, 2, ror, 0x0000000200000000, 0x0000000000000001, 31 );
  TEST_RR_SRC21_BYPASS( 37, 1, 0, ror, 0x0200000000000000, 0x0000000000000001, 7  );
  TEST_RR_SRC21_BYPASS( 38, 1, 1, ror, 0x0004000000000000, 0x0000000000000001, 14 );
  TEST_RR_SRC21_BYPASS( 39, 2, 0, ror, 0x0000000200000000, 0x0000000000000001, 31 );

  TEST_RR_ZEROSRC1( 40, ror, 0, 15 );
  TEST_RR_ZEROSRC2( 41, ror, 32, 32 );
  TEST_RR_ZEROSRC12( 42, ror, 0 );
  TEST_RR_ZERODEST( 43, ror, 1024, 2048 );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END
