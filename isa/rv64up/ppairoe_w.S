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

  # ppairoe.w rd, rs1, rs2
  # Selects odd word from rs1 and even word from rs2 and packs them
  # P_PACK(32, 1, 0) - odd from rs1, even from rs2

  # Test case 1: Distinct word pattern
  # rs1 = 0x0000000200000001, rs2 = 0x0000000400000003
  # Odd word rs1: 0x00000002; Even word rs2: 0x00000003
  TEST_RR_OP( 2, ppairoe.w, 0x0000000200000003, 0x0000000200000001, 0x0000000400000003 );

  # Test case 2: Zero values
  TEST_RR_OP( 3, ppairoe.w, 0x0000000000000000, 0x0000000000000000, 0x0000000000000000 );

  # Test case 3: All ones
  TEST_RR_OP( 4, ppairoe.w, 0xffffffffffffffff, 0xffffffffffffffff, 0xffffffffffffffff );

  # Test case 4: Mixed pattern
  TEST_RR_OP( 5, ppairoe.w, 0xaaaaaaaa12345678, 0xaaaaaaaa11111111, 0xdeadbeef12345678 );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN
  TEST_DATA
RVTEST_DATA_END

