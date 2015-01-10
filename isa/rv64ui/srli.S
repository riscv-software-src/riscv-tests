# See LICENSE for license details.

#*****************************************************************************
# srli.S
#-----------------------------------------------------------------------------
#
# Test srli instruction.
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV64U
RVTEST_CODE_BEGIN

  #-------------------------------------------------------------
  # Arithmetic tests
  #-------------------------------------------------------------

  TEST_IMM_OP( 2,  srli, 0xffffffff80000000, 0xffffffff80000000, 0  );
  TEST_IMM_OP( 3,  srli, 0x7fffffffc0000000, 0xffffffff80000000, 1  );
  TEST_IMM_OP( 4,  srli, 0x01ffffffff000000, 0xffffffff80000000, 7  );
  TEST_IMM_OP( 5,  srli, 0x0003fffffffe0000, 0xffffffff80000000, 14 );
  TEST_IMM_OP( 6,  srli, 0x00000001ffffffff, 0xffffffff80000001, 31 );

  TEST_IMM_OP( 7,  srli, 0xffffffffffffffff, 0xffffffffffffffff, 0  );
  TEST_IMM_OP( 8,  srli, 0x7fffffffffffffff, 0xffffffffffffffff, 1  );
  TEST_IMM_OP( 9,  srli, 0x01ffffffffffffff, 0xffffffffffffffff, 7  );
  TEST_IMM_OP( 10, srli, 0x0003ffffffffffff, 0xffffffffffffffff, 14 );
  TEST_IMM_OP( 11, srli, 0x00000001ffffffff, 0xffffffffffffffff, 31 );

  TEST_IMM_OP( 12, srli, 0x0000000021212121, 0x0000000021212121, 0  );
  TEST_IMM_OP( 13, srli, 0x0000000010909090, 0x0000000021212121, 1  );
  TEST_IMM_OP( 14, srli, 0x0000000000424242, 0x0000000021212121, 7  );
  TEST_IMM_OP( 15, srli, 0x0000000000008484, 0x0000000021212121, 14 );
  TEST_IMM_OP( 16, srli, 0x0000000000000000, 0x0000000021212121, 31 );

  #-------------------------------------------------------------
  # Source/Destination tests
  #-------------------------------------------------------------

  TEST_IMM_SRC1_EQ_DEST( 17, srli, 0x01ffffffff000000, 0xffffffff80000000, 7 );

  #-------------------------------------------------------------
  # Bypassing tests
  #-------------------------------------------------------------

  TEST_IMM_DEST_BYPASS( 18, 0, srli, 0x01ffffffff000000, 0xffffffff80000000, 7  );
  TEST_IMM_DEST_BYPASS( 19, 1, srli, 0x0003fffffffe0000, 0xffffffff80000000, 14 );
  TEST_IMM_DEST_BYPASS( 20, 2, srli, 0x00000001ffffffff, 0xffffffff80000001, 31 );

  TEST_IMM_SRC1_BYPASS( 21, 0, srli, 0x01ffffffff000000, 0xffffffff80000000, 7  );
  TEST_IMM_SRC1_BYPASS( 22, 1, srli, 0x0003fffffffe0000, 0xffffffff80000000, 14 );
  TEST_IMM_SRC1_BYPASS( 23, 2, srli, 0x00000001ffffffff, 0xffffffff80000001, 31 );

  TEST_IMM_ZEROSRC1( 24, srli, 0, 32 );
  TEST_IMM_ZERODEST( 25, srli, 33, 50 );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END
