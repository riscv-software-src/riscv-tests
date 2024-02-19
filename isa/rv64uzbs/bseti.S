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

  TEST_IMM_OP( 2,  bset, 0xff00ff01, 0xff00ff00, 0  );
  TEST_IMM_OP( 3,  bset, 0x00ff00ff, 0x00ff00ff, 1  );
  TEST_IMM_OP( 4,  bset, 0xff00ff00, 0xff00ff00, 8  );
  TEST_IMM_OP( 5,  bset, 0x0ff04ff0, 0x0ff00ff0, 14 );
  TEST_IMM_OP( 6,  bset, 0x0ff00ff0, 0x0ff00ff0, 27 );

  TEST_IMM_OP( 7,  bset, 0x0000000000000001, 0x0000000000000001, 0  );
  TEST_IMM_OP( 8,  bset, 0x0000000000000003, 0x0000000000000001, 1  );
  TEST_IMM_OP( 9,  bset, 0x0000000000000081, 0x0000000000000001, 7  );
  TEST_IMM_OP( 10,  bset, 0x0000000000004001, 0x0000000000000001, 14 );
  TEST_IMM_OP( 11,  bset, 0x0000000080000001, 0x0000000000000001, 31 );

  TEST_IMM_OP( 12, bset, 0x21212121, 0x21212121, 0  );
  TEST_IMM_OP( 13, bset, 0x21212123, 0x21212121, 1  );
  TEST_IMM_OP( 14, bset, 0x212121a1, 0x21212121, 7  );
  TEST_IMM_OP( 15, bset, 0x21212121, 0x21212121, 13 );
  TEST_IMM_OP( 16, bset, 0x84848484, 0x84848484, 31 );

#if __riscv_xlen == 64
  TEST_IMM_OP( 50, bset, 0x8000000000000001, 0x0000000000000001, 63 );
  TEST_IMM_OP( 51, bset, 0xffffffffffffffff, 0xffffffffffffffff, 39 );
  TEST_IMM_OP( 52, bset, 0xffffffff00000000, 0xffffffff00000000, 43 );
#endif

  #-------------------------------------------------------------
  # Source/Destination tests
  #-------------------------------------------------------------

  TEST_IMM_SRC1_EQ_DEST( 17, bset, 0x00000081, 0x00000001, 7  );

  #-------------------------------------------------------------
  # Bypassing tests
  #-------------------------------------------------------------

  TEST_IMM_DEST_BYPASS( 18, 0, bset, 0xff00ff01, 0xff00ff00, 0  );
  TEST_IMM_DEST_BYPASS( 19, 1, bset, 0x00ff00ff, 0x00ff00ff, 1  );
  TEST_IMM_DEST_BYPASS( 20, 2, bset, 0xff00ff00, 0xff00ff00, 8  );

  TEST_IMM_SRC1_BYPASS( 21, 0, bset, 0xff00ff00, 0xff00ff00, 8  );
  TEST_IMM_SRC1_BYPASS( 22, 1, bset, 0x0ff04ff0, 0x0ff00ff0, 14 );
  TEST_IMM_SRC1_BYPASS( 23, 2, bset, 0x0ff00ff0, 0x0ff00ff0, 27 );

  TEST_IMM_ZEROSRC1( 24, bset, 0x00008000, 15 );
  TEST_IMM_ZERODEST( 25, bset, 1024, 10 );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END
