# See LICENSE for license details.

#*****************************************************************************
# msltu.S
#-----------------------------------------------------------------------------
#
# Test msltu instruction (set if less than unsigned, RV32 only).
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV32U
RVTEST_CODE_BEGIN

  #-------------------------------------------------------------
  # Arithmetic tests
  #-------------------------------------------------------------

  # msltu rd, rs1, rs2
  # rd = (rs1 < rs2, unsigned) ? all 1s : 0

  # Test case 1: rs1 < rs2 - return all 1s (3 < 5)
  TEST_RR_OP( 2, msltu, 0xffffffff, 0x00000003, 0x00000005 );

  # Test case 2: rs1 > rs2 - return 0 (5 > 3)
  TEST_RR_OP( 3, msltu, 0x00000000, 0x00000005, 0x00000003 );

  # Test case 3: rs1 == rs2 - return 0
  TEST_RR_OP( 4, msltu, 0x00000000, 0x00000005, 0x00000005 );

  # Test case 4: Unsigned comparison (1 < 0xffffffff = true, since 1 < 4294967295)
  TEST_RR_OP( 5, msltu, 0xffffffff, 0x00000001, 0xffffffff );

  # Test case 5: Unsigned comparison (0xffffffff < 1 = false)
  TEST_RR_OP( 6, msltu, 0x00000000, 0xffffffff, 0x00000001 );

  # Test case 6: Zero comparison (0 < 1 = true)
  TEST_RR_OP( 7, msltu, 0xffffffff, 0x00000000, 0x00000001 );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END


