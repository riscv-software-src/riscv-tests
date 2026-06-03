# See LICENSE for license details.

#*****************************************************************************
# ppairo_w.S
#-----------------------------------------------------------------------------
#
# Test ppairo.w instruction (packed pair odd word, RV64 only).
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV64U
RVTEST_CODE_BEGIN

  # ppairo.w (per P-ext spec):
  #   rd = s2[63:32] @ s1[63:32]   (rs2.odd in upper, rs1.odd in lower)

  # Test case 1: Distinct word pattern
  # rs1 = 0x0000000200000001, rs2 = 0x0000000400000003
  # Upper = rs2.odd = 0x00000004; Lower = rs1.odd = 0x00000002
  TEST_RR_OP( 2, ppairo.w, 0x0000000400000002, 0x0000000200000001, 0x0000000400000003 );

  # Test case 2: Zero values
  TEST_RR_OP( 3, ppairo.w, 0x0000000000000000, 0x0000000000000000, 0x0000000000000000 );

  # Test case 3: All ones
  TEST_RR_OP( 4, ppairo.w, 0xffffffffffffffff, 0xffffffffffffffff, 0xffffffffffffffff );

  # Test case 4: Mixed pattern
  # rs1.odd = 0xaaaaaaaa, rs2.odd = 0xdeadbeef -> rd = 0xdeadbeef_aaaaaaaa
  TEST_RR_OP( 5, ppairo.w, 0xdeadbeefaaaaaaaa, 0xaaaaaaaa11111111, 0xdeadbeef12345678 );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN
  TEST_DATA
RVTEST_DATA_END
