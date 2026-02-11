# See LICENSE for license details.

#*****************************************************************************
# pas_dhx.S
#-----------------------------------------------------------------------------
#
# Test pas.dhx instruction (packed cross add-sub halfword, double-word, RV32 only).
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV32U
RVTEST_CODE_BEGIN

  #-------------------------------------------------------------
  # Arithmetic tests
  #-------------------------------------------------------------

  # pas.dhx rd, rs1, rs2
  # Performs packed cross add-sub on halfwords (64-bit register pair):
  # rd.H[even] = rs1.H[even] + rs2.H[odd]
  # rd.H[odd]  = rs1.H[odd] - rs2.H[even]

  # Test case 1: Simple cross add-sub
  # rs1 = {0x00040008, 0x00040008}, rs2 = {0x00020004, 0x00020004}
  # H[0]: 0x0008 + 0x0004 = 0x000c, H[1]: 0x0004 - 0x0008 = 0xfffc
  # H[2]: 0x0008 + 0x0004 = 0x000c, H[3]: 0x0004 - 0x0008 = 0xfffc
  TEST_CASE( 2, x14, 0xfffc000c, \
    li x10, 0x00040008; \
    li x11, 0x00040008; \
    li x12, 0x00020004; \
    li x13, 0x00020004; \
    pas.dhx x14, x10, x12 );
  TEST_CASE( 3, x15, 0xfffc000c, nop );

  # Test case 2: Zero + Zero = Zero
  TEST_CASE( 4, x14, 0x00000000, \
    li x10, 0x00000000; \
    li x11, 0x00000000; \
    li x12, 0x00000000; \
    li x13, 0x00000000; \
    pas.dhx x14, x10, x12 );
  TEST_CASE( 5, x15, 0x00000000, nop );

  # Test case 3: Same values in rs1 and rs2
  # rs1 = {0x00040004, 0x00040004}, rs2 = {0x00020002, 0x00020002}
  # H[0]: 0x0004 + 0x0002 = 0x0006, H[1]: 0x0004 - 0x0004 = 0x0000
  TEST_CASE( 6, x14, 0x00000006, \
    li x10, 0x00040004; \
    li x11, 0x00040004; \
    li x12, 0x00020002; \
    li x13, 0x00020002; \
    pas.dhx x14, x10, x12 );
  TEST_CASE( 7, x15, 0x00000006, nop );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END

