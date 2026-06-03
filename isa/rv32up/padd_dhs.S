# See LICENSE for license details.

#*****************************************************************************
# padd_dhs.S
#-----------------------------------------------------------------------------
#
# Test padd.dhs instruction (packed halfword add with scalar, double-word, RV32 only).
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV32U
RVTEST_CODE_BEGIN

  #-------------------------------------------------------------
  # Arithmetic tests
  #-------------------------------------------------------------

  # padd.dhs rd, rs1, rs2
  # Packed halfword addition with scalar broadcast on 64-bit register pairs

  # Test case 1: Simple halfword addition with scalar
  TEST_CASE( 2, x14, 0x00020003, \
    li x10, 0x00010002; \
    li x11, 0x00030004; \
    li x12, 0x0001; \
    padd.dhs x14, x10, x12 );
  TEST_CASE( 3, x15, 0x00040005, nop );

  # Test case 2: Zero scalar
  TEST_CASE( 4, x14, 0x00010002, \
    li x10, 0x00010002; \
    li x11, 0x00030004; \
    li x12, 0x0000; \
    padd.dhs x14, x10, x12 );
  TEST_CASE( 5, x15, 0x00030004, nop );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END

