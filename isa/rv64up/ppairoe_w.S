# See LICENSE for license details.

#*****************************************************************************
# ppairoe_w.S
#-----------------------------------------------------------------------------
#
# Test ppairoe.w instruction (packed pair odd-even word, RV64 only).
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV64U
RVTEST_CODE_BEGIN

  # ppairoe.w (per P-ext spec):
  #   rd = s2[31:0] @ s1[63:32]   (rs2.even in upper, rs1.odd in lower)

  # Test case 1: Distinct word pattern
  # rs1.odd = 0x00000002, rs2.even = 0x00000003 -> rd = 0x00000003_00000002
  TEST_RR_OP( 2, ppairoe.w, 0x0000000300000002, 0x0000000200000001, 0x0000000400000003 );

  # Test case 2: Zero values
  TEST_RR_OP( 3, ppairoe.w, 0x0000000000000000, 0x0000000000000000, 0x0000000000000000 );

  # Test case 3: All ones
  TEST_RR_OP( 4, ppairoe.w, 0xffffffffffffffff, 0xffffffffffffffff, 0xffffffffffffffff );

  # Test case 4: Mixed pattern
  # rs1.odd = 0xaaaaaaaa, rs2.even = 0x12345678 -> rd = 0x12345678_aaaaaaaa
  TEST_RR_OP( 5, ppairoe.w, 0x12345678aaaaaaaa, 0xaaaaaaaa11111111, 0xdeadbeef12345678 );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN
  TEST_DATA
RVTEST_DATA_END
