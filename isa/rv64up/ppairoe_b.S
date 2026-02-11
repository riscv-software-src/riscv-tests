# See LICENSE for license details.

#*****************************************************************************
# ppairoe_b.S
#-----------------------------------------------------------------------------
#
# Test ppairoe.b instruction (packed pair odd-even byte).
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV64U
RVTEST_CODE_BEGIN

  #-------------------------------------------------------------
  # Arithmetic tests
  #-------------------------------------------------------------

  # ppairoe.b rd, rs1, rs2
  # Selects odd bytes from rs1 and even bytes from rs2 and packs them
  # rd[i*2] = rs1[i*2+1], rd[i*2+1] = rs2[i*2] for each pair

  # Test case 1: Distinct byte pattern
  # rs1 = 0x0706050403020100, rs2 = 0x0f0e0d0c0b0a0908
  # Odd bytes rs1: 01, 03, 05, 07; Even bytes rs2: 08, 0a, 0c, 0e
  # Expected: 0x0e070c050a030801
  TEST_RR_OP( 2, ppairoe.b, 0x0e070c050a030801, 0x0706050403020100, 0x0f0e0d0c0b0a0908 );

  # Test case 2: Zero values
  TEST_RR_OP( 3, ppairoe.b, 0x0000000000000000, 0x0000000000000000, 0x0000000000000000 );

  # Test case 3: All ones
  TEST_RR_OP( 4, ppairoe.b, 0xffffffffffffffff, 0xffffffffffffffff, 0xffffffffffffffff );

  # Test case 4: Alternating pattern
  TEST_RR_OP( 5, ppairoe.b, 0x00ff00ff00ff00ff, 0x00ff00ff00ff00ff, 0xff00ff00ff00ff00 );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END

