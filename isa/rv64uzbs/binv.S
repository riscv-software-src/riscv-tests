# See LICENSE for license details.

#*****************************************************************************
# binv.S
#-----------------------------------------------------------------------------
#
# Test binv instruction.
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV64U
RVTEST_CODE_BEGIN

  #-------------------------------------------------------------
  # Arithmetic tests
  #-------------------------------------------------------------

  TEST_RR_OP( 2,  binv, 0x0000000000000000, 0x0000000000000001, 0  );
  TEST_RR_OP( 3,  binv, 0x0000000000000003, 0x0000000000000001, 1  );
  TEST_RR_OP( 4,  binv, 0x0000000000000081, 0x0000000000000001, 7  );
  TEST_RR_OP( 5,  binv, 0x0000000000004001, 0x0000000000000001, 14 );
  TEST_RR_OP( 6,  binv, 0x0000000080000001, 0x0000000000000001, 31 );

  TEST_RR_OP( 7,  binv, 0xfffffffffffffffe, 0xffffffffffffffff, 0  );
  TEST_RR_OP( 8,  binv, 0xfffffffffffffffd, 0xffffffffffffffff, 1  );
  TEST_RR_OP( 9,  binv, 0xffffffffffffff7f, 0xffffffffffffffff, 7  );
  TEST_RR_OP( 10, binv, 0xffffffffffffbfff, 0xffffffffffffffff, 14 );
  TEST_RR_OP( 11, binv, 0xffffffff7fffffff, 0xffffffffffffffff, 31 );

  TEST_RR_OP( 12, binv, 0x0000000021212120, 0x0000000021212121, 0  );
  TEST_RR_OP( 13, binv, 0x0000000021212123, 0x0000000021212121, 1  );
  TEST_RR_OP( 14, binv, 0x00000000212121a1, 0x0000000021212121, 7  );
  TEST_RR_OP( 15, binv, 0x0000000021216121, 0x0000000021212121, 14 );
  TEST_RR_OP( 16, binv, 0x00000000a1212121, 0x0000000021212121, 31 );

  # Verify that shifts only use bottom six(rv64) or five(rv32) bits

  TEST_RR_OP( 17, binv, 0x0000000021212120, 0x0000000021212121, 0xffffffffffffffc0 );
  TEST_RR_OP( 18, binv, 0x0000000021212123, 0x0000000021212121, 0xffffffffffffffc1 );
  TEST_RR_OP( 19, binv, 0x00000000212121a1, 0x0000000021212121, 0xffffffffffffffc7 );
  TEST_RR_OP( 20, binv, 0x0000000021216121, 0x0000000021212121, 0xffffffffffffffce );

#if __riscv_xlen == 64
  TEST_RR_OP( 21, binv, 0x8000000021212121, 0x0000000021212121, 0xffffffffffffffff );
  TEST_RR_OP( 50, binv, 0x8000000000000001, 0x0000000000000001, 63 );
  TEST_RR_OP( 51, binv, 0xffffff7fffffffff, 0xffffffffffffffff, 39 );
  TEST_RR_OP( 52, binv, 0x0000080021212121, 0x0000000021212121, 43 );
#endif

  #-------------------------------------------------------------
  # Source/Destination tests
  #-------------------------------------------------------------

  TEST_RR_SRC1_EQ_DEST( 22, binv, 0x00000081, 0x00000001, 7  );
  TEST_RR_SRC2_EQ_DEST( 23, binv, 0x00004001, 0x00000001, 14 );
  TEST_RR_SRC12_EQ_DEST( 24, binv, 11, 3 );

  #-------------------------------------------------------------
  # Bypassing tests
  #-------------------------------------------------------------

  TEST_RR_DEST_BYPASS( 25, 0, binv, 0x0000000000000081, 0x0000000000000001, 7  );
  TEST_RR_DEST_BYPASS( 26, 1, binv, 0x0000000000004001, 0x0000000000000001, 14 );
  TEST_RR_DEST_BYPASS( 27, 2, binv, 0x0000000080000001, 0x0000000000000001, 31 );

  TEST_RR_SRC12_BYPASS( 28, 0, 0, binv, 0x0000000000000081, 0x0000000000000001, 7  );
  TEST_RR_SRC12_BYPASS( 29, 0, 1, binv, 0x0000000000004001, 0x0000000000000001, 14 );
  TEST_RR_SRC12_BYPASS( 30, 0, 2, binv, 0x0000000080000001, 0x0000000000000001, 31 );
  TEST_RR_SRC12_BYPASS( 31, 1, 0, binv, 0x0000000000000081, 0x0000000000000001, 7  );
  TEST_RR_SRC12_BYPASS( 32, 1, 1, binv, 0x0000000000004001, 0x0000000000000001, 14 );
  TEST_RR_SRC12_BYPASS( 33, 2, 0, binv, 0x0000000080000001, 0x0000000000000001, 31 );

  TEST_RR_SRC21_BYPASS( 34, 0, 0, binv, 0x0000000000000081, 0x0000000000000001, 7  );
  TEST_RR_SRC21_BYPASS( 35, 0, 1, binv, 0x0000000000004001, 0x0000000000000001, 14 );
  TEST_RR_SRC21_BYPASS( 36, 0, 2, binv, 0x0000000080000001, 0x0000000000000001, 31 );
  TEST_RR_SRC21_BYPASS( 37, 1, 0, binv, 0x0000000000000081, 0x0000000000000001, 7  );
  TEST_RR_SRC21_BYPASS( 38, 1, 1, binv, 0x0000000000004001, 0x0000000000000001, 14 );
  TEST_RR_SRC21_BYPASS( 39, 2, 0, binv, 0x0000000080000001, 0x0000000000000001, 31 );

  TEST_RR_ZEROSRC1( 40, binv, 0x00008000, 15 );
  TEST_RR_ZEROSRC2( 41, binv, 33, 32 );
  TEST_RR_ZEROSRC12( 42, binv, 1 );
  TEST_RR_ZERODEST( 43, binv, 1024, 2048 );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END
