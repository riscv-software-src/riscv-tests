# See LICENSE for license details.

#*****************************************************************************
# psas_dhx.S
#-----------------------------------------------------------------------------
#
# Test psas.dhx instruction (packed saturating cross add-sub halfword, double-word, RV32 only).
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV32U
RVTEST_CODE_BEGIN

  #-------------------------------------------------------------
  # Arithmetic tests
  #-------------------------------------------------------------

  # psas.dhx rd, rs1, rs2
  # Performs packed saturating cross add-sub on halfwords (64-bit register pair):
  # rd.H[even] = sat(rs1.H[even] + rs2.H[odd])
  # rd.H[odd]  = sat(rs1.H[odd] - rs2.H[even])

  # Test case 1: Simple saturating cross add-sub (no saturation)
  # rs1 = {0x00040008, 0x00040008}, rs2 = {0x00020004, 0x00020004}
  # H[0]: sat(0x0008 + 0x0004) = 0x000c, H[1]: sat(0x0004 - 0x0008) = 0xfffc
  # H[2]: sat(0x0008 + 0x0004) = 0x000c, H[3]: sat(0x0004 - 0x0008) = 0xfffc
  TEST_CASE( 2, x14, 0xfffc000c, \
    li x10, 0x00040008; \
    li x11, 0x00040008; \
    li x12, 0x00020004; \
    li x13, 0x00020004; \
    psas.dhx x14, x10, x12 );
  TEST_CASE( 3, x15, 0xfffc000c, nop );

  # Test case 2: Zero + Zero = Zero
  TEST_CASE( 4, x14, 0x00000000, \
    li x10, 0x00000000; \
    li x11, 0x00000000; \
    li x12, 0x00000000; \
    li x13, 0x00000000; \
    psas.dhx x14, x10, x12 );
  TEST_CASE( 5, x15, 0x00000000, nop );

  # Test case 3: Positive saturation
  # rs1 = {0x7fff7fff, 0x7fff7fff}, rs2 = {0x00010001, 0x00010001}
  # H[0]: sat(0x7fff + 0x0001) = 0x7fff (saturated), H[1]: sat(0x7fff - 0x7fff) = 0x0000
  TEST_CASE( 6, x14, 0x00007fff, \
    li x10, 0x7fff7fff; \
    li x11, 0x7fff7fff; \
    li x12, 0x00010001; \
    li x13, 0x00010001; \
    psas.dhx x14, x10, x12 );
  TEST_CASE( 7, x15, 0x00007fff, nop );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END

