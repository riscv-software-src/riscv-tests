# See LICENSE for license details.

#*****************************************************************************
# psrai_b.S
#-----------------------------------------------------------------------------
#
# Test psrai.b instruction (packed shift right arithmetic immediate byte).
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV64U
RVTEST_CODE_BEGIN

  #-------------------------------------------------------------
  # Arithmetic tests
  #-------------------------------------------------------------

  # psrai.b rd, rs1, imm
  # Performs packed byte shift right arithmetic by immediate

  # Test case 1: Shift right by 1 (positive values)
  TEST_CASE( 2, x14, 0x0001010202030304, li a1, 0x0002030405060708; psrai.b x14, a1, 1 );

  # Test case 2: Shift right by 0 (no change)
  TEST_CASE( 3, x14, 0x8080808080808080, li a1, 0x8080808080808080; psrai.b x14, a1, 0 );

  # Test case 3: Shift right with sign extension (0x80 >> 1 = 0xC0)
  TEST_CASE( 4, x14, 0xc0c0c0c0c0c0c0c0, li a1, 0x8080808080808080; psrai.b x14, a1, 1 );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END


