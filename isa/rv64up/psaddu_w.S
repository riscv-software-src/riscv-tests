# See LICENSE for license details.

#*****************************************************************************
# psaddu_w.S
#-----------------------------------------------------------------------------
#
# Test psaddu.w instruction (packed word saturating add, unsigned, RV64 only).
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV64U
RVTEST_CODE_BEGIN

  # psaddu.w rd, rs1, rs2
  # Performs packed unsigned saturating add for 32-bit words

  # Test case 1: Simple addition (no saturation)
  TEST_RR_OP_VXSAT( 2, psaddu.w, 0x0000000300000003, 0x0000000100000001, 0x0000000200000002, 0  );

  # Test case 2: Zero + Zero = Zero
  TEST_RR_OP_VXSAT( 3, psaddu.w, 0x0000000000000000, 0x0000000000000000, 0x0000000000000000, 0  );

  # Test case 3: Unsigned saturation (0xF0000000 + 0xF0000000 saturates to 0xFFFFFFFF)
  TEST_RR_OP_VXSAT( 4, psaddu.w, 0xffffffffffffffff, 0xf0000000f0000000, 0xf0000000f0000000, 1  );

  # Test case 4: No saturation with large values
  TEST_RR_OP_VXSAT( 5, psaddu.w, 0x8000000080000000, 0x4000000040000000, 0x4000000040000000, 0  );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN
  TEST_DATA
RVTEST_DATA_END

