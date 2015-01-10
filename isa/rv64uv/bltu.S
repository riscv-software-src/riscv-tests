# See LICENSE for license details.

#*****************************************************************************
# bltu.S
#-----------------------------------------------------------------------------
#
# Test bltu instruction in a vf block.
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV64UV
RVTEST_CODE_BEGIN

  #-------------------------------------------------------------
  # Branch tests
  #-------------------------------------------------------------

  # Each test checks both forward and backward branches

  TEST_BR2_OP_TAKEN( 2, bltu, 0x00000000, 0x00000001 );
  TEST_BR2_OP_TAKEN( 3, bltu, 0xfffffffe, 0xffffffff );
  TEST_BR2_OP_TAKEN( 4, bltu, 0x00000000, 0xffffffff );

  TEST_BR2_OP_NOTTAKEN( 5, bltu, 0x00000001, 0x00000000 );
  TEST_BR2_OP_NOTTAKEN( 6, bltu, 0xffffffff, 0xfffffffe );
  TEST_BR2_OP_NOTTAKEN( 7, bltu, 0xffffffff, 0x00000000 );
  TEST_BR2_OP_NOTTAKEN( 8, bltu, 0x80000000, 0x7fffffff );

  #-------------------------------------------------------------
  # Bypassing tests
  #-------------------------------------------------------------

  TEST_BR2_SRC12_BYPASS( 9,  0, 0, bltu, 0xf0000000, 0xefffffff );
  TEST_BR2_SRC12_BYPASS( 10, 0, 1, bltu, 0xf0000000, 0xefffffff );
  TEST_BR2_SRC12_BYPASS( 11, 0, 2, bltu, 0xf0000000, 0xefffffff );
  TEST_BR2_SRC12_BYPASS( 12, 1, 0, bltu, 0xf0000000, 0xefffffff );
  TEST_BR2_SRC12_BYPASS( 13, 1, 1, bltu, 0xf0000000, 0xefffffff );
  TEST_BR2_SRC12_BYPASS( 14, 2, 0, bltu, 0xf0000000, 0xefffffff );

  TEST_BR2_SRC12_BYPASS( 15, 0, 0, bltu, 0xf0000000, 0xefffffff );
  TEST_BR2_SRC12_BYPASS( 16, 0, 1, bltu, 0xf0000000, 0xefffffff );
  TEST_BR2_SRC12_BYPASS( 17, 0, 2, bltu, 0xf0000000, 0xefffffff );
  TEST_BR2_SRC12_BYPASS( 18, 1, 0, bltu, 0xf0000000, 0xefffffff );
  TEST_BR2_SRC12_BYPASS( 19, 1, 1, bltu, 0xf0000000, 0xefffffff );
  TEST_BR2_SRC12_BYPASS( 20, 2, 0, bltu, 0xf0000000, 0xefffffff );

  #-------------------------------------------------------------
  # Test when uts diverge
  #-------------------------------------------------------------

  TEST_BR2_DIVERGED_ODD_EVEN( 24, bltu, 1, 1, \
    addi x3, x3, 1; \
  )
  TEST_BR2_DIVERGED_ODD_EVEN( 25, bltu, 2, 2, \
    addi x3, x3, 1; \
  )
  TEST_BR2_DIVERGED_ODD_EVEN( 26, bltu, 3, 3, \
    addi x3, x3, 1; \
  )

  TEST_BR2_DIVERGED_ODD_EVEN( 27, bltu, 1, 16, \
    addi x3, x3, 4; \
    mul x3, x3, x3; \
  )
  TEST_BR2_DIVERGED_ODD_EVEN( 28, bltu, 2, 400, \
    addi x3, x3, 4; \
    mul x3, x3, x3; \
  )
  TEST_BR2_DIVERGED_ODD_EVEN( 29, bltu, 3, 163216, \
    addi x3, x3, 4; \
    mul x3, x3, x3; \
  )
  
  TEST_BR2_DIVERGED_FULL21( 30, bltu, 0, 1, \
    addi x3, x3, 1; \
  )

  TEST_BR2_DIVERGED_FULL21( 31, bltu, 0, 16, \
    addi x3, x3, 4; \
    mul x3, x3, x3; \
  )

  TEST_BR2_DIVERGED_MEM_FULL21( 32, bltu, 0 );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END
