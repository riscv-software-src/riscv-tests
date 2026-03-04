# See LICENSE for license details.

#*****************************************************************************
# merge.S
#-----------------------------------------------------------------------------
#
# Test merge instruction (bitwise merge, RV64).
# merge rd, rs1, rs2 - merges rs2 and rs1 using prior value of rd as mask
# rd = (rs2 & rd_old) | (rs1 & ~rd_old)
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV64U
RVTEST_CODE_BEGIN

  #-------------------------------------------------------------
  # Arithmetic tests
  #-------------------------------------------------------------

  # Test case 1: rd_old all 1s - all bits from rs2
  # rd = (0xaaaaaaaaaaaaaaaa & 0xffffffffffffffff) | (0x5555555555555555 & 0) = 0xaaaaaaaaaaaaaaaa
  TEST_CASE( 2, x14, 0xaaaaaaaaaaaaaaaa, \
    li x14, 0xffffffffffffffff; \
    li a1, 0x5555555555555555; \
    li a2, 0xaaaaaaaaaaaaaaaa; \
    merge x14, a1, a2 \
  );

  # Test case 2: rd_old all 0s - all bits from rs1
  # rd = (0xdeadbeefcafebabe & 0) | (0x123456789abcdef0 & 0xffffffffffffffff) = 0x123456789abcdef0
  TEST_CASE( 3, x14, 0x123456789abcdef0, \
    li x14, 0x0000000000000000; \
    li a1, 0x123456789abcdef0; \
    li a2, 0xdeadbeefcafebabe; \
    merge x14, a1, a2 \
  );

  # Test case 3: Upper 32 bits from rs2, lower 32 bits from rs1
  # rd_old = 0xffffffff00000000
  # rd = (0xaaaabbbbccccdddd & 0xffffffff00000000) | (0x1111222233334444 & 0x00000000ffffffff)
  #    = 0xaaaabbbb00000000 | 0x0000000033334444 = 0xaaaabbbb33334444
  TEST_CASE( 4, x14, 0xaaaabbbb33334444, \
    li x14, 0xffffffff00000000; \
    li a1, 0x1111222233334444; \
    li a2, 0xaaaabbbbccccdddd; \
    merge x14, a1, a2 \
  );

  # Test case 4: Alternating mask
  # rd_old = 0xaaaaaaaaaaaaaaaa
  # rd = (rs2 & 0xaaaa...) | (rs1 & 0x5555...)
  TEST_CASE( 5, x14, 0xaaaaaaaaaaaaaaaa, \
    li x14, 0xaaaaaaaaaaaaaaaa; \
    li a1, 0x0000000000000000; \
    li a2, 0xffffffffffffffff; \
    merge x14, a1, a2 \
  );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END


