#*****************************************************************************
# jalr_r.S
#-----------------------------------------------------------------------------
#
# Test jalr.r instruction.
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV64U
RVTEST_CODE_BEGIN

  #-------------------------------------------------------------
  # Test 2: Basic test
  #-------------------------------------------------------------

test_2:
  li  x28, 2
  li  x31, 0
  la  x2, target_2

linkaddr_2:
  jalr.r x19, x2, 0
  nop
  nop

  j fail

target_2:
  la  x1, linkaddr_2
  addi x1, x1, 4
  bne x1, x19, fail

  #-------------------------------------------------------------
  # Test 3: Check r0 target and that r31 is not modified
  #-------------------------------------------------------------

test_3:
  li  x28, 3
  li  x31, 0
  la  x3, target_3

linkaddr_3:
  jalr.r x0, x3, 0
  nop

  j fail

target_3:
  bne x31, x0, fail

  #-------------------------------------------------------------
  # Bypassing tests
  #-------------------------------------------------------------

  TEST_JALR_SRC1_BYPASS( 4, 0, jalr.r );
  TEST_JALR_SRC1_BYPASS( 5, 1, jalr.r );
  TEST_JALR_SRC1_BYPASS( 6, 2, jalr.r );

  #-------------------------------------------------------------
  # Test delay slot instructions not executed nor bypassed
  #-------------------------------------------------------------

  TEST_CASE( 7, x1, 3, \
    li  x1, 1; \
    la  x2, 1f;
    jalr.r x19, x2, 0; \
    addi x1, x1, 1; \
    addi x1, x1, 1; \
    addi x1, x1, 1; \
    addi x1, x1, 1; \
1:  addi x1, x1, 1; \
    addi x1, x1, 1; \
  )

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END
