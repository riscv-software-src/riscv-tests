# See LICENSE for license details.

#*****************************************************************************
# pmseq_dh.S
#-----------------------------------------------------------------------------
#
# Test pmseq.dh instruction (packed mask set equal halfword, double-word, RV32 only).
# Note: rd and rs1 must be even registers (register-pair constraint).
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV32U
RVTEST_CODE_BEGIN

  #-------------------------------------------------------------
  # Arithmetic tests
  #-------------------------------------------------------------

  # pmseq.dh rd, rs1, rs2
  # Sets mask: rd[i] = 0xffff if rs1[i] == rs2[i], else 0x0000 for each halfword (64-bit)
  # rd and rs1 must be even registers

  # Test case 1: All equal - all masks set
  TEST_CASE( 2, x14, 0xffffffff, \
    li x10, 0x00050005; \
    li x11, 0x00050005; \
    li x12, 0x00050005; \
    li x13, 0x00050005; \
    pmseq.dh x14, x10, x12 );
  TEST_CASE( 3, x15, 0xffffffff, nop );

  # Test case 2: All different - no masks set
  TEST_CASE( 4, x14, 0x00000000, \
    li x10, 0x00050005; \
    li x11, 0x00050005; \
    li x12, 0x00030003; \
    li x13, 0x00030003; \
    pmseq.dh x14, x10, x12 );
  TEST_CASE( 5, x15, 0x00000000, nop );

  # Test case 3: Mixed equal and different
  # Low 32: rs1 = 0x00030004, rs2 = 0x00030005
  # Halfwords: (0003==0003), (0004!=0005) -> 0xffff0000
  TEST_CASE( 6, x14, 0xffff0000, \
    li x10, 0x00030004; \
    li x11, 0x00010002; \
    li x12, 0x00030005; \
    li x13, 0x00010003; \
    pmseq.dh x14, x10, x12 );
  # High 32: rs1 = 0x00010002, rs2 = 0x00010003
  # Halfwords: (0001==0001), (0002!=0003) -> 0xffff0000
  TEST_CASE( 7, x15, 0xffff0000, nop );

  # Test case 4: Zero comparison
  TEST_CASE( 8, x14, 0xffffffff, \
    li x10, 0x00000000; \
    li x11, 0x00000000; \
    li x12, 0x00000000; \
    li x13, 0x00000000; \
    pmseq.dh x14, x10, x12 );
  TEST_CASE( 9, x15, 0xffffffff, nop );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END

