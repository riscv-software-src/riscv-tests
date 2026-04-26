# See LICENSE for license details.

#*****************************************************************************
# ppaire_h.S
#-----------------------------------------------------------------------------
#
# Test ppaire.h instruction (packed pair even halfword, RV64 only).
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV64U
RVTEST_CODE_BEGIN

  # ppaire.h rd, rs1, rs2
  # Selects even halfwords from both rs1 and rs2 and packs them
  # P_PACK(16, 0, 0) - even from rs1, even from rs2

  # Test case 1: Distinct halfword pattern
  # rs1 = 0x0003000200010000, rs2 = 0x0007000600050004
  # Even halfwords rs1: 0000, 0002; Even halfwords rs2: 0004, 0006
  TEST_RR_OP( 2, ppaire.h, 0x0006000200040000, 0x0003000200010000, 0x0007000600050004 );

  # Test case 2: Zero values
  TEST_RR_OP( 3, ppaire.h, 0x0000000000000000, 0x0000000000000000, 0x0000000000000000 );

  # Test case 3: All ones
  TEST_RR_OP( 4, ppaire.h, 0xffffffffffffffff, 0xffffffffffffffff, 0xffffffffffffffff );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN
  TEST_DATA
RVTEST_DATA_END

