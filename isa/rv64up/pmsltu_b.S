# See LICENSE for license details.

#*****************************************************************************
# pmsltu_b.S
#-----------------------------------------------------------------------------
#
# Test pmsltu.b instruction (packed mask set less than byte unsigned).
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV64U
RVTEST_CODE_BEGIN

  #-------------------------------------------------------------
  # Arithmetic tests
  #-------------------------------------------------------------

  # pmsltu.b rd, rs1, rs2
  # Sets mask: rd[i] = 0xff if rs1[i] < rs2[i] (unsigned), else 0x00 for each byte

  # Test case 1: rs1 < rs2 - all masks set (3 < 5)
  TEST_RR_OP( 2, pmsltu.b, 0xffffffffffffffff, 0x0303030303030303, 0x0505050505050505 );

  # Test case 2: rs1 > rs2 - no masks set (5 > 3)
  TEST_RR_OP( 3, pmsltu.b, 0x0000000000000000, 0x0505050505050505, 0x0303030303030303 );

  # Test case 3: rs1 == rs2 - no masks set
  TEST_RR_OP( 4, pmsltu.b, 0x0000000000000000, 0x0404040404040404, 0x0404040404040404 );

  # Test case 4: Unsigned comparison (0x01 < 0xff = true, since 1 < 255)
  TEST_RR_OP( 5, pmsltu.b, 0xffffffffffffffff, 0x0101010101010101, 0xffffffffffffffff );

  # Test case 5: Unsigned comparison (0xff < 0x01 = false, since 255 > 1)
  TEST_RR_OP( 6, pmsltu.b, 0x0000000000000000, 0xffffffffffffffff, 0x0101010101010101 );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END


