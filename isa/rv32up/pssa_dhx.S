# See LICENSE for license details.

#*****************************************************************************
# pssa_dhx.S
#-----------------------------------------------------------------------------
#
# Test pssa.dhx instruction (packed saturating cross sub-add halfword, double-word, RV32 only).
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV32U
RVTEST_CODE_BEGIN

  #-------------------------------------------------------------
  # Arithmetic tests
  #-------------------------------------------------------------

  # pssa.dhx rd, rs1, rs2 (per spec PSSA.DHX -> PSSA.HX)
  # Even halfword (low):  sat_s16(s1.lo + s2.hi)
  # Odd  halfword (high): sat_s16(s1.hi - s2.lo)

  # Test case 1: Simple saturating cross sub-add (no saturation)
  # rs1 word = 0x00040008 (hi=0x0004, lo=0x0008)
  # rs2 word = 0x00020004 (hi=0x0002, lo=0x0004)
  # Even = sat(0x0008 + 0x0002) = 0x000a
  # Odd  = sat(0x0004 - 0x0004) = 0x0000
  # Word = 0x0000000a
  TEST_CASE( 2, x14, 0x0000000a, \
      TEST_VXSAT_CLEAR; \
    li x10, 0x00040008; \
    li x11, 0x00040008; \
    li x12, 0x00020004; \
    li x13, 0x00020004; \
    pssa.dhx x14, x10, x12 );
  TEST_VXSAT_CHECK( 0 );
  TEST_CASE( 3, x15, 0x0000000a, nop );

  # Test case 2: Zero - Zero = Zero
  TEST_CASE( 4, x14, 0x00000000, \
      TEST_VXSAT_CLEAR; \
    li x10, 0x00000000; \
    li x11, 0x00000000; \
    li x12, 0x00000000; \
    li x13, 0x00000000; \
    pssa.dhx x14, x10, x12 );
  TEST_VXSAT_CHECK( 0 );
  TEST_CASE( 5, x15, 0x00000000, nop );

  # Test case 3: Positive saturation on the even halfword (add)
  # rs1 word = 0x7fff7fff (hi=lo=0x7fff)
  # rs2 word = 0x7fff0001 (hi=0x7fff, lo=0x0001)
  # Even = sat(0x7fff + 0x7fff) = sat(0xfffe) -> 0x7fff
  # Odd  = sat(0x7fff - 0x0001) = 0x7ffe
  # Word = 0x7ffe7fff
  TEST_CASE( 6, x14, 0x7ffe7fff, \
      TEST_VXSAT_CLEAR; \
    li x10, 0x7fff7fff; \
    li x11, 0x7fff7fff; \
    li x12, 0x7fff0001; \
    li x13, 0x7fff0001; \
    pssa.dhx x14, x10, x12 );
  TEST_VXSAT_CHECK( 1 );
  TEST_CASE( 7, x15, 0x7ffe7fff, nop );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END

