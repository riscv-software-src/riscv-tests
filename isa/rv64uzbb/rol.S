# See LICENSE for license details.

#*****************************************************************************
# rol.S
#-----------------------------------------------------------------------------
#
# Test rol instruction.
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV64U
RVTEST_CODE_BEGIN

  #-------------------------------------------------------------
  # Arithmetic tests
  #-------------------------------------------------------------

  TEST_RR_OP( 2,  rol, 0x0000000000000001, 0x0000000000000001, 0  );
  TEST_RR_OP( 3,  rol, 0x0000000000000002, 0x0000000000000001, 1  );
  TEST_RR_OP( 4,  rol, 0x0000000000000080, 0x0000000000000001, 7  );
  TEST_RR_OP( 5,  rol, 0x0000000000004000, 0x0000000000000001, 14 );
  TEST_RR_OP( 6,  rol, 0x0000000080000000, 0x0000000000000001, 31 );

  TEST_RR_OP( 7,  rol, 0xffffffffffffffff, 0xffffffffffffffff, 0  );
  TEST_RR_OP( 8,  rol, 0xffffffffffffffff, 0xffffffffffffffff, 1  );
  TEST_RR_OP( 9,  rol, 0xffffffffffffffff, 0xffffffffffffffff, 7  );
  TEST_RR_OP( 10, rol, 0xffffffffffffffff, 0xffffffffffffffff, 14 );
  TEST_RR_OP( 11, rol, 0xffffffffffffffff, 0xffffffffffffffff, 31 );

  TEST_RR_OP( 12, rol, 0x0000000021212121, 0x0000000021212121, 0  );
  TEST_RR_OP( 13, rol, 0x0000000042424242, 0x0000000021212121, 1  );
  TEST_RR_OP( 14, rol, 0x0000001090909080, 0x0000000021212121, 7  );
  TEST_RR_OP( 15, rol, 0x0000084848484000, 0x0000000021212121, 14 );
  TEST_RR_OP( 16, rol, 0x1090909080000000, 0x0000000021212121, 31 );

  # Verify that rotates only use bottom six(rv64) or five(rv32) bits

  TEST_RR_OP( 17, rol, 0x0000000021212121, 0x0000000021212121, 0xffffffffffffffc0 );
  TEST_RR_OP( 18, rol, 0x0000000042424242, 0x0000000021212121, 0xffffffffffffffc1 );
  TEST_RR_OP( 19, rol, 0x0000001090909080, 0x0000000021212121, 0xffffffffffffffc7 );
  TEST_RR_OP( 20, rol, 0x0000084848484000, 0x0000000021212121, 0xffffffffffffffce );

#if __riscv_xlen == 64
  TEST_RR_OP( 21, rol, 0x8000000010909090, 0x0000000021212121, 0xffffffffffffffff );
  TEST_RR_OP( 50, rol, 0x8000000000000000, 0x0000000000000001, 63 );
  TEST_RR_OP( 51, rol, 0xffffffffffffffff, 0xffffffffffffffff, 39 );
  TEST_RR_OP( 52, rol, 0x0909080000000109, 0x0000000021212121, 43 );
#endif

  #-------------------------------------------------------------
  # Source/Destination tests
  #-------------------------------------------------------------

  TEST_RR_SRC1_EQ_DEST( 22, rol, 0x00000080, 0x00000001, 7  );
  TEST_RR_SRC2_EQ_DEST( 23, rol, 0x00004000, 0x00000001, 14 );
  TEST_RR_SRC12_EQ_DEST( 24, rol, 24, 3 );

  #-------------------------------------------------------------
  # Bypassing tests
  #-------------------------------------------------------------

  TEST_RR_DEST_BYPASS( 25, 0, rol, 0x0000000000000080, 0x0000000000000001, 7  );
  TEST_RR_DEST_BYPASS( 26, 1, rol, 0x0000000000004000, 0x0000000000000001, 14 );
  TEST_RR_DEST_BYPASS( 27, 2, rol, 0x0000000080000000, 0x0000000000000001, 31 );

  TEST_RR_SRC12_BYPASS( 28, 0, 0, rol, 0x0000000000000080, 0x0000000000000001, 7  );
  TEST_RR_SRC12_BYPASS( 29, 0, 1, rol, 0x0000000000004000, 0x0000000000000001, 14 );
  TEST_RR_SRC12_BYPASS( 30, 0, 2, rol, 0x0000000080000000, 0x0000000000000001, 31 );
  TEST_RR_SRC12_BYPASS( 31, 1, 0, rol, 0x0000000000000080, 0x0000000000000001, 7  );
  TEST_RR_SRC12_BYPASS( 32, 1, 1, rol, 0x0000000000004000, 0x0000000000000001, 14 );
  TEST_RR_SRC12_BYPASS( 33, 2, 0, rol, 0x0000000080000000, 0x0000000000000001, 31 );

  TEST_RR_SRC21_BYPASS( 34, 0, 0, rol, 0x0000000000000080, 0x0000000000000001, 7  );
  TEST_RR_SRC21_BYPASS( 35, 0, 1, rol, 0x0000000000004000, 0x0000000000000001, 14 );
  TEST_RR_SRC21_BYPASS( 36, 0, 2, rol, 0x0000000080000000, 0x0000000000000001, 31 );
  TEST_RR_SRC21_BYPASS( 37, 1, 0, rol, 0x0000000000000080, 0x0000000000000001, 7  );
  TEST_RR_SRC21_BYPASS( 38, 1, 1, rol, 0x0000000000004000, 0x0000000000000001, 14 );
  TEST_RR_SRC21_BYPASS( 39, 2, 0, rol, 0x0000000080000000, 0x0000000000000001, 31 );

  TEST_RR_ZEROSRC1( 40, rol, 0, 15 );
  TEST_RR_ZEROSRC2( 41, rol, 32, 32 );
  TEST_RR_ZEROSRC12( 42, rol, 0 );
  TEST_RR_ZERODEST( 43, rol, 1024, 2048 );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END
