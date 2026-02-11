# See LICENSE for license details.

#*****************************************************************************
# pmseq_dw.S
#-----------------------------------------------------------------------------
#
# Test pmseq.dw instruction (packed mask set equal word, double-word, RV32 only).
# Note: rd and rs1 must be even registers (register-pair constraint).
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV32U
RVTEST_CODE_BEGIN

  #-------------------------------------------------------------
  # Arithmetic tests
  #-------------------------------------------------------------

  # pmseq.dw rd, rs1, rs2
  # Sets mask: rd[i] = 0xffffffff if rs1[i] == rs2[i], else 0x00000000 for each word (64-bit)
  # rd and rs1 must be even registers

  # Test case 1: All equal - all masks set
  TEST_CASE( 2, x14, 0xffffffff, \
    li x10, 0x00000005; \
    li x11, 0x00000005; \
    li x12, 0x00000005; \
    li x13, 0x00000005; \
    pmseq.dw x14, x10, x12 );
  TEST_CASE( 3, x15, 0xffffffff, nop );

  # Test case 2: All different - no masks set
  TEST_CASE( 4, x14, 0x00000000, \
    li x10, 0x00000005; \
    li x11, 0x00000005; \
    li x12, 0x00000003; \
    li x13, 0x00000003; \
    pmseq.dw x14, x10, x12 );
  TEST_CASE( 5, x15, 0x00000000, nop );

  # Test case 3: Mixed equal and different
  # Low word: rs1 = 0x00000002, rs2 = 0x00000003 (not equal) -> 0x00000000
  # High word: rs1 = 0x00000001, rs2 = 0x00000001 (equal) -> 0xffffffff
  TEST_CASE( 6, x14, 0x00000000, \
    li x10, 0x00000002; \
    li x11, 0x00000001; \
    li x12, 0x00000003; \
    li x13, 0x00000001; \
    pmseq.dw x14, x10, x12 );
  TEST_CASE( 7, x15, 0xffffffff, nop );

  # Test case 4: Zero comparison
  TEST_CASE( 8, x14, 0xffffffff, \
    li x10, 0x00000000; \
    li x11, 0x00000000; \
    li x12, 0x00000000; \
    li x13, 0x00000000; \
    pmseq.dw x14, x10, x12 );
  TEST_CASE( 9, x15, 0xffffffff, nop );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END

