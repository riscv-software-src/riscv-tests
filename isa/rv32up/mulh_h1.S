# See LICENSE for license details.

#*****************************************************************************
# mulh_h1.S
#-----------------------------------------------------------------------------
#
# Test mulh.h1 instruction (signed high multiply with high half of rs2).
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV32U
RVTEST_CODE_BEGIN

  #-------------------------------------------------------------
  # Arithmetic tests
  #-------------------------------------------------------------

  # mulh.h1 rd, rs1, rs2 = (sext64(rs1) * sext64(rs2[31:16])) >> 32

  # Test case 1: High result of multiply
  TEST_RR_OP( 2, mulh.h1, 0x00000000, 0x00000002, 0x00030000 );

  # Test case 2: Zero multiply
  TEST_RR_OP( 3, mulh.h1, 0x00000000, 0x00000000, 0x00050000 );

  # Test case 3: Large values to get non-zero high result
  TEST_RR_OP( 4, mulh.h1, 0x00007fff, 0x7fffffff, 0x7fff0000 );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END

