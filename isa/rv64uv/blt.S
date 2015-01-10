# See LICENSE for license details.

#*****************************************************************************
# blt.S
#-----------------------------------------------------------------------------
#
# Test blt instruction in a vf block.
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV64UV
RVTEST_CODE_BEGIN

  #-------------------------------------------------------------
  # Branch tests
  #-------------------------------------------------------------

  # Each test checks both forward and backward branches

  TEST_BR2_OP_TAKEN( 2, blt,  0,  1 );
  TEST_BR2_OP_TAKEN( 3, blt, -1,  1 );
  TEST_BR2_OP_TAKEN( 4, blt, -2, -1 );

  TEST_BR2_OP_NOTTAKEN( 5, blt,  1,  0 );
  TEST_BR2_OP_NOTTAKEN( 6, blt,  1, -1 );
  TEST_BR2_OP_NOTTAKEN( 7, blt, -1, -2 );
  TEST_BR2_OP_NOTTAKEN( 8, blt,  1, -2 );

  #-------------------------------------------------------------
  # Bypassing tests
  #-------------------------------------------------------------

  TEST_BR2_SRC12_BYPASS( 9,  0, 0, blt, 0, -1 );
  TEST_BR2_SRC12_BYPASS( 10, 0, 1, blt, 0, -1 );
  TEST_BR2_SRC12_BYPASS( 11, 0, 2, blt, 0, -1 );
  TEST_BR2_SRC12_BYPASS( 12, 1, 0, blt, 0, -1 );
  TEST_BR2_SRC12_BYPASS( 13, 1, 1, blt, 0, -1 );
  TEST_BR2_SRC12_BYPASS( 14, 2, 0, blt, 0, -1 );

  TEST_BR2_SRC12_BYPASS( 15, 0, 0, blt, 0, -1 );
  TEST_BR2_SRC12_BYPASS( 16, 0, 1, blt, 0, -1 );
  TEST_BR2_SRC12_BYPASS( 17, 0, 2, blt, 0, -1 );
  TEST_BR2_SRC12_BYPASS( 18, 1, 0, blt, 0, -1 );
  TEST_BR2_SRC12_BYPASS( 19, 1, 1, blt, 0, -1 );
  TEST_BR2_SRC12_BYPASS( 20, 2, 0, blt, 0, -1 );

  #-------------------------------------------------------------
  # Test when uts diverge
  #-------------------------------------------------------------

  TEST_BR2_DIVERGED_ODD_EVEN( 24, blt, 1, 1, \
    addi x3, x3, 1; \
  )
  TEST_BR2_DIVERGED_ODD_EVEN( 25, blt, 2, 2, \
    addi x3, x3, 1; \
  )
  TEST_BR2_DIVERGED_ODD_EVEN( 26, blt, 3, 3, \
    addi x3, x3, 1; \
  )

  TEST_BR2_DIVERGED_ODD_EVEN( 27, blt, 1, 16, \
    addi x3, x3, 4; \
    mul x3, x3, x3; \
  )
  TEST_BR2_DIVERGED_ODD_EVEN( 28, blt, 2, 400, \
    addi x3, x3, 4; \
    mul x3, x3, x3; \
  )
  TEST_BR2_DIVERGED_ODD_EVEN( 29, blt, 3, 163216, \
    addi x3, x3, 4; \
    mul x3, x3, x3; \
  )
  
  TEST_BR2_DIVERGED_FULL21( 30, blt, 0, 1, \
    addi x3, x3, 1; \
  )

  TEST_BR2_DIVERGED_FULL21( 31, blt, 0, 16, \
    addi x3, x3, 4; \
    mul x3, x3, x3; \
  )

  TEST_BR2_DIVERGED_MEM_FULL21( 32, blt, 0);

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END
