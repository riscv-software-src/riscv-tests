# See LICENSE for license details.

#*****************************************************************************
# ppaire_b.S
#-----------------------------------------------------------------------------
#
# Test ppaire.b instruction (packed pair even byte).
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV64U
RVTEST_CODE_BEGIN

  #-------------------------------------------------------------
  # Arithmetic tests
  #-------------------------------------------------------------

  # ppaire.b rd, rs1, rs2
  # Selects even bytes from rs1 and rs2 and packs them
  # rd[i*2] = rs1[i*2], rd[i*2+1] = rs2[i*2] for each pair

  # Test case 1: Distinct byte pattern
  # rs1 = 0x0706050403020100, rs2 = 0x0f0e0d0c0b0a0908
  # Even bytes rs1: 00, 02, 04, 06; Even bytes rs2: 08, 0a, 0c, 0e
  # Expected: 0x0e060c040a020800
  TEST_RR_OP( 2, ppaire.b, 0x0e060c040a020800, 0x0706050403020100, 0x0f0e0d0c0b0a0908 );

  # Test case 2: Zero values
  TEST_RR_OP( 3, ppaire.b, 0x0000000000000000, 0x0000000000000000, 0x0000000000000000 );

  # Test case 3: All ones
  TEST_RR_OP( 4, ppaire.b, 0xffffffffffffffff, 0xffffffffffffffff, 0xffffffffffffffff );

  # Test case 4: Alternating pattern
  TEST_RR_OP( 5, ppaire.b, 0xaa00aa00aa00aa00, 0xff00ff00ff00ff00, 0xffaaffaaffaaffaa );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END

