# See LICENSE for license details.

#*****************************************************************************
# bge.S
#-----------------------------------------------------------------------------
#
# Test bge instruction in a vf block.
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV64UV
RVTEST_CODE_BEGIN

  #-------------------------------------------------------------
  # Branch tests
  #-------------------------------------------------------------

  # Each test checks both forward and backward branches

  TEST_BR2_OP_TAKEN( 2, bge,  0,  0 );
  TEST_BR2_OP_TAKEN( 3, bge,  1,  1 );
  TEST_BR2_OP_TAKEN( 4, bge, -1, -1 );
  TEST_BR2_OP_TAKEN( 5, bge,  1,  0 );
  TEST_BR2_OP_TAKEN( 6, bge,  1, -1 );
  TEST_BR2_OP_TAKEN( 7, bge, -1, -2 );

  TEST_BR2_OP_NOTTAKEN(  8, bge,  0,  1 );
  TEST_BR2_OP_NOTTAKEN(  9, bge, -1,  1 );
  TEST_BR2_OP_NOTTAKEN( 10, bge, -2, -1 );
  TEST_BR2_OP_NOTTAKEN( 11, bge, -2,  1 );

  #-------------------------------------------------------------
  # Bypassing tests
  #-------------------------------------------------------------

  TEST_BR2_SRC12_BYPASS( 12, 0, 0, bge, -1, 0 );
  TEST_BR2_SRC12_BYPASS( 13, 0, 1, bge, -1, 0 );
  TEST_BR2_SRC12_BYPASS( 14, 0, 2, bge, -1, 0 );
  TEST_BR2_SRC12_BYPASS( 15, 1, 0, bge, -1, 0 );
  TEST_BR2_SRC12_BYPASS( 16, 1, 1, bge, -1, 0 );
  TEST_BR2_SRC12_BYPASS( 17, 2, 0, bge, -1, 0 );

  TEST_BR2_SRC12_BYPASS( 18, 0, 0, bge, -1, 0 );
  TEST_BR2_SRC12_BYPASS( 19, 0, 1, bge, -1, 0 );
  TEST_BR2_SRC12_BYPASS( 20, 0, 2, bge, -1, 0 );
  TEST_BR2_SRC12_BYPASS( 21, 1, 0, bge, -1, 0 );
  TEST_BR2_SRC12_BYPASS( 22, 1, 1, bge, -1, 0 );
  TEST_BR2_SRC12_BYPASS( 23, 2, 0, bge, -1, 0 );

  #-------------------------------------------------------------
  # Test when uts diverge
  #-------------------------------------------------------------

  TEST_BR2_DIVERGED_ODD_EVEN( 24, bge, 1, 1, \
    addi x3, x3, 1; \
  )
  TEST_BR2_DIVERGED_ODD_EVEN( 25, bge, 2, 2, \
    addi x3, x3, 1; \
  )
  TEST_BR2_DIVERGED_ODD_EVEN( 26, bge, 3, 3, \
    addi x3, x3, 1; \
  )

  TEST_BR2_DIVERGED_ODD_EVEN( 27, bge, 1, 16, \
    addi x3, x3, 4; \
    mul x3, x3, x3; \
  )
  TEST_BR2_DIVERGED_ODD_EVEN( 28, bge, 2, 400, \
    addi x3, x3, 4; \
    mul x3, x3, x3; \
  )
  TEST_BR2_DIVERGED_ODD_EVEN( 29, bge, 3, 163216, \
    addi x3, x3, 4; \
    mul x3, x3, x3; \
  ) 
 
  TEST_BR2_DIVERGED_FULL12( 30, bge, 1, 1, \
    addi x3, x3, 1; \
  )

  TEST_BR2_DIVERGED_FULL12( 31, bge, 1, 16, \
    addi x3, x3, 4; \
    mul x3, x3, x3; \
  )

  TEST_BR2_DIVERGED_MEM_FULL12( 32, bge, 1);

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END
