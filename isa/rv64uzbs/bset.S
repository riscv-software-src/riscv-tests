# See LICENSE for license details.

#*****************************************************************************
# bset.S
#-----------------------------------------------------------------------------
#
# Test bset instruction.
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV64U
RVTEST_CODE_BEGIN

  #-------------------------------------------------------------
  # Arithmetic tests
  #-------------------------------------------------------------

  TEST_RR_OP( 2,  bset, 0xff00ff01, 0xff00ff00, 0  );
  TEST_RR_OP( 3,  bset, 0x00ff00ff, 0x00ff00ff, 1  );
  TEST_RR_OP( 4,  bset, 0xff00ff00, 0xff00ff00, 8  );
  TEST_RR_OP( 5,  bset, 0x0ff04ff0, 0x0ff00ff0, 14 );
  TEST_RR_OP( 6,  bset, 0x0ff00ff0, 0x0ff00ff0, 27 );

  TEST_RR_OP( 7,  bset, 0x0000000000000001, 0x0000000000000001, 0  );
  TEST_RR_OP( 8,  bset, 0x0000000000000003, 0x0000000000000001, 1  );
  TEST_RR_OP( 9,  bset, 0x0000000000000081, 0x0000000000000001, 7  );
  TEST_RR_OP( 10,  bset, 0x0000000000004001, 0x0000000000000001, 14 );
  TEST_RR_OP( 11,  bset, 0x0000000080000001, 0x0000000000000001, 31 );

  TEST_RR_OP( 12, bset, 0x21212121, 0x21212121, 0  );
  TEST_RR_OP( 13, bset, 0x21212123, 0x21212121, 1  );
  TEST_RR_OP( 14, bset, 0x212121a1, 0x21212121, 7  );
  TEST_RR_OP( 15, bset, 0x21212121, 0x21212121, 13 );
  TEST_RR_OP( 16, bset, 0x84848484, 0x84848484, 31 );

  # Verify that shifts only use bottom six(rv64) or five(rv32) bits

  TEST_RR_OP( 17, bset, 0x21212121, 0x21212121, 0xffffffffffffffc0 );
  TEST_RR_OP( 18, bset, 0x21212123, 0x21212121, 0xffffffffffffffc1 );
  TEST_RR_OP( 19, bset, 0x212121a1, 0x21212121, 0xffffffffffffffc7 );
  TEST_RR_OP( 20, bset, 0x8484c484, 0x84848484, 0xffffffffffffffce );

#if __riscv_xlen == 64
  TEST_RR_OP( 21, bset, 0xc484848421212121, 0xc484848421212121, 0xffffffffffffffff );
  TEST_RR_OP( 50, bset, 0x8000000000000001, 0x0000000000000001, 63 );
  TEST_RR_OP( 51, bset, 0xffffffffffffffff, 0xffffffffffffffff, 39 );
  TEST_RR_OP( 52, bset, 0xffffffff00000000, 0xffffffff00000000, 43 );
#endif

  #-------------------------------------------------------------
  # Source/Destination tests
  #-------------------------------------------------------------

  TEST_RR_SRC1_EQ_DEST( 22, bset, 0x00000081, 0x00000001, 7  );
  TEST_RR_SRC2_EQ_DEST( 23, bset, 0x00005551, 0x00005551, 14 );
  TEST_RR_SRC12_EQ_DEST( 24, bset, 11, 3 );

  #-------------------------------------------------------------
  # Bypassing tests
  #-------------------------------------------------------------

  TEST_RR_DEST_BYPASS( 25, 0, bset, 0xff00ff01, 0xff00ff00, 0  );
  TEST_RR_DEST_BYPASS( 26, 1, bset, 0x00ff00ff, 0x00ff00ff, 1  );
  TEST_RR_DEST_BYPASS( 27, 2, bset, 0xff00ff00, 0xff00ff00, 8  );

  TEST_RR_SRC12_BYPASS( 28, 0, 0, bset, 0xff00ff01, 0xff00ff00, 0  );
  TEST_RR_SRC12_BYPASS( 29, 0, 1, bset, 0x00ff00ff, 0x00ff00ff, 1  );
  TEST_RR_SRC12_BYPASS( 30, 0, 2, bset, 0xff00ff00, 0xff00ff00, 8  );
  TEST_RR_SRC12_BYPASS( 31, 1, 0, bset, 0xff00ff01, 0xff00ff00, 0  );
  TEST_RR_SRC12_BYPASS( 32, 1, 1, bset, 0x00ff00ff, 0x00ff00ff, 1  );
  TEST_RR_SRC12_BYPASS( 33, 2, 0, bset, 0xff00ff00, 0xff00ff00, 8  );

  TEST_RR_SRC21_BYPASS( 34, 0, 0, bset, 0xff00ff00, 0xff00ff00, 8  );
  TEST_RR_SRC21_BYPASS( 35, 0, 1, bset, 0x0ff04ff0, 0x0ff00ff0, 14 );
  TEST_RR_SRC21_BYPASS( 36, 0, 2, bset, 0x0ff00ff0, 0x0ff00ff0, 27 );
  TEST_RR_SRC21_BYPASS( 37, 1, 0, bset, 0xff00ff00, 0xff00ff00, 8  );
  TEST_RR_SRC21_BYPASS( 38, 1, 1, bset, 0x0ff04ff0, 0x0ff00ff0, 14 );
  TEST_RR_SRC21_BYPASS( 39, 2, 0, bset, 0x0ff00ff0, 0x0ff00ff0, 27 );

  TEST_RR_ZEROSRC1( 40, bset, 0x00008000, 15 );
  TEST_RR_ZEROSRC2( 41, bset, 33, 32 );
  TEST_RR_ZEROSRC12( 42, bset, 1 );
  TEST_RR_ZERODEST( 43, bset, 1024, 2048 );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END
