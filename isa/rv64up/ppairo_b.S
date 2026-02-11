# See LICENSE for license details.

#*****************************************************************************
# ppairo_b.S
#-----------------------------------------------------------------------------
#
# Test ppairo.b instruction (packed pair odd byte).
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV64U
RVTEST_CODE_BEGIN

  #-------------------------------------------------------------
  # Arithmetic tests
  #-------------------------------------------------------------

  # ppairo.b rd, rs1, rs2
  # Selects odd bytes from rs1 and rs2 and packs them
  # rd[i*2] = rs1[i*2+1], rd[i*2+1] = rs2[i*2+1] for each pair

  # Test case 1: Distinct byte pattern
  # rs1 = 0x0706050403020100, rs2 = 0x0f0e0d0c0b0a0908
  # Odd bytes rs1: 01, 03, 05, 07; Odd bytes rs2: 09, 0b, 0d, 0f
  # Expected: 0x0f070d050b030901
  TEST_RR_OP( 2, ppairo.b, 0x0f070d050b030901, 0x0706050403020100, 0x0f0e0d0c0b0a0908 );

  # Test case 2: Zero values
  TEST_RR_OP( 3, ppairo.b, 0x0000000000000000, 0x0000000000000000, 0x0000000000000000 );

  # Test case 3: All ones
  TEST_RR_OP( 4, ppairo.b, 0xffffffffffffffff, 0xffffffffffffffff, 0xffffffffffffffff );

  # Test case 4: Alternating pattern
  TEST_RR_OP( 5, ppairo.b, 0xffffffffffffff00, 0x00ff00ff00ff00ff, 0xffffffffffffff00 );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END

