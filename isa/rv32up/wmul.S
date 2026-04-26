# See LICENSE for license details.

#*****************************************************************************
# wmul.S
#-----------------------------------------------------------------------------
#
# Test wmul instruction (Widening multiply - signed).
# RV32-only instruction using register pair for 64-bit result.
# Multiplies signed 32-bit rs1 and rs2 to produce 64-bit signed result.
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV32U
RVTEST_CODE_BEGIN

  #-------------------------------------------------------------
  # Arithmetic tests
  #-------------------------------------------------------------

  # wmul rd, rs1, rs2
  # rd_pair = (int64_t)rs1 * (int64_t)rs2

  # Test 2: Simple positive multiply
  # rs1 = 3, rs2 = 5
  # Result: 15
  # Low: 15 = 0x0000000f
  TEST_RR_OP( 2, wmul, 0x0000000f, 0x00000003, 0x00000005 );

  # Test 3: Zero values
  TEST_RR_OP( 3, wmul, 0x00000000, 0x00000000, 0x00000000 );

  # Test 4: One operand zero
  TEST_RR_OP( 4, wmul, 0x00000000, 0x12345678, 0x00000000 );

  # Test 5: Negative value multiply
  # rs1 = -1 (0xffffffff), rs2 = 5
  # Result: -5
  # Low: 0xfffffffb
  TEST_RR_OP( 5, wmul, 0xfffffffb, 0xffffffff, 0x00000005 );

  # Test 6: Both negative
  # rs1 = -2 (0xfffffffe), rs2 = -3 (0xfffffffd)
  # Result: 6
  # Low: 0x00000006
  TEST_RR_OP( 6, wmul, 0x00000006, 0xfffffffe, 0xfffffffd );

  # Test 7: Large positive values
  # rs1 = 0x7fffffff (2147483647), rs2 = 2
  # Result: 4294967294 = 0x0000_0000_ffff_fffe
  # Low: 0xfffffffe
  TEST_RR_OP( 7, wmul, 0xfffffffe, 0x7fffffff, 0x00000002 );

  # Test 8: Max negative multiply
  # rs1 = 0x80000000 (-2147483648), rs2 = 2
  # Result: -4294967296 = 0xffff_ffff_0000_0000
  # Low: 0x00000000
  TEST_RR_OP( 8, wmul, 0x00000000, 0x80000000, 0x00000002 );

  # Test 9: Large multiplication with high bits
  # rs1 = 0x10000000, rs2 = 0x10
  # Result: 0x1_0000_0000
  # Low: 0x00000000
  TEST_RR_OP( 9, wmul, 0x00000000, 0x10000000, 0x00000010 );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END

