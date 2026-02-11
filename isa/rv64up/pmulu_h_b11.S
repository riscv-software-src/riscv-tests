# See LICENSE for license details.

#*****************************************************************************
# pmulu_h_b11.S
#-----------------------------------------------------------------------------
#
# Test pmulu.h.b11 instruction (packed unsigned 8-bit to 16-bit multiply, high bytes).
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV64U
RVTEST_CODE_BEGIN

  #-------------------------------------------------------------
  # Arithmetic tests
  #-------------------------------------------------------------

  # pmulu.h.b11 rd, rs1, rs2 = packed zext(rs1[15:8]) * zext(rs2[15:8]) -> 16-bit

  # Test case 1: Simple multiply 2 * 3 = 6 in each packed element
  TEST_RR_OP( 2, pmulu.h.b11, 0x0006000600060006, 0x0202020202020202, 0x0303030303030303 );

  # Test case 2: Zero multiply
  TEST_RR_OP( 3, pmulu.h.b11, 0x0000000000000000, 0x0000000000000000, 0x0505050505050505 );

  # Test case 3: Mixed values
  TEST_RR_OP( 4, pmulu.h.b11, 0x0004000400040004, 0x0202020202020202, 0x0202020202020202 );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END

