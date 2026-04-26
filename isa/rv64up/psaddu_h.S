# See LICENSE for license details.

#*****************************************************************************
# psaddu_h.S
#-----------------------------------------------------------------------------
#
# Test psaddu.h instruction (packed halfword saturating add, unsigned).
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV64U
RVTEST_CODE_BEGIN

  #-------------------------------------------------------------
  # Arithmetic tests
  #-------------------------------------------------------------

  # psaddu.h rd, rs1, rs2
  # Performs packed unsigned saturating add

  # Test case 1: Simple addition (no saturation)
  TEST_RR_OP( 2, psaddu.h, 0x0002000300040005, 0x0001000200030004, 0x0001000100010001 );

  # Test case 2: Zero + Zero = Zero
  TEST_RR_OP( 3, psaddu.h, 0x0000000000000000, 0x0000000000000000, 0x0000000000000000 );

  # Test case 3: Unsigned saturation (0xF000 + 0xF000 saturates to 0xFFFF)
  TEST_RR_OP( 4, psaddu.h, 0xffffffffffffffff, 0xf000f000f000f000, 0xf000f000f000f000 );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END

