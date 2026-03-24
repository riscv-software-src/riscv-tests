# See LICENSE for license details.

#*****************************************************************************
# sshl.S
#-----------------------------------------------------------------------------
#
# Test sshl instruction (scalar saturating shift left).
# RV32-only instruction.
# Bidirectional saturating shift: positive shamt = left shift with saturation,
# negative shamt = right shift (logical).
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV32U
RVTEST_CODE_BEGIN

  #-------------------------------------------------------------
  # Arithmetic tests
  #-------------------------------------------------------------

  # sshl rd, rs1, rs2
  # If rs2[7:0] >= 0: left shift with saturation to 32-bit max
  # If rs2[7:0] < 0: right shift logical

  # Test case 1: Left shift without saturation
  # rs1 = 0x00000005, rs2 = 0x00000002 (shift left by 2)
  # Expected: 0x00000014 (5 << 2 = 20)
  TEST_RR_OP_VXSAT( 2, sshl, 0x00000014, 0x00000005, 0x00000002, 0  );

  # Test case 2: Left shift with saturation
  # rs1 = 0x40000000, rs2 = 0x00000002 (shift left by 2)
  # Expected: 0xFFFFFFFF (saturated to max)
  TEST_RR_OP_VXSAT( 3, sshl, 0xFFFFFFFF, 0x40000000, 0x00000002, 1  );

  # Test case 3: Left shift by 0
  # rs1 = 0x12345678, rs2 = 0x00000000
  # Expected: 0x12345678 (no change)
  TEST_RR_OP_VXSAT( 4, sshl, 0x12345678, 0x12345678, 0x00000000, 0  );

  # Test case 4: Left shift by large amount (>= 32)
  # rs1 = 0x00000001, rs2 = 0x00000020 (shift left by 32)
  # Per spec, sshamt >= 32 -> shx = (s1 @ 0x00000000) = 0x100000000,
  # exceeds 0xFFFFFFFF so result saturates to 0xFFFFFFFF, vxsat=1.
  TEST_RR_OP_VXSAT( 5, sshl, 0xFFFFFFFF, 0x00000001, 0x00000020, 1  );

  # Test case 5: Right shift (negative shamt)
  # rs1 = 0x80000000, rs2 = 0xFFFFFFFC (shift right by 4)
  # Expected: 0x08000000 (logical right shift)
  TEST_RR_OP_VXSAT( 6, sshl, 0x08000000, 0x80000000, 0xFFFFFFFC, 0  );

  # Test case 6: Right shift by large negative amount (<= -32)
  # rs1 = 0xFFFFFFFF, rs2 = 0xFFFFFFE0 (shift right by 32)
  # Expected: 0x00000000
  TEST_RR_OP_VXSAT( 7, sshl, 0x00000000, 0xFFFFFFFF, 0xFFFFFFE0, 0  );

  # Test case 7: Right shift by -1
  # rs1 = 0x12345678, rs2 = 0xFFFFFFFF (shift right by 1)
  # Expected: 0x091A2B3C
  TEST_RR_OP_VXSAT( 8, sshl, 0x091A2B3C, 0x12345678, 0xFFFFFFFF, 0  );

  # Test case 8: Saturation with maximum value
  # rs1 = 0x7FFFFFFF, rs2 = 0x00000001 (shift left by 2)
  # Expected: 0xFFFFFFFF (saturated)
  TEST_RR_OP_VXSAT( 9, sshl, 0xFFFFFFFF, 0x7FFFFFFF, 0x00000002, 1  );

  # Test case 9: Zero shifted
  # rs1 = 0x00000000, rs2 = 0x00000005
  # Expected: 0x00000000
  TEST_RR_OP_VXSAT( 10, sshl, 0x00000000, 0x00000000, 0x00000005, 0  );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END


