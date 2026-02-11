# See LICENSE for license details.

#*****************************************************************************
# psra_bs.S
#-----------------------------------------------------------------------------
#
# Test psra.bs instruction (packed shift right arithmetic byte).
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV64U
RVTEST_CODE_BEGIN

  #-------------------------------------------------------------
  # Arithmetic tests
  #-------------------------------------------------------------

  # psra.bs rd, rs1, rs2
  # Performs packed byte shift right arithmetic by rs2

  # Test case 1: Simple shift right by 1 (positive values)
  TEST_RR_OP( 2, psra.bs, 0x0001010202030304, 0x0002030405060708, 0x0101010101010101 );

  # Test case 2: Shift by 0 (no change)
  TEST_RR_OP( 3, psra.bs, 0x8080808080808080, 0x8080808080808080, 0x0000000000000000 );

  # Test case 3: Shift right with sign extension (0x80 >> 1 = 0xC0)
  TEST_RR_OP( 4, psra.bs, 0xc0c0c0c0c0c0c0c0, 0x8080808080808080, 0x0101010101010101 );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END


