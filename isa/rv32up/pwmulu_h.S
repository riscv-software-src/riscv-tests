# See LICENSE for license details.

#*****************************************************************************
# pwmulu_h.S
#-----------------------------------------------------------------------------
#
# Test pwmulu.h instruction (Packed widening multiply - halfword, unsigned).
# RV32-only instruction using register pairs for 64-bit result.
# Multiplies unsigned halfwords from rs1 and rs2 to produce unsigned words.
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV32U
RVTEST_CODE_BEGIN

  #-------------------------------------------------------------
  # Arithmetic tests
  #-------------------------------------------------------------

  # pwmulu.h rd, rs1, rs2
  # Each halfword in rs1 is zero-extended and multiplied with corresponding
  # halfword in rs2 (zero-extended), producing 32-bit unsigned results.

  # Test 2: Simple positive multiply
  # rs1 = 0x00020003 (halfwords: 2, 3)
  # rs2 = 0x00040005 (halfwords: 4, 5)
  # Results: 2*4=8, 3*5=15
  # Low: 15 = 0x0000000f
  TEST_RR_OP( 2, pwmulu.h, 0x0000000f, 0x00020003, 0x00040005 );

  # Test 3: Zero values
  TEST_RR_OP( 3, pwmulu.h, 0x00000000, 0x00000000, 0x00000000 );

  # Test 4: One operand zero
  TEST_RR_OP( 4, pwmulu.h, 0x00000000, 0x12345678, 0x00000000 );

  # Test 5: High halfword values (unsigned)
  # rs1 = 0xffffffff (65535 each)
  # rs2 = 0x00020003 (2, 3)
  # Results: 65535*2=131070, 65535*3=196605
  # Low: 196605 = 0x0002fffd
  TEST_RR_OP( 5, pwmulu.h, 0x0002fffd, 0xffffffff, 0x00020003 );

  # Test 6: Both max unsigned
  # rs1 = 0xffffffff (65535 each)
  # rs2 = 0xffffffff (65535 each)
  # Results: 65535*65535 = 4294836225 = 0xfffe0001
  # Low: 0xfffe0001
  TEST_RR_OP( 6, pwmulu.h, 0xfffe0001, 0xffffffff, 0xffffffff );

  # Test 7: Mixed values
  # rs1 = 0x80008000 (32768 each)
  # rs2 = 0x00020002 (2 each)
  # Results: 32768*2 = 65536 = 0x00010000
  # Low: 0x00010000
  TEST_RR_OP( 7, pwmulu.h, 0x00010000, 0x80008000, 0x00020002 );

  # Test 8: High values multiplication
  # rs1 = 0x80008000 (32768 each)
  # rs2 = 0x80008000 (32768 each)
  # Results: 32768*32768 = 1073741824 = 0x40000000
  # Low: 0x40000000
  TEST_RR_OP( 8, pwmulu.h, 0x40000000, 0x80008000, 0x80008000 );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END

