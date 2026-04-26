# See LICENSE for license details.

#*****************************************************************************
# mvm.S
#-----------------------------------------------------------------------------
#
# Test mvm instruction (merge under mask, RV32 only).
# mvm rd, rs1, rs2 - merges rs1 and the prior value of rd under control of mask rs2
# rd = (rs1 & rs2) | (rd_old & ~rs2)
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV32U
RVTEST_CODE_BEGIN

  #-------------------------------------------------------------
  # Arithmetic tests
  #-------------------------------------------------------------

  # Test case 1: Mask all 1s - all bits from rs1
  # rd = (0xaaaaaaaa & 0xffffffff) | (0x55555555 & 0x00000000) = 0xaaaaaaaa
  TEST_CASE( 2, x14, 0xaaaaaaaa, \
    li x14, 0x55555555; \
    li a1, 0xaaaaaaaa; \
    li a2, 0xffffffff; \
    mvm x14, a1, a2 \
  );

  # Test case 2: Mask with bit 0 clear - bit 0 from rd_old, rest from rs1
  # rd = (0xaaaaaaaa & 0xfffffffe) | (0x55555555 & 0x00000001) = 0xaaaaaaab
  TEST_CASE( 3, x14, 0xaaaaaaab, \
    li x14, 0x55555555; \
    li a1, 0xaaaaaaaa; \
    li a2, 0xfffffffe; \
    mvm x14, a1, a2 \
  );

  # Test case 3: Mask all 0s - all bits from rd_old
  # rd = (0xdeadbeef & 0x00000000) | (0x12345678 & 0xffffffff) = 0x12345678
  TEST_CASE( 4, x14, 0x12345678, \
    li x14, 0x12345678; \
    li a1, 0xdeadbeef; \
    li a2, 0x00000000; \
    mvm x14, a1, a2 \
  );

  # Test case 4: Mask with bit 31 clear - bit 31 from rd_old, rest from rs1
  # rd = (0x11111111 & 0x7fffffff) | (0xcafebabe & 0x80000000) = 0x91111111
  TEST_CASE( 5, x14, 0x91111111, \
    li x14, 0xcafebabe; \
    li a1, 0x11111111; \
    li a2, 0x7fffffff; \
    mvm x14, a1, a2 \
  );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END

