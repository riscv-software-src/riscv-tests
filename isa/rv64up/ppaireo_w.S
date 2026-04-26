# See LICENSE for license details.

#*****************************************************************************
# ppaireo_w.S
#-----------------------------------------------------------------------------
#
# Test ppaireo.w instruction (packed pair even-odd word, RV64 only).
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV64U
RVTEST_CODE_BEGIN

  # ppaireo.w rd, rs1, rs2
  # Selects even word from rs1 and odd word from rs2 and packs them
  # P_PACK(32, 0, 1) - even from rs1, odd from rs2

  # Test case 1: Distinct word pattern
  # rs1 = 0x0000000200000001, rs2 = 0x0000000400000003
  # Even word rs1: 0x00000001; Odd word rs2: 0x00000004
  TEST_RR_OP( 2, ppaireo.w, 0x0000000400000001, 0x0000000200000001, 0x0000000400000003 );

  # Test case 2: Zero values
  TEST_RR_OP( 3, ppaireo.w, 0x0000000000000000, 0x0000000000000000, 0x0000000000000000 );

  # Test case 3: All ones
  TEST_RR_OP( 4, ppaireo.w, 0xffffffffffffffff, 0xffffffffffffffff, 0xffffffffffffffff );

  # Test case 4: Mixed pattern
  TEST_RR_OP( 5, ppaireo.w, 0xdeadbeef12345678, 0xaaaaaaaa12345678, 0xdeadbeefbbbbbbbb );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN
  TEST_DATA
RVTEST_DATA_END

