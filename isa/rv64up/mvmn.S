# See LICENSE for license details.

#*****************************************************************************
# mvmn.S
#-----------------------------------------------------------------------------
#
# Test mvmn instruction (merge under not mask, RV64).
# mvmn rd, rs1, rs2 - merges rs1 and the prior value of rd under control of inverted mask rs2
# rd = (rd_old & rs2) | (rs1 & ~rs2)
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV64U
RVTEST_CODE_BEGIN

  #-------------------------------------------------------------
  # Arithmetic tests
  #-------------------------------------------------------------

  # Test case 1: Mask all 1s - all bits from rd_old (opposite of mvm)
  # rd = (0x5555555555555555 & 0xffffffffffffffff) | (0xaaaaaaaaaaaaaaaa & 0) = 0x5555555555555555
  TEST_CASE( 2, x14, 0x5555555555555555, \
    li x14, 0x5555555555555555; \
    li a1, 0xaaaaaaaaaaaaaaaa; \
    li a2, 0xffffffffffffffff; \
    mvmn x14, a1, a2 \
  );

  # Test case 2: Mask all 0s - all bits from rs1 (opposite of mvm)
  # rd = (0x123456789abcdef0 & 0) | (0xdeadbeefcafebabe & 0xffffffffffffffff) = 0xdeadbeefcafebabe
  TEST_CASE( 3, x14, 0xdeadbeefcafebabe, \
    li x14, 0x123456789abcdef0; \
    li a1, 0xdeadbeefcafebabe; \
    li a2, 0x0000000000000000; \
    mvmn x14, a1, a2 \
  );

  # Test case 3: Upper 32 bits from rd_old, lower 32 bits from rs1
  # mask = 0xffffffff00000000
  # rd = (0x1111222233334444 & 0xffffffff00000000) | (0xaaaabbbbccccdddd & 0x00000000ffffffff)
  #    = 0x1111222200000000 | 0x00000000ccccdddd = 0x11112222ccccdddd
  TEST_CASE( 4, x14, 0x11112222ccccdddd, \
    li x14, 0x1111222233334444; \
    li a1, 0xaaaabbbbccccdddd; \
    li a2, 0xffffffff00000000; \
    mvmn x14, a1, a2 \
  );

  # Test case 4: Alternating mask
  # rd_old & rs2 = 0xffff... & 0xaaaa... = 0xaaaa...
  # rs1 & ~rs2   = 0x5555... & 0x5555... = 0x5555...
  # Result = 0xaaaa... | 0x5555... = 0xffff...
  TEST_CASE( 5, x14, 0xffffffffffffffff, \
    li x14, 0xffffffffffffffff; \
    li a1, 0x5555555555555555; \
    li a2, 0xaaaaaaaaaaaaaaaa; \
    mvmn x14, a1, a2 \
  );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END


