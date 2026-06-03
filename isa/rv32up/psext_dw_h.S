# See LICENSE for license details.

#*****************************************************************************
# psext_dw_h.S
#-----------------------------------------------------------------------------
#
# Test psext.dw.h instruction (packed sign-extend double-word word from halfword).
# RV32-only instruction using register pairs for 64-bit operations.
# Sign-extends the low 16 bits of each 32-bit element to 32 bits.
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV32U
RVTEST_CODE_BEGIN

  #-------------------------------------------------------------
  # Basic tests - psext.dw.h sign-extends low halfword of each word
  #-------------------------------------------------------------

  # psext.dw.h rd, rs1
  # Sign-extends the low 16 bits of each 32-bit element to 32 bits

  # Test case 1: Positive halfword values (no sign extension needed)
  # rs1 = 0x0000000500000005 (5 in low halfword of each word)
  # Expected: 0x0000000500000005 (5 sign-extended)
  # Using even registers for register-pair constraint (rd, rs1 must be even)
  TEST_CASE( 2, x14, 0x00000005, \
    li x10, 0x00000005; \
    li x11, 0x00000005; \
    psext.dw.h x14, x10 );
  TEST_CASE( 3, x15, 0x00000005, nop );

  # Test case 2: Negative halfword values (0x8000 = -32768, sign extends to 0xFFFF8000)
  # rs1 = 0x0000800000008000 (0x8000 in low halfword)
  # Expected: 0xffff8000ffff8000 (-32768 sign-extended to word)
  TEST_CASE( 4, x14, 0xffff8000, \
    li x10, 0x00008000; \
    li x11, 0x00008000; \
    psext.dw.h x14, x10 );
  TEST_CASE( 5, x15, 0xffff8000, nop );

  # Test case 3: 0xFFFF in low halfword (-1) sign extends to 0xFFFFFFFF
  # rs1 = 0x0000ffff0000ffff
  # Expected: 0xffffffffffffffff
  TEST_CASE( 6, x14, 0xffffffff, \
    li x10, 0x0000ffff; \
    li x11, 0x0000ffff; \
    psext.dw.h x14, x10 );
  TEST_CASE( 7, x15, 0xffffffff, nop );

  # Test case 4: Zero remains zero
  TEST_CASE( 8, x14, 0x00000000, \
    li x10, 0x00000000; \
    li x11, 0x00000000; \
    psext.dw.h x14, x10 );
  TEST_CASE( 9, x15, 0x00000000, nop );

  # Test case 5: High halfword is ignored, only low halfword matters
  # rs1 = 0xffff0005ffff0005 (high halfword 0xFFFF, low halfword 0x0005)
  # Expected: 0x0000000500000005 (only low halfword 0x0005 is sign-extended)
  TEST_CASE( 10, x14, 0x00000005, \
    li x10, 0xffff0005; \
    li x11, 0xffff0005; \
    psext.dw.h x14, x10 );
  TEST_CASE( 11, x15, 0x00000005, nop );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END

