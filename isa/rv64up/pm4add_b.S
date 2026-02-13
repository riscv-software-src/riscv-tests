# See LICENSE for license details.

#*****************************************************************************
# pm4add_b.S
#-----------------------------------------------------------------------------
#
# Test pm4add.b instruction.
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV64U
RVTEST_CODE_BEGIN

  #-------------------------------------------------------------
  # Arithmetic tests
  #-------------------------------------------------------------

  # pm4add.b: packed multiply 4-way add for bytes (NON-accumulating)
  # rd = b0*c0 + b1*c1 + b2*c2 + b3*c3 for each 32-bit lane (4 bytes per lane)

  # Test: bytes 04*05 + 03*04 + 02*03 + 01*02 = 0x14+0x0C+0x06+0x02 = 0x00000028
  TEST_CASE( 2, x14, 0x0000002800000028, \
    li x14, 0x0000001000000010; \
    li a1, 0x0102030401020304; \
    li a2, 0x0203040502030405; \
    pm4add.b x14, a1, a2 );

  # Test: 1+1+1+1 = 0x00000004
  TEST_CASE( 3, x14, 0x0000000400000004, \
    li x14, 0x0000000000000000; \
    li a1, 0x0101010101010101; \
    li a2, 0x0101010101010101; \
    pm4add.b x14, a1, a2 );

  # Test: 4+4+4+4 = 0x00000010
  TEST_CASE( 4, x14, 0x0000001000000010, \
    li x14, 0x0000000500000005; \
    li a1, 0x0202020202020202; \
    li a2, 0x0202020202020202; \
    pm4add.b x14, a1, a2 );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END
