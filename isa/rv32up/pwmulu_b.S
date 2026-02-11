# See LICENSE for license details.

#*****************************************************************************
# pwmulu_b.S
#-----------------------------------------------------------------------------
#
# Test pwmulu.b instruction (Packed widening multiply - byte, unsigned).
# RV32-only instruction using register pairs for 64-bit result.
# Multiplies unsigned bytes from rs1 and rs2 to produce unsigned halfwords.
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV32U
RVTEST_CODE_BEGIN

  #-------------------------------------------------------------
  # Arithmetic tests
  #-------------------------------------------------------------

  # pwmulu.b rd, rs1, rs2
  # Each byte in rs1 is zero-extended and multiplied with corresponding
  # byte in rs2 (zero-extended), producing 16-bit unsigned results.

  # Test 2: Simple positive multiply
  # rs1 = 0x02030405 (bytes: 2, 3, 4, 5)
  # rs2 = 0x01020304 (bytes: 1, 2, 3, 4)
  # Results: 2*1=2, 3*2=6, 4*3=12, 5*4=20
  # Low: 0x000c0014
  TEST_RR_OP( 2, pwmulu.b, 0x000c0014, 0x02030405, 0x01020304 );

  # Test 3: Zero values
  TEST_RR_OP( 3, pwmulu.b, 0x00000000, 0x00000000, 0x00000000 );

  # Test 4: One operand zero
  TEST_RR_OP( 4, pwmulu.b, 0x00000000, 0x12345678, 0x00000000 );

  # Test 5: High byte values (unsigned)
  # rs1 = 0xffffffff (255 each)
  # rs2 = 0x01020304 (1, 2, 3, 4)
  # Results: 255*1=255, 255*2=510, 255*3=765, 255*4=1020
  # Low: (765 << 16) | 1020 = 0x02fd03fc
  TEST_RR_OP( 5, pwmulu.b, 0x02fd03fc, 0xffffffff, 0x01020304 );

  # Test 6: Both max unsigned
  # rs1 = 0xffffffff (255 each)
  # rs2 = 0xffffffff (255 each)
  # Results: 255*255 = 65025 = 0xfe01
  # Low: 0xfe01fe01
  TEST_RR_OP( 6, pwmulu.b, 0xfe01fe01, 0xffffffff, 0xffffffff );

  # Test 7: Mixed values
  # rs1 = 0x80808080 (128 each)
  # rs2 = 0x02020202 (2 each)
  # Results: 128*2 = 256 = 0x0100
  # Low: 0x01000100
  TEST_RR_OP( 7, pwmulu.b, 0x01000100, 0x80808080, 0x02020202 );

  # Test 8: High values multiplication
  # rs1 = 0x80808080 (128 each)
  # rs2 = 0x80808080 (128 each)
  # Results: 128*128 = 16384 = 0x4000
  # Low: 0x40004000
  TEST_RR_OP( 8, pwmulu.b, 0x40004000, 0x80808080, 0x80808080 );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END

