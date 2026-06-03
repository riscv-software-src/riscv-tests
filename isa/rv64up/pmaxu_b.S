# See LICENSE for license details.

#*****************************************************************************
# pmaxu_b.S
#-----------------------------------------------------------------------------
#
# Test pmaxu.b instruction (packed max byte unsigned).
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV64U
RVTEST_CODE_BEGIN

  #-------------------------------------------------------------
  # Arithmetic tests
  #-------------------------------------------------------------

  # pmaxu.b rd, rs1, rs2
  # Performs packed unsigned max: rd[i] = max(rs1[i], rs2[i]) for each byte

  # Test case 1: Simple max (5 vs 3 = 5)
  TEST_RR_OP( 2, pmaxu.b, 0x0505050505050505, 0x0505050505050505, 0x0303030303030303 );

  # Test case 2: Reverse order (3 vs 5 = 5)
  TEST_RR_OP( 3, pmaxu.b, 0x0505050505050505, 0x0303030303030303, 0x0505050505050505 );

  # Test case 3: Equal values
  TEST_RR_OP( 4, pmaxu.b, 0x0404040404040404, 0x0404040404040404, 0x0404040404040404 );

  # Test case 4: Unsigned comparison (0xff vs 0x01 = 0xff since 255 > 1)
  TEST_RR_OP( 5, pmaxu.b, 0xffffffffffffffff, 0xffffffffffffffff, 0x0101010101010101 );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END


