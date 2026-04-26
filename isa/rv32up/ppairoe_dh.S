# See LICENSE for license details.

#*****************************************************************************
# ppairoe_dh.S
#-----------------------------------------------------------------------------
#
# Test ppairoe.dh instruction (Packed pair odd-even - double-word halfword, RV32 only).
# Note: rd and rs1 must be even registers (register-pair constraint).
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV32U
RVTEST_CODE_BEGIN

  # ppairoe.dh rd, rs1, rs2
  # Selects odd halfwords from rs1 and even halfwords from rs2 and packs them
  # rd and rs1 must be even registers

  # Test case 2: Distinct halfword pattern
  # rs1 = 0x0003000200010000, rs2 = 0x0007000600050004
  # Odd halfwords rs1: 0001, 0003; Even halfwords rs2: 0004, 0006
  # Result low: 0x00040001, Result high: 0x00060003
  TEST_CASE( 2, x14, 0x00040001, \
    li x10, 0x00010000; \
    li x11, 0x00030002; \
    li x12, 0x00050004; \
    li x13, 0x00070006; \
    ppairoe.dh x14, x10, x12 );
  TEST_CASE( 3, x15, 0x00060003, nop );

  # Test case 4: Zero values
  TEST_CASE( 4, x14, 0x00000000, \
    li x10, 0x00000000; \
    li x11, 0x00000000; \
    li x12, 0x00000000; \
    li x13, 0x00000000; \
    ppairoe.dh x14, x10, x12 );
  TEST_CASE( 5, x15, 0x00000000, nop );

  # Test case 6: All ones
  TEST_CASE( 6, x14, 0xffffffff, \
    li x10, 0xffffffff; \
    li x11, 0xffffffff; \
    li x12, 0xffffffff; \
    li x13, 0xffffffff; \
    ppairoe.dh x14, x10, x12 );
  TEST_CASE( 7, x15, 0xffffffff, nop );

  # Test case 8: Alternating pattern
  # rs1 = 0x0000ffff0000ffff, rs2 = 0xffffaaaaffffaaaa
  # Odd halfwords rs1: ffff, ffff; Even halfwords rs2: aaaa, aaaa
  # Result: 0xaaaaffffaaaaffff
  TEST_CASE( 8, x14, 0xaaaaffff, \
    li x10, 0x0000ffff; \
    li x11, 0x0000ffff; \
    li x12, 0xffffaaaa; \
    li x13, 0xffffaaaa; \
    ppairoe.dh x14, x10, x12 );
  TEST_CASE( 9, x15, 0xaaaaffff, nop );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END

