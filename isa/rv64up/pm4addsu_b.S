# See LICENSE for license details.

#*****************************************************************************
# pm4addsu_b.S
#-----------------------------------------------------------------------------
#
# Test pm4addsu.b instruction.
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV64U
RVTEST_CODE_BEGIN

  #-------------------------------------------------------------
  # Arithmetic tests
  #-------------------------------------------------------------

  # pm4addsu.b: packed multiply 4-way add (signed*unsigned) for bytes (NON-accumulating)
  # rd = sum_{i=0..3}(signed(rs1.b_i) * unsigned(rs2.b_i)) for each 32-bit lane

  # Test: 04*05 + 03*04 + 02*03 + 01*02 = 0x14+0x0C+0x06+0x02 = 0x00000028
  TEST_CASE( 2, x14, 0x0000002800000028, \
    li x14, 0x0000001000000010; \
    li a1, 0x0102030401020304; \
    li a2, 0x0203040502030405; \
    pm4addsu.b x14, a1, a2 );

  # Test: 1+1+1+1 = 0x00000004
  TEST_CASE( 3, x14, 0x0000000400000004, \
    li x14, 0x0000000000000000; \
    li a1, 0x0101010101010101; \
    li a2, 0x0101010101010101; \
    pm4addsu.b x14, a1, a2 );

  # Test: 4+4+4+4 = 0x00000010
  TEST_CASE( 4, x14, 0x0000001000000010, \
    li x14, 0x0000000500000005; \
    li a1, 0x0202020202020202; \
    li a2, 0x0202020202020202; \
    pm4addsu.b x14, a1, a2 );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END
