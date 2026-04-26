# See LICENSE for license details.

#*****************************************************************************
# pmulhu_h.S
#-----------------------------------------------------------------------------
#
# Test pmulhu.h instruction (packed unsigned high multiply, 16-bit).
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV64U
RVTEST_CODE_BEGIN

  #-------------------------------------------------------------
  # Arithmetic tests
  #-------------------------------------------------------------

  # pmulhu.h rd, rs1, rs2 = packed (zext(rs1) * zext(rs2)) >> 16

  # Test case 1: High result of multiply
  TEST_RR_OP( 2, pmulhu.h, 0x0000000000000000, 0x0002000200020002, 0x0003000300030003 );

  # Test case 2: Zero multiply
  TEST_RR_OP( 3, pmulhu.h, 0x0000000000000000, 0x0000000000000000, 0x0005000500050005 );

  # Test case 3: Large unsigned values
  TEST_RR_OP( 4, pmulhu.h, 0xfffe0000fffe0000, 0xffffffff00000000, 0xffffffff00000000 );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END

