# See LICENSE for license details.

#*****************************************************************************
# pwmul_h.S
#-----------------------------------------------------------------------------
#
# Test pwmul.h instruction (Packed widening multiply - halfword, signed).
# RV32-only instruction using register pairs for 64-bit result.
# Multiplies signed halfwords from rs1 and rs2 to produce signed words.
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV32U
RVTEST_CODE_BEGIN

  #-------------------------------------------------------------
  # Arithmetic tests
  #-------------------------------------------------------------

  # pwmul.h rd, rs1, rs2
  # Each halfword in rs1 is sign-extended and multiplied with corresponding
  # halfword in rs2 (sign-extended), producing 32-bit signed results.

  # Test 2: Simple positive multiply
  # rs1 = 0x00020003 (halfwords: 2, 3)
  # rs2 = 0x00040005 (halfwords: 4, 5)
  # Results: 2*4=8, 3*5=15
  # Low: 15 = 0x0000000f
  TEST_RR_OP( 2, pwmul.h, 0x0000000f, 0x00020003, 0x00040005 );

  # Test 3: Zero values
  TEST_RR_OP( 3, pwmul.h, 0x00000000, 0x00000000, 0x00000000 );

  # Test 4: One operand zero
  TEST_RR_OP( 4, pwmul.h, 0x00000000, 0x12345678, 0x00000000 );

  # Test 5: Negative values (signed multiply)
  # rs1 = 0xffffffff (-1, -1)
  # rs2 = 0x00020003 (2, 3)
  # Results: -1*2=-2, -1*3=-3
  # Low: -3 = 0xfffffffd
  TEST_RR_OP( 5, pwmul.h, 0xfffffffd, 0xffffffff, 0x00020003 );

  # Test 6: Both negative
  # rs1 = 0xfffeffff (-2, -1)
  # rs2 = 0xfffeffff (-2, -1)
  # Results: -2*-2=4, -1*-1=1
  # Low: 1 = 0x00000001
  TEST_RR_OP( 6, pwmul.h, 0x00000001, 0xfffeffff, 0xfffeffff );

  # Test 7: Max positive halfword
  # rs1 = 0x7fff7fff (32767 each)
  # rs2 = 0x00020002 (2 each)
  # Results: 32767*2 = 65534 = 0x0000fffe
  # Low: 0x0000fffe
  TEST_RR_OP( 7, pwmul.h, 0x0000fffe, 0x7fff7fff, 0x00020002 );

  # Test 8: Max negative halfword
  # rs1 = 0x80008000 (-32768 each)
  # rs2 = 0x00020002 (2 each)
  # Results: -32768*2 = -65536 = 0xffff0000
  # Low: 0xffff0000
  TEST_RR_OP( 8, pwmul.h, 0xffff0000, 0x80008000, 0x00020002 );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END

