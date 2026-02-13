# See LICENSE for license details.

#*****************************************************************************
# paaddu_w.S
#-----------------------------------------------------------------------------
#
# Test paaddu.w instruction (packed word averaging add, unsigned, RV64 only).
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV64U
RVTEST_CODE_BEGIN

  #-------------------------------------------------------------
  # Arithmetic tests
  #-------------------------------------------------------------

  # paaddu.w rd, rs1, rs2
  # Performs packed unsigned averaging add: rd[i] = (rs1[i] + rs2[i]) >> 1
  # Two 32-bit words in a 64-bit register

  # Test case 1: Simple averaging (4 + 2) / 2 = 3
  TEST_RR_OP( 2, paaddu.w, 0x0000000300000003, 0x0000000400000004, 0x0000000200000002 );

  # Test case 2: Zero + Zero = Zero
  TEST_RR_OP( 3, paaddu.w, 0x0000000000000000, 0x0000000000000000, 0x0000000000000000 );

  # Test case 3: Large unsigned values (0xFFFFFFFF + 0x00000001) / 2 = 0x80000000
  TEST_RR_OP( 4, paaddu.w, 0x8000000080000000, 0xffffffffffffffff, 0x0000000100000001 );

  # Test case 4: (0x80000000 + 0x80000000) / 2 = 0x80000000
  TEST_RR_OP( 5, paaddu.w, 0x8000000080000000, 0x8000000080000000, 0x8000000080000000 );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END

