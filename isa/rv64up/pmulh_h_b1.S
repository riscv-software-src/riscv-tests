# See LICENSE for license details.

#*****************************************************************************
# pmulh_h_b1.S
#-----------------------------------------------------------------------------
#
# Test pmulh.h.b1 instruction (packed signed high multiply, high byte).
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV64U
RVTEST_CODE_BEGIN

  #-------------------------------------------------------------
  # Arithmetic tests
  #-------------------------------------------------------------

  # pmulh.h.b1 (per P-ext spec):
  #   d_h_i = (sext_24(rs1.h_i) * sext_24(rs2.h_i[15:8]))[23:8]

  # Test case 1: rs1.h=2, rs2.b1=3, p=6, [23:8]=0.
  TEST_RR_OP( 2, pmulh.h.b1, 0x0000000000000000, 0x0002000200020002, 0x0303030303030303 );

  # Test case 2: zero -> 0.
  TEST_RR_OP( 3, pmulh.h.b1, 0x0000000000000000, 0x0000000000000000, 0x0505050505050505 );

  # Test case 3: rs1.h=0x7FFF (32767), rs2.b1=0x7F (127), p=32767*127=4161409=0x3F7F81, [23:8]=0x3F7F.
  TEST_RR_OP( 4, pmulh.h.b1, 0x3f7f3f7f3f7f3f7f, 0x7fff7fff7fff7fff, 0x7f7f7f7f7f7f7f7f );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END
