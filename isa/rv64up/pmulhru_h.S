# See LICENSE for license details.

#*****************************************************************************
# pmulhru_h.S
#-----------------------------------------------------------------------------
#
# Test pmulhru.h instruction (packed unsigned high multiply with rounding).
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV64U
RVTEST_CODE_BEGIN

  #-------------------------------------------------------------
  # Arithmetic tests
  #-------------------------------------------------------------

  # pmulhru.h rd, rs1, rs2 = packed ((zext(rs1) * zext(rs2)) >> 15 + 1) >> 1

  # Test case 1: Simple multiply with rounding
  TEST_RR_OP( 2, pmulhru.h, 0x0000000000000000, 0x0002000200020002, 0x0003000300030003 );

  # Test case 2: Zero multiply
  TEST_RR_OP( 3, pmulhru.h, 0x0000000000000000, 0x0000000000000000, 0x0005000500050005 );

  # Test case 3: Large unsigned values
  TEST_RR_OP( 4, pmulhru.h, 0x7fff7fff7fff7fff, 0xffffffffffffffff, 0x7fff7fff7fff7fff );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END

