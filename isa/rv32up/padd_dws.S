# See LICENSE for license details.

#*****************************************************************************
# padd_dws.S
#-----------------------------------------------------------------------------
#
# Test padd.dws instruction (packed word add with scalar, double-word, RV32 only).
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV32U
RVTEST_CODE_BEGIN

  #-------------------------------------------------------------
  # Arithmetic tests
  #-------------------------------------------------------------

  # padd.dws rd, rs1, rs2
  # Packed word addition with scalar broadcast on 64-bit register pairs

  # Test case 1: Simple word addition with scalar
  TEST_CASE( 2, x14, 0x00000003, \
    li x10, 0x00000001; \
    li x11, 0x00000004; \
    li x12, 0x00000002; \
    padd.dws x14, x10, x12 );
  TEST_CASE( 3, x15, 0x00000006, nop );

  # Test case 2: Zero scalar
  TEST_CASE( 4, x14, 0x00000001, \
    li x10, 0x00000001; \
    li x11, 0x00000004; \
    li x12, 0x00000000; \
    padd.dws x14, x10, x12 );
  TEST_CASE( 5, x15, 0x00000004, nop );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END

