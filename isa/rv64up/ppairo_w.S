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

  # ppairo.w rd, rs1, rs2
  # Selects odd words from both rs1 and rs2 and packs them
  # P_PACK(32, 1, 1) - odd from rs1, odd from rs2

  # Test case 1: Distinct word pattern
  # rs1 = 0x0000000200000001, rs2 = 0x0000000400000003
  # Odd word rs1: 0x00000002; Odd word rs2: 0x00000004
  TEST_RR_OP( 2, ppairo.w, 0x0000000200000004, 0x0000000200000001, 0x0000000400000003 );

  # Test case 2: Zero values
  TEST_RR_OP( 3, ppairo.w, 0x0000000000000000, 0x0000000000000000, 0x0000000000000000 );

  # Test case 3: All ones
  TEST_RR_OP( 4, ppairo.w, 0xffffffffffffffff, 0xffffffffffffffff, 0xffffffffffffffff );

  # Test case 4: Mixed pattern
  TEST_RR_OP( 5, ppairo.w, 0xaaaaaaaadeadbeef, 0xaaaaaaaa11111111, 0xdeadbeef12345678 );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN
  TEST_DATA
RVTEST_DATA_END

