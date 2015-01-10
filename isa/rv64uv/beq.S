# See LICENSE for license details.

#*****************************************************************************
# beq.S
#-----------------------------------------------------------------------------
#
# Test beq instruction in a vf block.
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV64UV
RVTEST_CODE_BEGIN

  #-------------------------------------------------------------
  # Branch tests
  #-------------------------------------------------------------

  # Each test checks both forward and backward branches

  TEST_BR2_OP_TAKEN( 2, beq,  0,  0 );
  TEST_BR2_OP_TAKEN( 3, beq,  1,  1 );
  TEST_BR2_OP_TAKEN( 4, beq, -1, -1 );

  TEST_BR2_OP_NOTTAKEN( 5, beq,  0,  1 );
  TEST_BR2_OP_NOTTAKEN( 6, beq,  1,  0 );
  TEST_BR2_OP_NOTTAKEN( 7, beq, -1,  1 );
  TEST_BR2_OP_NOTTAKEN( 8, beq,  1, -1 );

  #-------------------------------------------------------------
  # Bypassing tests
  #-------------------------------------------------------------

  TEST_BR2_SRC12_BYPASS( 9,  0, 0, beq, 0, -1 );
  TEST_BR2_SRC12_BYPASS( 10, 0, 1, beq, 0, -1 );
  TEST_BR2_SRC12_BYPASS( 11, 0, 2, beq, 0, -1 );
  TEST_BR2_SRC12_BYPASS( 12, 1, 0, beq, 0, -1 );
  TEST_BR2_SRC12_BYPASS( 13, 1, 1, beq, 0, -1 );
  TEST_BR2_SRC12_BYPASS( 14, 2, 0, beq, 0, -1 );

  TEST_BR2_SRC12_BYPASS( 15, 0, 0, beq, 0, -1 );
  TEST_BR2_SRC12_BYPASS( 16, 0, 1, beq, 0, -1 );
  TEST_BR2_SRC12_BYPASS( 17, 0, 2, beq, 0, -1 );
  TEST_BR2_SRC12_BYPASS( 18, 1, 0, beq, 0, -1 );
  TEST_BR2_SRC12_BYPASS( 19, 1, 1, beq, 0, -1 );
  TEST_BR2_SRC12_BYPASS( 20, 2, 0, beq, 0, -1 );

  #-------------------------------------------------------------
  # Test when uts diverge
  #-------------------------------------------------------------

  TEST_BR2_DIVERGED_ODD_EVEN( 24, beq, 1, 1, \
    addi x3, x3, 1; \
  )
  TEST_BR2_DIVERGED_ODD_EVEN( 25, beq, 2, 2, \
    addi x3, x3, 1; \
  )
  TEST_BR2_DIVERGED_ODD_EVEN( 26, beq, 3, 3, \
    addi x3, x3, 1; \
  )

  TEST_BR2_DIVERGED_ODD_EVEN( 27, beq, 1, 16, \
    addi x3, x3, 4; \
    mul x3, x3, x3; \
  )
  TEST_BR2_DIVERGED_ODD_EVEN( 28, beq, 2, 400, \
    addi x3, x3, 4; \
    mul x3, x3, x3; \
  )
  TEST_BR2_DIVERGED_ODD_EVEN( 29, beq, 3, 163216, \
    addi x3, x3, 4; \
    mul x3, x3, x3; \
  )
  
  TEST_BR2_DIVERGED_FULL12( 30, beq, 1, 1, \
    addi x3, x3, 1; \
  )

  TEST_BR2_DIVERGED_FULL12( 31, beq, 1, 16, \
    addi x3, x3, 4; \
    mul x3, x3, x3; \
  )

  TEST_BR2_DIVERGED_MEM_FULL12( 32, beq, 1);

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END
