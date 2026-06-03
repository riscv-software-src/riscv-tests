# See LICENSE for license details.

#*****************************************************************************
# mulqr.S
#-----------------------------------------------------------------------------
#
# Test mulqr instruction (Q-format signed multiply with rounding).
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV32U
RVTEST_CODE_BEGIN

  #-------------------------------------------------------------
  # Arithmetic tests
  #-------------------------------------------------------------

  # mulqr rd, rs1, rs2 — rd = (signed(rs1) * signed(rs2) + 2^30)[62:31].
  # Saturates to 0x7FFFFFFF only when both inputs are 0x80000000.

  # Test case 1: Tiny values, rounding addend doesn't reach next bit
  TEST_RR_OP_VXSAT( 2, mulqr, 0x00000000, 0x00000002, 0x00000003, 0  );

  # Test case 2: Zero multiply
  TEST_RR_OP_VXSAT( 3, mulqr, 0x00000000, 0x00000000, 0x00000005, 0  );

  # Test case 3: Max positive squared with rounding
  #   (0x7FFFFFFF^2 + 2^30) >> 31 = 0x7FFFFFFE
  TEST_RR_OP_VXSAT( 4, mulqr, 0x7ffffffe, 0x7fffffff, 0x7fffffff, 0  );

  # Test case 4: Min negative squared (saturation corner)
  TEST_RR_OP_VXSAT( 5, mulqr, 0x7fffffff, 0x80000000, 0x80000000, 1  );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END

