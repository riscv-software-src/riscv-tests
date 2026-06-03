# See LICENSE for license details.

#*****************************************************************************
# mvm.S
#-----------------------------------------------------------------------------
#
# Test mvm instruction (merge under mask, RV64).
# mvm rd, rs1, rs2 - merges rs1 and the prior value of rd under control of mask rs2
# rd = (rs1 & rs2) | (rd_old & ~rs2)
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV64U
RVTEST_CODE_BEGIN

  #-------------------------------------------------------------
  # Arithmetic tests
  #-------------------------------------------------------------

  # Test case 1: Mask all 1s - all bits from rs1
  # rd = (0xaaaaaaaaaaaaaaaa & 0xffffffffffffffff) | (0x5555555555555555 & 0) = 0xaaaaaaaaaaaaaaaa
  TEST_CASE( 2, x14, 0xaaaaaaaaaaaaaaaa, \
    li x14, 0x5555555555555555; \
    li a1, 0xaaaaaaaaaaaaaaaa; \
    li a2, 0xffffffffffffffff; \
    mvm x14, a1, a2 \
  );

  # Test case 2: Mask all 0s - all bits from rd_old
  # rd = (0xdeadbeefcafebabe & 0) | (0x123456789abcdef0 & 0xffffffffffffffff) = 0x123456789abcdef0
  TEST_CASE( 3, x14, 0x123456789abcdef0, \
    li x14, 0x123456789abcdef0; \
    li a1, 0xdeadbeefcafebabe; \
    li a2, 0x0000000000000000; \
    mvm x14, a1, a2 \
  );

  # Test case 3: Upper 32 bits from rs1, lower 32 bits from rd_old
  # mask = 0xffffffff00000000
  # rd = (0xaaaabbbbccccdddd & 0xffffffff00000000) | (0x1111222233334444 & 0x00000000ffffffff)
  #    = 0xaaaabbbb00000000 | 0x0000000033334444 = 0xaaaabbbb33334444
  TEST_CASE( 4, x14, 0xaaaabbbb33334444, \
    li x14, 0x1111222233334444; \
    li a1, 0xaaaabbbbccccdddd; \
    li a2, 0xffffffff00000000; \
    mvm x14, a1, a2 \
  );

  # Test case 4: Alternating mask
  # mask = 0xaaaaaaaaaaaaaaaa (bits 63,61,59,... from rs1; bits 62,60,58,... from rd_old)
  TEST_CASE( 5, x14, 0xaaaaaaaaaaaaaaaa, \
    li x14, 0x0000000000000000; \
    li a1, 0xaaaaaaaaaaaaaaaa; \
    li a2, 0xaaaaaaaaaaaaaaaa; \
    mvm x14, a1, a2 \
  );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END


