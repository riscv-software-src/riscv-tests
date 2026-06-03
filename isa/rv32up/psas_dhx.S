# See LICENSE for license details.

#*****************************************************************************
# psas_dhx.S
#-----------------------------------------------------------------------------
#
# Test psas.dhx instruction (packed saturating cross add-sub halfword, double-word, RV32 only).
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV32U
RVTEST_CODE_BEGIN

  #-------------------------------------------------------------
  # Arithmetic tests
  #-------------------------------------------------------------

  # psas.dhx rd, rs1, rs2 (per spec PSAS.DHX -> PSAS.HX)
  # Even halfword (low):  sat_s16(s1.lo - s2.hi)
  # Odd  halfword (high): sat_s16(s1.hi + s2.lo)

  # Test case 1: Simple saturating cross add-sub (no saturation)
  # rs1 word = 0x00040008 (hi=0x0004, lo=0x0008)
  # rs2 word = 0x00020004 (hi=0x0002, lo=0x0004)
  # Even = sat(0x0008 - 0x0002) = 0x0006
  # Odd  = sat(0x0004 + 0x0004) = 0x0008
  # Word = 0x00080006
  TEST_CASE( 2, x14, 0x00080006, \
      TEST_VXSAT_CLEAR; \
    li x10, 0x00040008; \
    li x11, 0x00040008; \
    li x12, 0x00020004; \
    li x13, 0x00020004; \
    psas.dhx x14, x10, x12 );
  TEST_VXSAT_CHECK( 0 );
  TEST_CASE( 3, x15, 0x00080006, nop );

  # Test case 2: Zero + Zero = Zero
  TEST_CASE( 4, x14, 0x00000000, \
      TEST_VXSAT_CLEAR; \
    li x10, 0x00000000; \
    li x11, 0x00000000; \
    li x12, 0x00000000; \
    li x13, 0x00000000; \
    psas.dhx x14, x10, x12 );
  TEST_VXSAT_CHECK( 0 );
  TEST_CASE( 5, x15, 0x00000000, nop );

  # Test case 3: Positive saturation on the odd halfword
  # rs1 word = 0x7fff7fff (hi=lo=0x7fff)
  # rs2 word = 0x00010001 (hi=lo=0x0001)
  # Even = sat(0x7fff - 0x0001) = 0x7ffe
  # Odd  = sat(0x7fff + 0x0001) = sat(0x8000) -> 0x7fff
  # Word = 0x7fff7ffe
  TEST_CASE( 6, x14, 0x7fff7ffe, \
      TEST_VXSAT_CLEAR; \
    li x10, 0x7fff7fff; \
    li x11, 0x7fff7fff; \
    li x12, 0x00010001; \
    li x13, 0x00010001; \
    psas.dhx x14, x10, x12 );
  TEST_VXSAT_CHECK( 1 );
  TEST_CASE( 7, x15, 0x7fff7ffe, nop );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END

