# See LICENSE for license details.

#*****************************************************************************
# slli_uw.S
#-----------------------------------------------------------------------------
#
# Test slli.uw instruction.
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV64U
RVTEST_CODE_BEGIN

  #-------------------------------------------------------------
  # Arithmetic tests
  #-------------------------------------------------------------

  TEST_IMM_OP( 2,  slli.uw, 0x0000000000000001, 0x0000000000000001, 0  );
  TEST_IMM_OP( 3,  slli.uw, 0x0000000000000002, 0x0000000000000001, 1  );
  TEST_IMM_OP( 4,  slli.uw, 0x0000000000000080, 0x0000000000000001, 7  );
  TEST_IMM_OP( 5,  slli.uw, 0x0000000000004000, 0x0000000000000001, 14 );
  TEST_IMM_OP( 6,  slli.uw, 0x0000000080000000, 0x0000000000000001, 31 );

  TEST_IMM_OP( 7,  slli.uw, 0x00000000ffffffff, 0xffffffffffffffff, 0  );
  TEST_IMM_OP( 8,  slli.uw, 0x00000001fffffffe, 0xffffffffffffffff, 1  );
  TEST_IMM_OP( 9,  slli.uw, 0x0000007fffffff80, 0xffffffffffffffff, 7  );
  TEST_IMM_OP( 10, slli.uw, 0x00003fffffffc000, 0xffffffffffffffff, 14 );
  TEST_IMM_OP( 11, slli.uw, 0x7fffffff80000000, 0xffffffffffffffff, 31 );

  TEST_IMM_OP( 12, slli.uw, 0x0000000021212121, 0x0000000021212121, 0  );
  TEST_IMM_OP( 13, slli.uw, 0x0000000042424242, 0x0000000021212121, 1  );
  TEST_IMM_OP( 14, slli.uw, 0x0000001090909080, 0x0000000021212121, 7  );
  TEST_IMM_OP( 15, slli.uw, 0x0000084848484000, 0x0000000021212121, 14 );
  TEST_IMM_OP( 16, slli.uw, 0x1090909080000000, 0x0000000021212121, 31 );

  TEST_IMM_OP( 50, slli.uw, 0x8000000000000000, 0x0000000000000001, 63 );
  TEST_IMM_OP( 51, slli.uw, 0xffffff8000000000, 0xffffffffffffffff, 39 );
  TEST_IMM_OP( 52, slli.uw, 0x0909080000000000, 0x0000000021212121, 43 );

  #-------------------------------------------------------------
  # Source/Destination tests
  #-------------------------------------------------------------

  TEST_IMM_SRC1_EQ_DEST( 17, slli.uw, 0x00000080, 0x00000001, 7 );

  #-------------------------------------------------------------
  # Bypassing tests
  #-------------------------------------------------------------

  TEST_IMM_DEST_BYPASS( 18, 0, slli.uw, 0x0000000000000080, 0x0000000000000001, 7  );
  TEST_IMM_DEST_BYPASS( 19, 1, slli.uw, 0x0000000000004000, 0x0000000000000001, 14 );
  TEST_IMM_DEST_BYPASS( 20, 2, slli.uw, 0x0000000080000000, 0x0000000000000001, 31 );

  TEST_IMM_SRC1_BYPASS( 21, 0, slli.uw, 0x0000000000000080, 0x0000000000000001, 7  );
  TEST_IMM_SRC1_BYPASS( 22, 1, slli.uw, 0x0000000000004000, 0x0000000000000001, 14 );
  TEST_IMM_SRC1_BYPASS( 23, 2, slli.uw, 0x0000000080000000, 0x0000000000000001, 31 );

  TEST_IMM_ZEROSRC1( 24, slli.uw, 0, 31 );
  TEST_IMM_ZERODEST( 25, slli.uw, 33, 20 );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END
