# See LICENSE for license details.

#*****************************************************************************
# pmseq_b.S
#-----------------------------------------------------------------------------
#
# Test pmseq.b instruction (packed mask set equal byte).
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV64U
RVTEST_CODE_BEGIN

  #-------------------------------------------------------------
  # Arithmetic tests
  #-------------------------------------------------------------

  # pmseq.b rd, rs1, rs2
  # Sets mask: rd[i] = 0xff if rs1[i] == rs2[i], else 0x00 for each byte

  # Test case 1: All equal - all masks set
  TEST_RR_OP( 2, pmseq.b, 0xffffffffffffffff, 0x0505050505050505, 0x0505050505050505 );

  # Test case 2: All different - no masks set
  TEST_RR_OP( 3, pmseq.b, 0x0000000000000000, 0x0505050505050505, 0x0303030303030303 );

  # Test case 3: Mixed equal and different
  # rs1 = 0x0102030405060708, rs2 = 0x0102040405060709
  # Bytes: (01==01), (02==02), (03!=04), (04==04), (05==05), (06==06), (07==07), (08!=09)
  TEST_RR_OP( 4, pmseq.b, 0xffff00ffffffff00, 0x0102030405060708, 0x0102040405060709 );

  # Test case 4: Zero comparison
  TEST_RR_OP( 5, pmseq.b, 0xffffffffffffffff, 0x0000000000000000, 0x0000000000000000 );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END


