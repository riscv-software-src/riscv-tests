# See LICENSE for license details.

#*****************************************************************************
# pack.S
#-----------------------------------------------------------------------------
#
# Test pack instruction (pack low halves).
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV64U
RVTEST_CODE_BEGIN

  #-------------------------------------------------------------
  # Arithmetic tests
  #-------------------------------------------------------------

  # pack rd, rs1, rs2
  # rd = {rs2[XLEN/2-1:0], rs1[XLEN/2-1:0]}

  # Test case 1: Basic packing
  # rs1 = 0x1111111122222222, rs2 = 0x3333333344444444
  # Expected: 0x4444444422222222 (low 32 bits of each)
  TEST_RR_OP( 2, pack, 0x4444444422222222, 0x1111111122222222, 0x3333333344444444 );

  # Test case 2: Zero values
  TEST_RR_OP( 3, pack, 0x0000000000000000, 0x0000000000000000, 0x0000000000000000 );

  # Test case 3: All ones in low halves
  TEST_RR_OP( 4, pack, 0xffffffffffffffff, 0x00000000ffffffff, 0x00000000ffffffff );

  # Test case 4: Mixed pattern
  TEST_RR_OP( 5, pack, 0xdeadbeefcafebabe, 0x12345678cafebabe, 0xabcdef01deadbeef );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END

