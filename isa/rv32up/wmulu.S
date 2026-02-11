# See LICENSE for license details.

#*****************************************************************************
# wmulu.S
#-----------------------------------------------------------------------------
#
# Test wmulu instruction (Widening multiply - unsigned).
# RV32-only instruction using register pair for 64-bit result.
# Multiplies unsigned 32-bit rs1 and rs2 to produce 64-bit unsigned result.
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV32U
RVTEST_CODE_BEGIN

  #-------------------------------------------------------------
  # Arithmetic tests
  #-------------------------------------------------------------

  # wmulu rd, rs1, rs2
  # rd_pair = (uint64_t)(uint32_t)rs1 * (uint64_t)(uint32_t)rs2

  # Test 2: Simple positive multiply
  # rs1 = 3, rs2 = 5
  # Result: 15
  # Low: 15 = 0x0000000f
  TEST_RR_OP( 2, wmulu, 0x0000000f, 0x00000003, 0x00000005 );

  # Test 3: Zero values
  TEST_RR_OP( 3, wmulu, 0x00000000, 0x00000000, 0x00000000 );

  # Test 4: One operand zero
  TEST_RR_OP( 4, wmulu, 0x00000000, 0x12345678, 0x00000000 );

  # Test 5: Large unsigned values
  # rs1 = 0xffffffff (4294967295), rs2 = 2
  # Result: 8589934590 = 0x0000_0001_ffff_fffe
  # Low: 0xfffffffe
  TEST_RR_OP( 5, wmulu, 0xfffffffe, 0xffffffff, 0x00000002 );

  # Test 6: Both max unsigned
  # rs1 = 0xffffffff (4294967295), rs2 = 0xffffffff (4294967295)
  # Result: 18446744065119617025 = 0xffff_fffe_0000_0001
  # Low: 0x00000001
  TEST_RR_OP( 6, wmulu, 0x00000001, 0xffffffff, 0xffffffff );

  # Test 7: High bit values
  # rs1 = 0x80000000 (2147483648), rs2 = 2
  # Result: 4294967296 = 0x0000_0001_0000_0000
  # Low: 0x00000000
  TEST_RR_OP( 7, wmulu, 0x00000000, 0x80000000, 0x00000002 );

  # Test 8: Large multiplication
  # rs1 = 0x80000000, rs2 = 0x80000000
  # Result: 4611686018427387904 = 0x4000_0000_0000_0000
  # Low: 0x00000000
  TEST_RR_OP( 8, wmulu, 0x00000000, 0x80000000, 0x80000000 );

  # Test 9: Mixed high/low values
  # rs1 = 0x10000000, rs2 = 0x10
  # Result: 0x1_0000_0000 = 4294967296
  # Low: 0x00000000
  TEST_RR_OP( 9, wmulu, 0x00000000, 0x10000000, 0x00000010 );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END

