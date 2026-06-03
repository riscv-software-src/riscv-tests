# See LICENSE for license details.

#*****************************************************************************
# sshlr.S
#-----------------------------------------------------------------------------
#
# Test sshlr instruction (scalar saturating shift left with rounding).
# RV32-only instruction.
# Bidirectional saturating shift with rounding on right shifts:
# positive shamt = left shift with saturation, negative shamt = right shift with rounding.
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV32U
RVTEST_CODE_BEGIN

  #-------------------------------------------------------------
  # Arithmetic tests
  #-------------------------------------------------------------

  # sshlr rd, rs1, rs2
  # If rs2[7:0] >= 0: left shift with saturation to 32-bit max
  # If rs2[7:0] < 0: right shift with rounding

  # Test case 1: Left shift without saturation
  # rs1 = 0x00000005, rs2 = 0x00000002 (shift left by 2)
  # Expected: 0x00000014 (5 << 2 = 20)
  TEST_RR_OP_VXSAT( 2, sshlr, 0x00000014, 0x00000005, 0x00000002, 0  );

  # Test case 2: Left shift with saturation
  # rs1 = 0x40000000, rs2 = 0x00000002 (shift left by 2)
  # Expected: 0xFFFFFFFF (saturated to max)
  TEST_RR_OP_VXSAT( 3, sshlr, 0xFFFFFFFF, 0x40000000, 0x00000002, 1  );

  # Test case 3: Right shift with rounding down
  # rs1 = 0x00000007, rs2 = 0xFFFFFFFF (shift right by 1)
  # Expected: 0x00000004 ((7 << 1 + 1) >> 1 = (15) >> 1 = 7, then round = 4)
  TEST_RR_OP_VXSAT( 4, sshlr, 0x00000004, 0x00000007, 0xFFFFFFFF, 0  );

  # Test case 5: Right shift with rounding up
  # rs1 = 0x00000006, rs2 = 0xFFFFFFFF (shift right by 1)
  # Expected: 0x00000003 ((6 << 1 + 1) >> 1 = (13) >> 1 = 6, then round = 3)
  TEST_RR_OP_VXSAT( 5, sshlr, 0x00000003, 0x00000006, 0xFFFFFFFF, 0  );

  # Test case 6: Right shift by large negative amount (<= -32)
  # rs1 = 0xFFFFFFFF, rs2 = 0xFFFFFFE0 (shift right by 32, with rounding)
  # Per spec: x = zext_64(rs1) @ 0b0 (65-bit), y = x[64:32] = 1 (top bit pulled in
  # from rs1[31]=1), then (y+1)[32:1] = 1. Rounds 0xFFFFFFFF/2^32 ~= 1.
  TEST_RR_OP_VXSAT( 6, sshlr, 0x00000001, 0xFFFFFFFF, 0xFFFFFFE0, 0  );

  # Test case 7: Left shift by 0
  # rs1 = 0x12345678, rs2 = 0x00000000
  # Expected: 0x12345678 (no change)
  TEST_RR_OP_VXSAT( 7, sshlr, 0x12345678, 0x12345678, 0x00000000, 0  );

  # Test case 8: Saturation with maximum value
  # rs1 = 0x7FFFFFFF, rs2 = 0x00000001 (shift left by 2)
  # Expected: 0xFFFFFFFF (saturated)
  TEST_RR_OP_VXSAT( 8, sshlr, 0xFFFFFFFF, 0x7FFFFFFF, 0x00000002, 1  );

  # Test case 9: Zero shifted
  # rs1 = 0x00000000, rs2 = 0x00000005
  # Expected: 0x00000000
  TEST_RR_OP_VXSAT( 9, sshlr, 0x00000000, 0x00000000, 0x00000005, 0  );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END


