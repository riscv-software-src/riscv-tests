# See LICENSE for license details.

#*****************************************************************************
# pwmulsu_b.S
#-----------------------------------------------------------------------------
#
# Test pwmulsu.b instruction (Packed widening multiply - byte, signed-unsigned).
# RV32-only instruction using register pairs for 64-bit result.
# Multiplies signed bytes from rs1 with unsigned bytes from rs2.
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV32U
RVTEST_CODE_BEGIN

  #-------------------------------------------------------------
  # Arithmetic tests
  #-------------------------------------------------------------

  # pwmulsu.b rd, rs1, rs2
  # Each byte in rs1 is sign-extended and multiplied with corresponding
  # byte in rs2 (zero-extended), producing 16-bit signed results.

  # Test 2: Simple positive multiply
  # rs1 = 0x02030405 (bytes: 2, 3, 4, 5)
  # rs2 = 0x01020304 (bytes: 1, 2, 3, 4)
  # Results: 2*1=2, 3*2=6, 4*3=12, 5*4=20
  # Low: 0x000c0014
  TEST_RR_OP( 2, pwmulsu.b, 0x000c0014, 0x02030405, 0x01020304 );

  # Test 3: Zero values
  TEST_RR_OP( 3, pwmulsu.b, 0x00000000, 0x00000000, 0x00000000 );

  # Test 4: One operand zero
  TEST_RR_OP( 4, pwmulsu.b, 0x00000000, 0x12345678, 0x00000000 );

  # Test 5: Signed rs1 with unsigned rs2
  # rs1 = 0xffffffff (-1 each as signed)
  # rs2 = 0x01020304 (1, 2, 3, 4 as unsigned)
  # Results: -1*1=-1, -1*2=-2, -1*3=-3, -1*4=-4
  # Low: 0xfffdfffc
  TEST_RR_OP( 5, pwmulsu.b, 0xfffdfffc, 0xffffffff, 0x01020304 );

  # Test 6: Negative rs1 with high unsigned rs2
  # rs1 = 0xfefefefe (-2 each as signed)
  # rs2 = 0x80808080 (128 each as unsigned)
  # Results: -2 * 128 = -256 = 0xff00
  # Low: 0xff00ff00
  TEST_RR_OP( 6, pwmulsu.b, 0xff00ff00, 0xfefefefe, 0x80808080 );

  # Test 7: Max positive signed with max unsigned
  # rs1 = 0x7f7f7f7f (127 each)
  # rs2 = 0xffffffff (255 each)
  # Results: 127*255 = 32385 = 0x7e81
  # Low: 0x7e817e81
  TEST_RR_OP( 7, pwmulsu.b, 0x7e817e81, 0x7f7f7f7f, 0xffffffff );

  # Test 8: Max negative signed with max unsigned
  # rs1 = 0x80808080 (-128 each)
  # rs2 = 0xffffffff (255 each)
  # Results: -128*255 = -32640 = 0x8080
  # Low: 0x80808080
  TEST_RR_OP( 8, pwmulsu.b, 0x80808080, 0x80808080, 0xffffffff );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END

