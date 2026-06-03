# See LICENSE for license details.

#*****************************************************************************
# pack.S (RV32)
#-----------------------------------------------------------------------------
#
# Test pack instruction on RV32. PACK packs XLEN/2-bit (= 16-bit on RV32)
# low halves of rs1 and rs2: rd = rs2[15:0] @ rs1[15:0].
# rv32up needs its own literals because the rv64up source uses 32-bit halves.
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV32U
RVTEST_CODE_BEGIN

  # pack rd, rs1, rs2: rd = {rs2[15:0], rs1[15:0]}

  # Test 1: low halfwords picked from each operand
  # rs1=0xAAAA2222 (low half 0x2222), rs2=0xBBBB4444 (low half 0x4444)
  TEST_RR_OP( 2, pack, 0x44442222, 0xAAAA2222, 0xBBBB4444 );

  # Test 2: zero values
  TEST_RR_OP( 3, pack, 0x00000000, 0x00000000, 0x00000000 );

  # Test 3: all ones in the low halves
  TEST_RR_OP( 4, pack, 0xffffffff, 0x0000ffff, 0x0000ffff );

  # Test 4: mixed pattern, upper halves should be ignored
  # rs1=0x12345678 (low 0x5678), rs2=0xABCDDEAD (low 0xDEAD)
  TEST_RR_OP( 5, pack, 0xdead5678, 0x12345678, 0xABCDDEAD );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END
