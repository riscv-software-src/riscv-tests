# See LICENSE for license details.

#*****************************************************************************
# wmulsu.S
#-----------------------------------------------------------------------------
#
# Test wmulsu instruction (Widening multiply - signed-unsigned).
# RV32-only instruction using register pair for 64-bit result.
# Multiplies signed 32-bit rs1 with unsigned 32-bit rs2.
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV32U
RVTEST_CODE_BEGIN

  #-------------------------------------------------------------
  # Arithmetic tests
  #-------------------------------------------------------------

  # wmulsu rd, rs1, rs2
  # rd_pair = (int64_t)rs1 * (uint64_t)(uint32_t)rs2

  # Test 2: Simple positive multiply
  # rs1 = 3, rs2 = 5
  # Result: 15
  # Low: 15 = 0x0000000f
  TEST_RR_OP( 2, wmulsu, 0x0000000f, 0x00000003, 0x00000005 );

  # Test 3: Zero values
  TEST_RR_OP( 3, wmulsu, 0x00000000, 0x00000000, 0x00000000 );

  # Test 4: One operand zero
  TEST_RR_OP( 4, wmulsu, 0x00000000, 0x12345678, 0x00000000 );

  # Test 5: Signed rs1 with unsigned rs2
  # rs1 = -1 (0xffffffff as signed), rs2 = 5 (unsigned)
  # Result: -5
  # Low: 0xfffffffb
  TEST_RR_OP( 5, wmulsu, 0xfffffffb, 0xffffffff, 0x00000005 );

  # Test 6: Negative rs1 with large unsigned rs2
  # rs1 = -1 (0xffffffff), rs2 = 0x80000000 (2147483648 unsigned)
  # Result: -2147483648 = 0xffff_ffff_8000_0000
  # Low: 0x80000000
  TEST_RR_OP( 6, wmulsu, 0x80000000, 0xffffffff, 0x80000000 );

  # Test 7: Positive rs1 with max unsigned rs2
  # rs1 = 2, rs2 = 0xffffffff (4294967295 unsigned)
  # Result: 8589934590 = 0x0000_0001_ffff_fffe
  # Low: 0xfffffffe
  TEST_RR_OP( 7, wmulsu, 0xfffffffe, 0x00000002, 0xffffffff );

  # Test 8: Max negative rs1 with unsigned rs2
  # rs1 = 0x80000000 (-2147483648), rs2 = 2
  # Result: -4294967296 = 0xffff_ffff_0000_0000
  # Low: 0x00000000
  TEST_RR_OP( 8, wmulsu, 0x00000000, 0x80000000, 0x00000002 );

  # Test 9: Negative rs1 with max unsigned rs2
  # rs1 = -2 (0xfffffffe), rs2 = 0xffffffff (4294967295)
  # Result: -8589934590 = 0xffff_fffe_0000_0002
  # Low: 0x00000002
  TEST_RR_OP( 9, wmulsu, 0x00000002, 0xfffffffe, 0xffffffff );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END

