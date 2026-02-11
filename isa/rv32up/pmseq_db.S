# See LICENSE for license details.

#*****************************************************************************
# pmseq_db.S
#-----------------------------------------------------------------------------
#
# Test pmseq.db instruction (packed mask set equal byte, double-word, RV32 only).
# Note: rd and rs1 must be even registers (register-pair constraint).
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV32U
RVTEST_CODE_BEGIN

  #-------------------------------------------------------------
  # Arithmetic tests
  #-------------------------------------------------------------

  # pmseq.db rd, rs1, rs2
  # Sets mask: rd[i] = 0xff if rs1[i] == rs2[i], else 0x00 for each byte (64-bit)
  # rd and rs1 must be even registers

  # Test case 1: All equal - all masks set
  TEST_CASE( 2, x14, 0xffffffff, \
    li x10, 0x05050505; \
    li x11, 0x05050505; \
    li x12, 0x05050505; \
    li x13, 0x05050505; \
    pmseq.db x14, x10, x12 );
  TEST_CASE( 3, x15, 0xffffffff, nop );

  # Test case 2: All different - no masks set
  TEST_CASE( 4, x14, 0x00000000, \
    li x10, 0x05050505; \
    li x11, 0x05050505; \
    li x12, 0x03030303; \
    li x13, 0x03030303; \
    pmseq.db x14, x10, x12 );
  TEST_CASE( 5, x15, 0x00000000, nop );

  # Test case 3: Mixed equal and different
  # Low 32: rs1 = 0x05060708, rs2 = 0x05060709
  # Bytes: (05==05), (06==06), (07==07), (08!=09) -> 0xffffff00
  TEST_CASE( 6, x14, 0xffffff00, \
    li x10, 0x05060708; \
    li x11, 0x01020304; \
    li x12, 0x05060709; \
    li x13, 0x01020404; \
    pmseq.db x14, x10, x12 );
  # High 32: rs1 = 0x01020304, rs2 = 0x01020404
  # Bytes: (01==01), (02==02), (03!=04), (04==04) -> 0xffff00ff
  TEST_CASE( 7, x15, 0xffff00ff, nop );

  # Test case 4: Zero comparison
  TEST_CASE( 8, x14, 0xffffffff, \
    li x10, 0x00000000; \
    li x11, 0x00000000; \
    li x12, 0x00000000; \
    li x13, 0x00000000; \
    pmseq.db x14, x10, x12 );
  TEST_CASE( 9, x15, 0xffffffff, nop );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END

