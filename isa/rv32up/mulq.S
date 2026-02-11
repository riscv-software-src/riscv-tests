# See LICENSE for license details.

#*****************************************************************************
# mulq.S
#-----------------------------------------------------------------------------
#
# Test mulq instruction (Q-format signed multiply).
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV32U
RVTEST_CODE_BEGIN

  #-------------------------------------------------------------
  # Arithmetic tests
  #-------------------------------------------------------------

  # mulq rd, rs1, rs2 — rd = (signed(rs1) * signed(rs2))[62:31].
  # Saturates to 0x7FFFFFFF only when both inputs are 0x80000000.

  # Test case 1: Tiny values, product << 1 fits well below 2^31
  #   (2 * 3) << 1 = 12; upper 32 bits of 64-bit product = 0
  TEST_RR_OP_VXSAT( 2, mulq, 0x00000000, 0x00000002, 0x00000003, 0  );

  # Test case 2: Zero multiply
  TEST_RR_OP_VXSAT( 3, mulq, 0x00000000, 0x00000000, 0x00000005, 0  );

  # Test case 3: Max positive squared
  #   0x7FFFFFFF * 0x7FFFFFFF = 0x3FFFFFFF00000001; bits[62:31] = 0x7FFFFFFE
  TEST_RR_OP_VXSAT( 4, mulq, 0x7ffffffe, 0x7fffffff, 0x7fffffff, 0  );

  # Test case 4: Min negative squared (the one saturation corner case)
  #   0x80000000 * 0x80000000 saturates to 0x7FFFFFFF
  TEST_RR_OP_VXSAT( 5, mulq, 0x7fffffff, 0x80000000, 0x80000000, 1  );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END

