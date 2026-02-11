# See LICENSE for license details.

#*****************************************************************************
# pwmul_b.S
#-----------------------------------------------------------------------------
#
# Test pwmul.b instruction (Packed widening multiply - byte, signed).
# RV32-only instruction using register pairs for 64-bit result.
# Multiplies signed bytes from rs1 and rs2 to produce signed halfwords.
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV32U
RVTEST_CODE_BEGIN

  #-------------------------------------------------------------
  # Arithmetic tests
  #-------------------------------------------------------------

  # pwmul.b rd, rs1, rs2
  # Each byte in rs1 is sign-extended and multiplied with corresponding
  # byte in rs2 (sign-extended), producing 16-bit signed results.

  # Test 2: Simple positive multiply
  # rs1 = 0x02030405 (bytes: 2, 3, 4, 5)
  # rs2 = 0x01020304 (bytes: 1, 2, 3, 4)
  # Results: 2*1=2, 3*2=6, 4*3=12, 5*4=20
  # = 0x0002000600140014 -> 0x0002000600140014 (low: 0x000c0014)
  TEST_RR_OP( 2, pwmul.b, 0x000c0014, 0x02030405, 0x01020304 );

  # Test 3: Zero values
  TEST_RR_OP( 3, pwmul.b, 0x00000000, 0x00000000, 0x00000000 );

  # Test 4: One operand zero
  TEST_RR_OP( 4, pwmul.b, 0x00000000, 0x12345678, 0x00000000 );

  # Test 5: Negative values (signed multiply)
  # rs1 = 0xffffffff (all -1)
  # rs2 = 0x01020304 (1, 2, 3, 4)
  # Results: -1*1=-1, -1*2=-2, -1*3=-3, -1*4=-4
  # Low: ((-3) << 16) | ((-4) & 0xffff) = 0xfffdfffc
  TEST_RR_OP( 5, pwmul.b, 0xfffdfffc, 0xffffffff, 0x01020304 );

  # Test 6: Both negative
  # rs1 = 0xfefefefe (-2 each)
  # rs2 = 0xfefefefe (-2 each)
  # Results: -2 * -2 = 4
  # Low: 0x00040004
  TEST_RR_OP( 6, pwmul.b, 0x00040004, 0xfefefefe, 0xfefefefe );

  # Test 7: Max positive bytes
  # rs1 = 0x7f7f7f7f (127 each)
  # rs2 = 0x02020202 (2 each)
  # Results: 127*2 = 254 = 0x00fe
  # Low: 0x00fe00fe
  TEST_RR_OP( 7, pwmul.b, 0x00fe00fe, 0x7f7f7f7f, 0x02020202 );

  # Test 8: Max negative byte
  # rs1 = 0x80808080 (-128 each)
  # rs2 = 0x02020202 (2 each)
  # Results: -128*2 = -256 = 0xff00
  # Low: 0xff00ff00
  TEST_RR_OP( 8, pwmul.b, 0xff00ff00, 0x80808080, 0x02020202 );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END

