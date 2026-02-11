# See LICENSE for license details.

#*****************************************************************************
# ppairoe_h.S
#-----------------------------------------------------------------------------
#
# Test ppairoe.h instruction (packed pair odd-even halfword).
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV64U
RVTEST_CODE_BEGIN

  #-------------------------------------------------------------
  # Arithmetic tests
  #-------------------------------------------------------------

  # ppairoe.h rd, rs1, rs2
  # Selects odd halfwords from rs1 and even halfwords from rs2 and packs them
  # rd[i*2] = rs1[i*2+1], rd[i*2+1] = rs2[i*2] for each pair

  # Test case 1: Distinct halfword pattern
  # rs1 = 0x0003000200010000, rs2 = 0x0007000600050004
  # Odd halfwords rs1: 0001, 0003; Even halfwords rs2: 0004, 0006
  # Expected: 0x0006000300040001
  TEST_RR_OP( 2, ppairoe.h, 0x0006000300040001, 0x0003000200010000, 0x0007000600050004 );

  # Test case 2: Zero values
  TEST_RR_OP( 3, ppairoe.h, 0x0000000000000000, 0x0000000000000000, 0x0000000000000000 );

  # Test case 3: All ones
  TEST_RR_OP( 4, ppairoe.h, 0xffffffffffffffff, 0xffffffffffffffff, 0xffffffffffffffff );

  # Test case 4: Mixed pattern
  TEST_RR_OP( 5, ppairoe.h, 0xccccaaaaddddbbbb, 0xaaaa1234bbbb5678, 0xbeefccccdeaddddd );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END

