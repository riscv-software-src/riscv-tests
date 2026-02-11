# See LICENSE for license details.

#*****************************************************************************
# ppaireo_b.S
#-----------------------------------------------------------------------------
#
# Test ppaireo.b instruction (packed pair even-odd byte).
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV64U
RVTEST_CODE_BEGIN

  #-------------------------------------------------------------
  # Arithmetic tests
  #-------------------------------------------------------------

  # ppaireo.b rd, rs1, rs2
  # Selects even bytes from rs1 and odd bytes from rs2 and packs them
  # rd[i*2] = rs1[i*2], rd[i*2+1] = rs2[i*2+1] for each pair

  # Test case 1: Distinct byte pattern
  # rs1 = 0x0706050403020100, rs2 = 0x0f0e0d0c0b0a0908
  # Even bytes rs1: 00, 02, 04, 06; Odd bytes rs2: 09, 0b, 0d, 0f
  # Expected: 0x0f060d040b020900
  TEST_RR_OP( 2, ppaireo.b, 0x0f060d040b020900, 0x0706050403020100, 0x0f0e0d0c0b0a0908 );

  # Test case 2: Zero values
  TEST_RR_OP( 3, ppaireo.b, 0x0000000000000000, 0x0000000000000000, 0x0000000000000000 );

  # Test case 4: All ones
  TEST_RR_OP( 4, ppaireo.b, 0xffffffffffffffff, 0xffffffffffffffff, 0xffffffffffffffff );

  # Test case 4: Alternating pattern
  TEST_RR_OP( 5, ppaireo.b, 0xff00ff00ff00ff00, 0xff00ff00ff00ff00, 0xffaaffaaffaaffaa );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END

