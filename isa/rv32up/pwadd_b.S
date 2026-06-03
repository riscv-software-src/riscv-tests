# See LICENSE for license details.

#*****************************************************************************
# pwadd_b.S
#-----------------------------------------------------------------------------
#
# Test pwadd.b instruction (packed widening byte add, RV32 only).
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV32U
RVTEST_CODE_BEGIN

  #-------------------------------------------------------------
  # Arithmetic tests
  #-------------------------------------------------------------

  # pwadd.b rd, rs1, rs2
  # Packed widening add: 8-bit to 16-bit, signed
  # rd_pair[i] = sign_ext(rs1[i]) + sign_ext(rs2[i])

  # Test case 1: Simple widening add
  # 0x01 + 0x02 = 0x0003 (for each byte pair)
  TEST_CASE( 2, x14, 0x00030003, \
    li x10, 0x01010101; \
    li x12, 0x02020202; \
    pwadd.b x14, x10, x12 );
  TEST_CASE( 3, x15, 0x00030003, nop );

  # Test case 2: Zero + Zero
  TEST_CASE( 4, x14, 0x00000000, \
    li x10, 0x00000000; \
    li x12, 0x00000000; \
    pwadd.b x14, x10, x12 );
  TEST_CASE( 5, x15, 0x00000000, nop );

  # Test case 3: Negative value addition (signed)
  # 0xFF (-1) + 0x01 = 0x0000
  TEST_CASE( 6, x14, 0x00000000, \
    li x10, 0xFFFFFFFF; \
    li x12, 0x01010101; \
    pwadd.b x14, x10, x12 );
  TEST_CASE( 7, x15, 0x00000000, nop );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END

