# See LICENSE for license details.

#*****************************************************************************
# pmulh_h_b1.S
#-----------------------------------------------------------------------------
#
# Test pmulh.h.b1 instruction (packed signed high multiply, high byte).
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV64U
RVTEST_CODE_BEGIN

  #-------------------------------------------------------------
  # Arithmetic tests
  #-------------------------------------------------------------

  # pmulh.h.b1 rd, rs1, rs2 = packed (sext(rs1[15:0]) * sext(rs2[15:8])) >> 16

  # Test case 1: High result of multiply
  TEST_RR_OP( 2, pmulh.h.b1, 0x0000000000000000, 0x0002000200020002, 0x0303030303030303 );

  # Test case 2: Zero multiply
  TEST_RR_OP( 3, pmulh.h.b1, 0x0000000000000000, 0x0000000000000000, 0x0505050505050505 );

  # Test case 3: Large values to get non-zero high result
  TEST_RR_OP( 4, pmulh.h.b1, 0x007e007e007e007e, 0x7fff7fff7fff7fff, 0x7f7f7f7f7f7f7f7f );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END

