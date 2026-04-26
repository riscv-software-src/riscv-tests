# See LICENSE for license details.

#*****************************************************************************
# pwsll_hs.S
#-----------------------------------------------------------------------------
#
# Test pwsll.hs instruction (packed widening shift left logical, halfword to word).
# RV32-only instruction. Widens each unsigned halfword to word and shifts left.
# Result is stored in register pair (rd, rd+1).
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV32U
RVTEST_CODE_BEGIN

  #-------------------------------------------------------------
  # Arithmetic tests
  #-------------------------------------------------------------

  # Test 2: Simple widening shift by 1
  # rs1 = 0x00010002 (halfwords: 1, 2)
  # Each halfword zero-extended to word, then shifted left by 1
  # 1->2, 2->4 = Low: 0x00000004
  TEST_RR_OP( 2, pwsll.hs, 0x00000004, 0x00010002, 1 );

  # Test 3: Shift by 16
  # rs1 = 0x00010002
  # 1<<16=0x00010000, 2<<16=0x00020000
  # Low: 0x00020000
  TEST_RR_OP( 3, pwsll.hs, 0x00020000, 0x00010002, 16 );

  # Test 4: High halfword values (unsigned)
  # rs1 = 0xFFFEFFFC (halfwords: 65534, 65532)
  # 65534<<1=131068, 65532<<1=131064
  # Low: 0x0001FFF8
  TEST_RR_OP( 4, pwsll.hs, 0x0001FFF8, 0xFFFEFFFC, 1 );

  # Test 5: Shift by 0 (just widen)
  # rs1 = 0xFFFF8000 (halfwords: 65535, 32768)
  # Low: 0x00008000
  TEST_RR_OP( 5, pwsll.hs, 0x00008000, 0xFFFF8000, 0 );

  # Test 6: Zero input
  TEST_RR_OP( 6, pwsll.hs, 0x00000000, 0x00000000, 5 );

  # Test 7: All 0xFFFF
  # 65535 << 1 = 131070 = 0x0001FFFE for each word
  TEST_RR_OP( 7, pwsll.hs, 0x0001FFFE, 0xFFFFFFFF, 1 );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END

