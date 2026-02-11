# See LICENSE for license details.

#*****************************************************************************
# padd_dbs.S
#-----------------------------------------------------------------------------
#
# Test padd.dbs instruction (packed byte add with scalar, double-word, RV32 only).
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV32U
RVTEST_CODE_BEGIN

  #-------------------------------------------------------------
  # Arithmetic tests
  #-------------------------------------------------------------

  # padd.dbs rd, rs1, rs2
  # Packed byte addition with scalar broadcast on 64-bit register pairs

  # Test case 1: Simple byte addition with scalar
  TEST_CASE( 2, x14, 0x02030405, \
    li x10, 0x01020304; \
    li x11, 0x05060708; \
    li x12, 0x01; \
    padd.dbs x14, x10, x12 );
  TEST_CASE( 3, x15, 0x06070809, nop );

  # Test case 2: Zero scalar
  TEST_CASE( 4, x14, 0x01020304, \
    li x10, 0x01020304; \
    li x11, 0x05060708; \
    li x12, 0x00; \
    padd.dbs x14, x10, x12 );
  TEST_CASE( 5, x15, 0x05060708, nop );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END

