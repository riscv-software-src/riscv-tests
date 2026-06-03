# See LICENSE for license details.

#*****************************************************************************
# padd_dh.S
#-----------------------------------------------------------------------------
#
# Test padd.dh instruction (packed halfword add, double-word, RV32 only).
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV32U
RVTEST_CODE_BEGIN

  #-------------------------------------------------------------
  # Arithmetic tests
  #-------------------------------------------------------------

  # padd.dh rd, rs1, rs2
  # Packed halfword addition on 64-bit register pairs

  # Test case 1: Simple halfword addition
  # Low:  0x00010002 + 0x00010001 = 0x00020003
  # High: 0x00030004 + 0x00010001 = 0x00040005
  TEST_CASE( 2, x14, 0x00020003, \
    li x10, 0x00010002; \
    li x11, 0x00030004; \
    li x12, 0x00010001; \
    li x13, 0x00010001; \
    padd.dh x14, x10, x12 );
  TEST_CASE( 3, x15, 0x00040005, nop );

  # Test case 2: Zero + Zero
  TEST_CASE( 4, x14, 0x00000000, \
    li x10, 0x00000000; \
    li x11, 0x00000000; \
    li x12, 0x00000000; \
    li x13, 0x00000000; \
    padd.dh x14, x10, x12 );
  TEST_CASE( 5, x15, 0x00000000, nop );

  # Test case 3: Halfword overflow (wraps)
  TEST_CASE( 6, x14, 0x00000000, \
    li x10, 0xFFFFFFFF; \
    li x11, 0xFFFFFFFF; \
    li x12, 0x00010001; \
    li x13, 0x00010001; \
    padd.dh x14, x10, x12 );
  TEST_CASE( 7, x15, 0x00000000, nop );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END

