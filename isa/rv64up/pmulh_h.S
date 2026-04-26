# See LICENSE for license details.

#*****************************************************************************
# pmulh_h.S
#-----------------------------------------------------------------------------
#
# Test pmulh.h instruction (packed signed high multiply, 16-bit).
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV64U
RVTEST_CODE_BEGIN

  #-------------------------------------------------------------
  # Arithmetic tests
  #-------------------------------------------------------------

  # pmulh.h rd, rs1, rs2 = packed (sext(rs1) * sext(rs2)) >> 16

  # Test case 1: High result of multiply
  TEST_RR_OP( 2, pmulh.h, 0x0000000000000000, 0x0002000200020002, 0x0003000300030003 );

  # Test case 2: Zero multiply
  TEST_RR_OP( 3, pmulh.h, 0x0000000000000000, 0x0000000000000000, 0x0005000500050005 );

  # Test case 3: Large values to get non-zero high result
  TEST_RR_OP( 4, pmulh.h, 0x3fff3fff3fff3fff, 0x7fff7fff7fff7fff, 0x7fff7fff7fff7fff );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END

