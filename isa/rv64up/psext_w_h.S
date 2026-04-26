# See LICENSE for license details.

#*****************************************************************************
# psext_w_h.S
#-----------------------------------------------------------------------------
#
# Test psext.w.h instruction (packed sign-extend word from halfword, RV64 only).
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV64U
RVTEST_CODE_BEGIN

  #-------------------------------------------------------------
  # Basic tests - psext.w.h sign-extends low halfword of each word
  #-------------------------------------------------------------

  # psext.w.h rd, rs1
  # Sign-extends the low 16 bits of each 32-bit element to 32 bits

  # Test case 1: Positive halfword values (no sign extension needed)
  # rs1 = 0x0000000500000005 (5 in low halfword of each word)
  # Expected: 0x0000000500000005 (5 sign-extended)
  TEST_R_OP( 2, psext.w.h, 0x0000000500000005, 0x0000000500000005 );

  # Test case 2: Negative halfword values (0x8000 = -32768, sign extends to 0xFFFF8000)
  # rs1 = 0x0000800000008000 (0x8000 in low halfword)
  # Expected: 0xffff8000ffff8000 (-32768 sign-extended to word)
  TEST_R_OP( 3, psext.w.h, 0xffff8000ffff8000, 0x0000800000008000 );

  # Test case 3: 0xFFFF in low halfword (-1) sign extends to 0xFFFFFFFF
  # rs1 = 0x0000ffff0000ffff
  # Expected: 0xffffffffffffffff
  TEST_R_OP( 4, psext.w.h, 0xffffffffffffffff, 0x0000ffff0000ffff );

  # Test case 4: Zero remains zero
  TEST_R_OP( 5, psext.w.h, 0x0000000000000000, 0x0000000000000000 );

  # Test case 5: High halfword is ignored, only low halfword matters
  # rs1 = 0xffff0005ffff0005 (high halfword 0xFFFF, low halfword 0x0005)
  # Expected: 0x0000000500000005 (only low halfword 0x0005 is sign-extended)
  TEST_R_OP( 6, psext.w.h, 0x0000000500000005, 0xffff0005ffff0005 );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END


