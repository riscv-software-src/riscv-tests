# See LICENSE for license details.

#*****************************************************************************
# pwmulsu_h.S
#-----------------------------------------------------------------------------
#
# Test pwmulsu.h instruction (Packed widening multiply - halfword, signed-unsigned).
# RV32-only instruction using register pairs for 64-bit result.
# Multiplies signed halfwords from rs1 with unsigned halfwords from rs2.
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV32U
RVTEST_CODE_BEGIN

  #-------------------------------------------------------------
  # Arithmetic tests
  #-------------------------------------------------------------

  # pwmulsu.h rd, rs1, rs2
  # Each halfword in rs1 is sign-extended and multiplied with corresponding
  # halfword in rs2 (zero-extended), producing 32-bit signed results.

  # Test 2: Simple positive multiply
  # rs1 = 0x00020003 (halfwords: 2, 3)
  # rs2 = 0x00040005 (halfwords: 4, 5)
  # Results: 2*4=8, 3*5=15
  # Low: 15 = 0x0000000f
  TEST_RR_OP( 2, pwmulsu.h, 0x0000000f, 0x00020003, 0x00040005 );

  # Test 3: Zero values
  TEST_RR_OP( 3, pwmulsu.h, 0x00000000, 0x00000000, 0x00000000 );

  # Test 4: One operand zero
  TEST_RR_OP( 4, pwmulsu.h, 0x00000000, 0x12345678, 0x00000000 );

  # Test 5: Signed rs1 with unsigned rs2
  # rs1 = 0xffffffff (-1 each as signed)
  # rs2 = 0x00020003 (2, 3 as unsigned)
  # Results: -1*2=-2, -1*3=-3
  # Low: -3 = 0xfffffffd
  TEST_RR_OP( 5, pwmulsu.h, 0xfffffffd, 0xffffffff, 0x00020003 );

  # Test 6: Negative rs1 with high unsigned rs2
  # rs1 = 0xfffeffff (-2, -1 as signed)
  # rs2 = 0x80008000 (32768 each as unsigned)
  # Results: -2*32768=-65536, -1*32768=-32768
  # Low: -32768 = 0xffff8000
  TEST_RR_OP( 6, pwmulsu.h, 0xffff8000, 0xfffeffff, 0x80008000 );

  # Test 7: Max positive signed with max unsigned
  # rs1 = 0x7fff7fff (32767 each)
  # rs2 = 0xffffffff (65535 each)
  # Results: 32767*65535 = 2147385345 = 0x7ffe8001
  # Low: 0x7ffe8001
  TEST_RR_OP( 7, pwmulsu.h, 0x7ffe8001, 0x7fff7fff, 0xffffffff );

  # Test 8: Max negative signed with max unsigned
  # rs1 = 0x80008000 (-32768 each)
  # rs2 = 0xffffffff (65535 each)
  # Results: -32768*65535 = -2147418112 = 0x80008000
  # Low: 0x80008000
  TEST_RR_OP( 8, pwmulsu.h, 0x80008000, 0x80008000, 0xffffffff );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END

