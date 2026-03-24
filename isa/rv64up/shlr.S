# See LICENSE for license details.

#*****************************************************************************
# shlr.S
#-----------------------------------------------------------------------------
#
# Test shlr instruction (scalar shift left with rounding).
# RV64-only instruction.
# Bidirectional shift with rounding: positive shamt = left shift,
# negative shamt = right shift with rounding.
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV64U
RVTEST_CODE_BEGIN

  #-------------------------------------------------------------
  # Arithmetic tests
  #-------------------------------------------------------------

  # shlr rd, rs1, rs2
  # If rs2[7:0] >= 0: left shift
  # If rs2[7:0] < 0: right shift with rounding

  # Test case 1: Left shift
  # rs1 = 0x0000000000000005, rs2 = 0x0000000000000002
  # Expected: 0x0000000000000014 (5 << 2 = 20)
  TEST_RR_OP( 2, shlr, 0x0000000000000014, 0x0000000000000005, 0x0000000000000002 );

  # Test case 2: Right shift with rounding
  # rs1 = 0x0000000000000007, rs2 = 0xFFFFFFFFFFFFFFFF (shift right by 1)
  # Expected: 0x0000000000000004 (rounding)
  TEST_RR_OP( 3, shlr, 0x0000000000000004, 0x0000000000000007, 0xFFFFFFFFFFFFFFFF );

  # Test case 3: Right shift with rounding
  # rs1 = 0x0000000000000006, rs2 = 0xFFFFFFFFFFFFFFFF (shift right by 1)
  # Expected: 0x0000000000000003 (rounding)
  TEST_RR_OP( 4, shlr, 0x0000000000000003, 0x0000000000000006, 0xFFFFFFFFFFFFFFFF );

  # Test case 4: Left shift by 0
  # rs1 = 0x123456789ABCDEF0, rs2 = 0x0000000000000000
  # Expected: 0x123456789ABCDEF0
  TEST_RR_OP( 5, shlr, 0x123456789ABCDEF0, 0x123456789ABCDEF0, 0x0000000000000000 );

  # Test case 5: Right shift by large negative amount (<= -64)
  # rs1 = 0xFFFFFFFFFFFFFFFF, rs2 = 0xFFFFFFFFFFFFFFC0 (shift right by 64)
  # Expected: 0x0000000000000001
  TEST_RR_OP( 6, shlr, 0x0000000000000001, 0xFFFFFFFFFFFFFFFF, 0xFFFFFFFFFFFFFFC0 );

  # Test case 6: Left shift by large amount (>= 64)
  # rs1 = 0x0000000000000001, rs2 = 0x0000000000000040
  # Expected: 0x0000000000000000
  TEST_RR_OP( 7, shlr, 0x0000000000000000, 0x0000000000000001, 0x0000000000000040 );

  # Test case 7: Zero shifted
  # rs1 = 0x0000000000000000, rs2 = 0x0000000000000005
  # Expected: 0x0000000000000000
  TEST_RR_OP( 8, shlr, 0x0000000000000000, 0x0000000000000000, 0x0000000000000005 );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END


