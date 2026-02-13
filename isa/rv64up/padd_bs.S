# See LICENSE for license details.

#*****************************************************************************
# padd_bs.S
#-----------------------------------------------------------------------------
#
# Test padd.bs instruction (packed byte add with scalar second operand).
# Each byte of rd = rs1_byte_i + rs2[7:0]; addition wraps modulo 2^8 (no saturation).
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV64U
RVTEST_CODE_BEGIN

  #-------------------------------------------------------------
  # Arithmetic tests
  #-------------------------------------------------------------

  # padd.bs rd, rs1, rs2
  # Each byte of rd = byte_i(rs1) + rs2[7:0], wrap mod 2^8.

  # Test case 1: Simple add of broadcast scalar 0x01
  TEST_RR_OP( 2, padd.bs, 0x0203040506070809, 0x0102030405060708, 0x0101010101010101 );

  # Test case 2: Zero + Zero = Zero
  TEST_RR_OP( 3, padd.bs, 0x0000000000000000, 0x0000000000000000, 0x0000000000000000 );

  # Test case 3: Modular wrap on signed overflow (0x70 + 0x70 = 0xE0 per byte)
  TEST_RR_OP( 4, padd.bs, 0xe0e0e0e0e0e0e0e0, 0x7070707070707070, 0x7070707070707070 );

  # Test case 4: Only rs2[7:0] is used; higher bytes of rs2 are ignored
  TEST_RR_OP( 5, padd.bs, 0x0203040506070809, 0x0102030405060708, 0xdeadbeefcafe1101 );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END

