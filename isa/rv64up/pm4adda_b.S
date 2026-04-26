# See LICENSE for license details.

#*****************************************************************************
# pm4adda_b.S
#-----------------------------------------------------------------------------
#
# Test pm4adda.b instruction.
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV64U
RVTEST_CODE_BEGIN

  #-------------------------------------------------------------
  # Arithmetic tests
  #-------------------------------------------------------------

  # pm4adda.b: packed multiply 4-way add accumulate for bytes
  # rd = rd + sum(rs1[i] * rs2[i]) for each 32-bit segment (4 bytes) (with accumulator)
  # Test: 0x00000010 + (0x01*0x02) + (0x02*0x03) + (0x03*0x04) + (0x04*0x05) = 0x10 + 2 + 6 + 12 + 20 = 0x00000038
  TEST_CASE( 2, x14, 0x0000003800000038, \
    li x14, 0x0000001000000010; \
    li a1, 0x0102030401020304; \
    li a2, 0x0203040502030405; \
    pm4adda.b x14, a1, a2 );

  # Test: 0x00000000 + (0x01*0x01) + (0x01*0x01) + (0x01*0x01) + (0x01*0x01) = 0x00 + 1 + 1 + 1 + 1 = 0x00000004
  TEST_CASE( 3, x14, 0x0000000400000004, \
    li x14, 0x0000000000000000; \
    li a1, 0x0101010101010101; \
    li a2, 0x0101010101010101; \
    pm4adda.b x14, a1, a2 );

  # Test: 0x00000005 + (0x02*0x02) + (0x02*0x02) + (0x02*0x02) + (0x02*0x02) = 0x05 + 4 + 4 + 4 + 4 = 0x00000015
  TEST_CASE( 4, x14, 0x0000001500000015, \
    li x14, 0x0000000500000005; \
    li a1, 0x0202020202020202; \
    li a2, 0x0202020202020202; \
    pm4adda.b x14, a1, a2 );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END

