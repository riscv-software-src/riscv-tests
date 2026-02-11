# See LICENSE for license details.

#*****************************************************************************
# mslt.S
#-----------------------------------------------------------------------------
#
# Test mslt instruction (set if less than signed, RV32 only).
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV32U
RVTEST_CODE_BEGIN

  #-------------------------------------------------------------
  # Arithmetic tests
  #-------------------------------------------------------------

  # mslt rd, rs1, rs2
  # rd = (rs1 < rs2, signed) ? all 1s : 0

  # Test case 1: rs1 < rs2 - return all 1s (3 < 5)
  TEST_RR_OP( 2, mslt, 0xffffffff, 0x00000003, 0x00000005 );

  # Test case 2: rs1 > rs2 - return 0 (5 > 3)
  TEST_RR_OP( 3, mslt, 0x00000000, 0x00000005, 0x00000003 );

  # Test case 3: rs1 == rs2 - return 0
  TEST_RR_OP( 4, mslt, 0x00000000, 0x00000005, 0x00000005 );

  # Test case 4: Signed comparison (-1 < 1 = true)
  TEST_RR_OP( 5, mslt, 0xffffffff, 0xffffffff, 0x00000001 );

  # Test case 5: Signed comparison (1 < -1 = false)
  TEST_RR_OP( 6, mslt, 0x00000000, 0x00000001, 0xffffffff );

  # Test case 6: Large negative < small negative (-128 < -1 = true)
  TEST_RR_OP( 7, mslt, 0xffffffff, 0xffffff80, 0xffffffff );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END


