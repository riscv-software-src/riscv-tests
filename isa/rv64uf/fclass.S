# See LICENSE for license details.

#*****************************************************************************
# fclass.S
#-----------------------------------------------------------------------------
#
# Test fclass.s instructions.
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV64UF
RVTEST_CODE_BEGIN

  #-------------------------------------------------------------
  # Arithmetic tests
  #-------------------------------------------------------------

  TEST_FCLASS_S( 2, 1 << 0, nInff )
  TEST_FCLASS_S( 3, 1 << 1, 0xbf800000 )
  TEST_FCLASS_S( 4, 1 << 2, 0x807fffff )
  TEST_FCLASS_S( 5, 1 << 3, 0x80000000 )
  TEST_FCLASS_S( 6, 1 << 4, 0x00000000 )
  TEST_FCLASS_S( 7, 1 << 5, 0x007fffff )
  TEST_FCLASS_S( 8, 1 << 6, 0x3f800000 )
  TEST_FCLASS_S( 9, 1 << 7, Inff )
  TEST_FCLASS_S(10, 1 << 8, sNaNf )
  TEST_FCLASS_S(11, 1 << 9, qNaNf )

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END
