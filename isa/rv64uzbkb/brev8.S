# See LICENSE for license details.

#*****************************************************************************
# brev8.S
#-----------------------------------------------------------------------------
#
# Test brev8 instruction.
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV64U
RVTEST_CODE_BEGIN

  #-------------------------------------------------------------
  # Arithmetic tests
  #-------------------------------------------------------------

  TEST_R_OP( 2, brev8, 0x80C4A2E6, 0x01234567 );
  TEST_R_OP( 3, brev8, 0x00000000, 0x00000000 );
  TEST_R_OP( 4, brev8, 0xFFFFFFFF, 0xFFFFFFFF );
  TEST_R_OP( 5, brev8, 0x55555555, 0xAAAAAAAA );
  TEST_R_OP( 6, brev8, 0xAAAAAAAA, 0x55555555 );

#if __riscv_xlen == 64
  TEST_R_OP( 7, brev8, 0x80C4A2E680C4A2E6, 0x0123456701234567 );
  TEST_R_OP( 8, brev8, 0x0F0F0F0F0F0F0F0F, 0xF0F0F0F0F0F0F0F0 );
  TEST_R_OP( 9, brev8, 0xF0F0F0F0F0F0F0F0, 0x0F0F0F0F0F0F0F0F );
  TEST_R_OP( 10, brev8, 0x0000000000000000, 0x0000000000000000 );
  TEST_R_OP( 11, brev8, 0xFFFFFFFFFFFFFFFF, 0xFFFFFFFFFFFFFFFF );
#endif

  #-------------------------------------------------------------
  # Source/Destination tests
  #-------------------------------------------------------------

  TEST_R_SRC1_EQ_DEST( 12, brev8, 0x80C4A2E6, 0x01234567 );
  TEST_R_SRC1_EQ_DEST( 13, brev8, 0x55555555, 0xAAAAAAAA );

  #-------------------------------------------------------------
  # Bypassing tests
  #-------------------------------------------------------------

  TEST_R_DEST_BYPASS( 14, 0, brev8, 0x80C4A2E6, 0x01234567 );
  TEST_R_DEST_BYPASS( 15, 1, brev8, 0x55555555, 0xAAAAAAAA );
  TEST_R_DEST_BYPASS( 16, 2, brev8, 0xAAAAAAAA, 0x55555555 );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN
  TEST_DATA
RVTEST_DATA_END
