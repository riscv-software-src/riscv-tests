# See LICENSE for license details.

#*****************************************************************************
# merge.S
#-----------------------------------------------------------------------------
#
# Test merge instruction (merge based on mask, RV32 only).
# merge rd, rs1, rs2 - merges rs2 and rs1 using rd_old as mask
# rd = (rs2 & rd_old) | (rs1 & ~rd_old)
#   Where rd_old bit is 1: take from rs2
#   Where rd_old bit is 0: take from rs1
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV32U
RVTEST_CODE_BEGIN

  #-------------------------------------------------------------
  # Arithmetic tests
  #-------------------------------------------------------------

  # Test case 1: rd_old all 0s - all bits from rs1
  # rd = (0x55555555 & 0x00000000) | (0xaaaaaaaa & 0xffffffff) = 0xaaaaaaaa
  TEST_CASE( 2, x14, 0xaaaaaaaa, \
    li x14, 0x00000000; \
    li a1, 0xaaaaaaaa; \
    li a2, 0x55555555; \
    merge x14, a1, a2 \
  );

  # Test case 2: rd_old all 1s - all bits from rs2
  # rd = (0x55555555 & 0xffffffff) | (0xaaaaaaaa & 0x00000000) = 0x55555555
  TEST_CASE( 3, x14, 0x55555555, \
    li x14, 0xffffffff; \
    li a1, 0xaaaaaaaa; \
    li a2, 0x55555555; \
    merge x14, a1, a2 \
  );

  # Test case 3: rd_old alternating (0x55555555)
  # rd = (0xffffffff & 0x55555555) | (0x00000000 & 0xaaaaaaaa) = 0x55555555
  TEST_CASE( 4, x14, 0x55555555, \
    li x14, 0x55555555; \
    li a1, 0x00000000; \
    li a2, 0xffffffff; \
    merge x14, a1, a2 \
  );

  # Test case 4: rd_old high half (0xffff0000) - high from rs2, low from rs1
  # rd = (0xdeadbeef & 0xffff0000) | (0x12345678 & 0x0000ffff) = 0xdead5678
  TEST_CASE( 5, x14, 0xdead5678, \
    li x14, 0xffff0000; \
    li a1, 0x12345678; \
    li a2, 0xdeadbeef; \
    merge x14, a1, a2 \
  );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END

