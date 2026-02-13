# See LICENSE for license details.

#*****************************************************************************
# pmulq_h.S
#-----------------------------------------------------------------------------
#
# Test pmulq.h instruction (packed Q-format signed multiply, 16-bit).
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV64U
RVTEST_CODE_BEGIN

  #-------------------------------------------------------------
  # Arithmetic tests
  #-------------------------------------------------------------

  # pmulq.h rd, rs1, rs2 = packed (rs1 * rs2) >> 15 (with saturation)

  # Test case 1: Simple Q-format multiply
  TEST_RR_OP_VXSAT( 2, pmulq.h, 0x0000000000000000, 0x0002000200020002, 0x0003000300030003, 0  );

  # Test case 2: Zero multiply
  TEST_RR_OP_VXSAT( 3, pmulq.h, 0x0000000000000000, 0x0000000000000000, 0x0005000500050005, 0  );

  # Test case 3: Large positive values
  # 0x7FFF * 0x7FFF = 0x3FFF0001; >> 15 = 32766 = 0x7FFE (no saturation)
  TEST_RR_OP_VXSAT( 4, pmulq.h, 0x7ffe7ffe7ffe7ffe, 0x7fff7fff7fff7fff, 0x7fff7fff7fff7fff, 0  );

  # Test case 4: Saturation — INT16_MIN * INT16_MIN overflows >> 15
  # (-32768) * (-32768) = 0x40000000; >> 15 = 32768 > INT16_MAX → saturates to 0x7FFF
  TEST_RR_OP_VXSAT( 5, pmulq.h, 0x7fff7fff7fff7fff, 0x8000800080008000, 0x8000800080008000, 1  );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END

