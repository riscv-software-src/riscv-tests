# See LICENSE for license details.

#*****************************************************************************
# zip8p.S
#-----------------------------------------------------------------------------
#
# Test zip8p instruction (zip 8-bit elements from two sources).
# Interleaves 8-bit elements: rd[i] = (i % 2) ? rs2[i/2] : rs1[i/2]
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV64U
RVTEST_CODE_BEGIN

  # zip8p rd, rs1, rs2
  # Interleaves bytes: rd = {rs2[3], rs1[3], rs2[2], rs1[2], rs2[1], rs1[1], rs2[0], rs1[0]}

  # Test case 1: Simple interleave
  # rs1 = 0x0807060504030201, rs2 = 0x1817161514131211
  # rd = {0x18, 0x08, 0x17, 0x07, 0x16, 0x06, 0x15, 0x05, 0x14, 0x04, 0x13, 0x03, 0x12, 0x02, 0x11, 0x01}
  #    = 0x1808170716061505_1404130312021101 (only low 64 bits in rd)
  TEST_CASE( 2, x14, 0x1808170716061505, \
    li x10, 0x0807060504030201; \
    li x12, 0x1817161514131211; \
    zip8p x14, x10, x12 );

  # Test case 2: All zeros from rs1
  TEST_CASE( 3, x14, 0x1100130015001700, \
    li x10, 0x0000000000000000; \
    li x12, 0x1113151700000000; \
    zip8p x14, x10, x12 );

  # Test case 3: Identity pattern
  TEST_CASE( 4, x14, 0xFFAAFFAAFFAAFFAA, \
    li x10, 0xAAAAAAAAAAAAAAAA; \
    li x12, 0xFFFFFFFFFFFFFFFF; \
    zip8p x14, x10, x12 );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN
  TEST_DATA
RVTEST_DATA_END

