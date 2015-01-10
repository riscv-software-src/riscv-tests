# See LICENSE for license details.

#*****************************************************************************
# fclass.S
#-----------------------------------------------------------------------------
#
# Test fclass.{s|d} instructions.
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV64UF
RVTEST_CODE_BEGIN

  #-------------------------------------------------------------
  # Arithmetic tests
  #-------------------------------------------------------------

  #define TEST_FCLASS_S(testnum, correct, input) \
    TEST_CASE(testnum, a0, correct, li a0, input; fmv.s.x fa0, a0; \
                                    fclass.s a0, fa0)

  TEST_FCLASS_S( 2, 1 << 0, 0xff800000 )
  TEST_FCLASS_S( 3, 1 << 1, 0xbf800000 )
  TEST_FCLASS_S( 4, 1 << 2, 0x807fffff )
  TEST_FCLASS_S( 5, 1 << 3, 0x80000000 )
  TEST_FCLASS_S( 6, 1 << 4, 0x00000000 )
  TEST_FCLASS_S( 7, 1 << 5, 0x007fffff )
  TEST_FCLASS_S( 8, 1 << 6, 0x3f800000 )
  TEST_FCLASS_S( 9, 1 << 7, 0x7f800000 )
  TEST_FCLASS_S(10, 1 << 8, 0x7f800001 )
  TEST_FCLASS_S(11, 1 << 9, 0x7fc00000 )

  #define TEST_FCLASS_D(testnum, correct, input) \
    TEST_CASE(testnum, a0, correct, li a0, input; fmv.d.x fa0, a0; \
                                    fclass.d a0, fa0)

  TEST_FCLASS_D(12, 1 << 0, 0xfff0000000000000 )
  TEST_FCLASS_D(13, 1 << 1, 0xbff0000000000000 )
  TEST_FCLASS_D(14, 1 << 2, 0x800fffffffffffff )
  TEST_FCLASS_D(15, 1 << 3, 0x8000000000000000 )
  TEST_FCLASS_D(16, 1 << 4, 0x0000000000000000 )
  TEST_FCLASS_D(17, 1 << 5, 0x000fffffffffffff )
  TEST_FCLASS_D(18, 1 << 6, 0x3ff0000000000000 )
  TEST_FCLASS_D(19, 1 << 7, 0x7ff0000000000000 )
  TEST_FCLASS_D(20, 1 << 8, 0x7ff0000000000001 )
  TEST_FCLASS_D(21, 1 << 9, 0x7ff8000000000000 )

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END
