# See LICENSE for license details.

#*****************************************************************************
# psshl_ws.S
#-----------------------------------------------------------------------------
#
# Test psshlr.ws instruction (packed saturating shift left with rounding word).
# RV64-only instruction.
# Bidirectional saturating shift on each 32-bit element:
# positive shamt = left shift with saturation, negative shamt = right shift (logical).
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV64U
RVTEST_CODE_BEGIN

  #-------------------------------------------------------------
  # Arithmetic tests
  #-------------------------------------------------------------

  # psshlr.ws rd, rs1, rs2
  # For each 32-bit element:
  # If rs2[7:0] >= 0: left shift with saturation to 32-bit max
  # If rs2[7:0] < 0: right shift logical

  # Test case 1: Left shift without saturation
  # rs1 = 0x0000000500000005, rs2 = 0x0000000000000002
  # Expected: 0x0000001400000014
  TEST_RR_OP_VXSAT( 2, psshlr.ws, 0x0000001400000014, 0x0000000500000005, 0x0000000000000002, 0  );

  # Test case 2: Left shift with saturation
  # rs1 = 0x4000000040000000, rs2 = 0x0000000000000002
  # Expected: 0xFFFFFFFFFFFFFFFF
  TEST_RR_OP_VXSAT( 3, psshlr.ws, 0xFFFFFFFFFFFFFFFF, 0x4000000040000000, 0x0000000000000002, 1  );

  # Test case 3: Right shift (negative shamt)
  # rs1 = 0x8000000080000000, rs2 = 0xFFFFFFFFFFFFFFFC (shift right by 4)
  # Expected: 0x0800000008000000
  TEST_RR_OP_VXSAT( 4, psshlr.ws, 0x0800000008000000, 0x8000000080000000, 0xFFFFFFFFFFFFFFFC, 0  );

  # Test case 4: Left shift by 0
  # rs1 = 0x123456789ABCDEF0, rs2 = 0x0000000000000000
  # Expected: 0x123456789ABCDEF0
  TEST_RR_OP_VXSAT( 5, psshlr.ws, 0x123456789ABCDEF0, 0x123456789ABCDEF0, 0x0000000000000000, 0  );

  # Test case 5: Saturation with maximum value
  # rs1 = 0x7FFFFFFF7FFFFFFF, rs2 = 0x0000000000000002
  # Expected: 0xFFFFFFFFFFFFFFFF
  TEST_RR_OP_VXSAT( 6, psshlr.ws, 0xFFFFFFFFFFFFFFFF, 0x7FFFFFFF7FFFFFFF, 0x0000000000000002, 1  );

  # Test case 6: Zero shifted
  # rs1 = 0x0000000000000000, rs2 = 0x0000000000000005
  # Expected: 0x0000000000000000
  TEST_RR_OP_VXSAT( 7, psshlr.ws, 0x0000000000000000, 0x0000000000000000, 0x0000000000000005, 0  );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END

