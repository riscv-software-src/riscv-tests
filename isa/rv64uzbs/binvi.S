# See LICENSE for license details.

#*****************************************************************************
# binvi.S
#-----------------------------------------------------------------------------
#
# Test binvi instruction.
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV64U
RVTEST_CODE_BEGIN

  #-------------------------------------------------------------
  # Arithmetic tests
  #-------------------------------------------------------------

  TEST_IMM_OP( 2,  binvi, 0x0000000000000000, 0x0000000000000001, 0  );
  TEST_IMM_OP( 3,  binvi, 0x0000000000000003, 0x0000000000000001, 1  );
  TEST_IMM_OP( 4,  binvi, 0x0000000000000081, 0x0000000000000001, 7  );
  TEST_IMM_OP( 5,  binvi, 0x0000000000004001, 0x0000000000000001, 14 );
  TEST_IMM_OP( 6,  binvi, 0x0000000080000001, 0x0000000000000001, 31 );

  TEST_IMM_OP( 7,  binvi, 0xfffffffffffffffe, 0xffffffffffffffff, 0  );
  TEST_IMM_OP( 8,  binvi, 0xfffffffffffffffd, 0xffffffffffffffff, 1  );
  TEST_IMM_OP( 9,  binvi, 0xffffffffffffff7f, 0xffffffffffffffff, 7  );
  TEST_IMM_OP( 10, binvi, 0xffffffffffffbfff, 0xffffffffffffffff, 14 );
  TEST_IMM_OP( 11, binvi, 0xffffffff7fffffff, 0xffffffffffffffff, 31 );

  TEST_IMM_OP( 12, binvi, 0x0000000021212120, 0x0000000021212121, 0  );
  TEST_IMM_OP( 13, binvi, 0x0000000021212123, 0x0000000021212121, 1  );
  TEST_IMM_OP( 14, binvi, 0x00000000212121a1, 0x0000000021212121, 7  );
  TEST_IMM_OP( 15, binvi, 0x0000000021216121, 0x0000000021212121, 14 );
  TEST_IMM_OP( 16, binvi, 0x00000000a1212121, 0x0000000021212121, 31 );

#if __riscv_xlen == 64
  TEST_IMM_OP( 50, binvi, 0x8000000000000001, 0x0000000000000001, 63 );
  TEST_IMM_OP( 51, binvi, 0xffffff7fffffffff, 0xffffffffffffffff, 39 );
  TEST_IMM_OP( 52, binvi, 0x0000080021212121, 0x0000000021212121, 43 );
#endif

  #-------------------------------------------------------------
  # Source/Destination tests
  #-------------------------------------------------------------

  TEST_IMM_SRC1_EQ_DEST( 17, binvi, 0x00000081, 0x00000001, 7  );

  #-------------------------------------------------------------
  # Bypassing tests
  #-------------------------------------------------------------

  TEST_IMM_DEST_BYPASS( 18, 0, binvi, 0x0000000000000081, 0x0000000000000001, 7  );
  TEST_IMM_DEST_BYPASS( 19, 1, binvi, 0x0000000000004001, 0x0000000000000001, 14 );
  TEST_IMM_DEST_BYPASS( 20, 2, binvi, 0x0000000080000001, 0x0000000000000001, 31 );

  TEST_IMM_SRC1_BYPASS( 21, 0, binvi, 0x0000000000000081, 0x0000000000000001, 7  );
  TEST_IMM_SRC1_BYPASS( 22, 1, binvi, 0x0000000000004001, 0x0000000000000001, 14 );
  TEST_IMM_SRC1_BYPASS( 23, 2, binvi, 0x0000000080000001, 0x0000000000000001, 31 );


  TEST_IMM_ZEROSRC1( 24, binvi, 0x00008000, 15 );
  TEST_IMM_ZERODEST( 25, binvi, 1024, 10 );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END
