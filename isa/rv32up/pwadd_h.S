# See LICENSE for license details.

#*****************************************************************************
# pwadd_h.S
#-----------------------------------------------------------------------------
#
# Test pwadd.h instruction (packed widening halfword add, RV32 only).
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV32U
RVTEST_CODE_BEGIN

  #-------------------------------------------------------------
  # Arithmetic tests
  #-------------------------------------------------------------

  # pwadd.h rd, rs1, rs2
  # Packed widening add: 16-bit to 32-bit, signed
  # rd_pair[i] = sign_ext(rs1[i]) + sign_ext(rs2[i])

  # Test case 1: Simple widening add
  # 0x0001 + 0x0002 = 0x00000003 (for each halfword pair)
  TEST_CASE( 2, x14, 0x00000003, \
    li x10, 0x00010001; \
    li x12, 0x00020002; \
    pwadd.h x14, x10, x12 );
  TEST_CASE( 3, x15, 0x00000003, nop );

  # Test case 2: Zero + Zero
  TEST_CASE( 4, x14, 0x00000000, \
    li x10, 0x00000000; \
    li x12, 0x00000000; \
    pwadd.h x14, x10, x12 );
  TEST_CASE( 5, x15, 0x00000000, nop );

  # Test case 3: Negative value addition (signed)
  # 0xFFFF (-1) + 0x0001 = 0x00000000
  TEST_CASE( 6, x14, 0x00000000, \
    li x10, 0xFFFFFFFF; \
    li x12, 0x00010001; \
    pwadd.h x14, x10, x12 );
  TEST_CASE( 7, x15, 0x00000000, nop );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END

