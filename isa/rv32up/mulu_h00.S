# See LICENSE for license details.

#*****************************************************************************
# mulu_h00.S
#-----------------------------------------------------------------------------
#
# Test mulu.h00 instruction (unsigned 16-bit multiply, low halves).
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV32U
RVTEST_CODE_BEGIN

  #-------------------------------------------------------------
  # Arithmetic tests
  #-------------------------------------------------------------

  # mulu.h00 rd, rs1, rs2 = zext(rs1[15:0]) * zext(rs2[15:0])

  # Test case 1: Simple multiply 2 * 3 = 6
  TEST_RR_OP( 2, mulu.h00, 0x00000006, 0x00000002, 0x00000003 );

  # Test case 2: Zero multiply
  TEST_RR_OP( 3, mulu.h00, 0x00000000, 0x00000000, 0x00000005 );

  # Test case 3: 0x0101 * 0x0202 = 0x00020402
  TEST_RR_OP( 4, mulu.h00, 0x00020402, 0x00000101, 0x00000202 );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END

