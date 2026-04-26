# See LICENSE for license details.

#*****************************************************************************
# mulhsu_h0.S
#-----------------------------------------------------------------------------
#
# Test mulhsu.h0 instruction (signed-unsigned high multiply with low half).
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV32U
RVTEST_CODE_BEGIN

  #-------------------------------------------------------------
  # Arithmetic tests
  #-------------------------------------------------------------

  # mulhsu.h0 rd, rs1, rs2 = (sext32(rs1) * zext(rs2[15:0])) >> 32

  # Test case 1: High result of multiply
  TEST_RR_OP( 2, mulhsu.h0, 0x00000000, 0x00000002, 0x00000003 );

  # Test case 2: Zero multiply
  TEST_RR_OP( 3, mulhsu.h0, 0x00000000, 0x00000000, 0x00000005 );

  # Test case 3: Large values
  TEST_RR_OP( 4, mulhsu.h0, 0x00007ffe, 0x7fffffff, 0x00007fff );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END

