# See LICENSE for license details.

#*****************************************************************************
# rol.S
#-----------------------------------------------------------------------------
#
# Test rol instruction.
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV32U
RVTEST_CODE_BEGIN

  #-------------------------------------------------------------
  # Arithmetic tests
  #-------------------------------------------------------------

  TEST_RR_OP( 2,  rol, 0x00000001, 0x00000001, 0  );
  TEST_RR_OP( 3,  rol, 0x00000002, 0x00000001, 1  );
  TEST_RR_OP( 4,  rol, 0x00000080, 0x00000001, 7  );
  TEST_RR_OP( 5,  rol, 0x00004000, 0x00000001, 14 );
  TEST_RR_OP( 6,  rol, 0x80000000, 0x00000001, 31 );

  TEST_RR_OP( 7,  rol, 0xffffffff, 0xffffffff, 0  );
  TEST_RR_OP( 8,  rol, 0xffffffff, 0xffffffff, 1  );
  TEST_RR_OP( 9,  rol, 0xffffffff, 0xffffffff, 7  );
  TEST_RR_OP( 10, rol, 0xffffffff, 0xffffffff, 14 );
  TEST_RR_OP( 11, rol, 0xffffffff, 0xffffffff, 31 );

  TEST_RR_OP( 12, rol, 0x21212121, 0x21212121, 0  );
  TEST_RR_OP( 13, rol, 0x42424242, 0x21212121, 1  );
  TEST_RR_OP( 14, rol, 0x90909090, 0x21212121, 7  );
  TEST_RR_OP( 15, rol, 0x48484848, 0x21212121, 14 );
  TEST_RR_OP( 16, rol, 0x90909090, 0x21212121, 31 );

  # Verify that rotates only use bottom five bits

  TEST_RR_OP( 17, rol, 0x21212121, 0x21212121, 0xffffffe0 );
  TEST_RR_OP( 18, rol, 0x42424242, 0x21212121, 0xffffffe1 );
  TEST_RR_OP( 19, rol, 0x90909090, 0x21212121, 0xffffffe7 );
  TEST_RR_OP( 20, rol, 0x48484848, 0x21212121, 0xffffffee );
  TEST_RR_OP( 21, rol, 0x90909090, 0x21212121, 0xffffffff );

  # Verify that rotates ignore top 32 (using true 64-bit values)

  TEST_RR_OP( 44, rol, 0x12345678, 0x12345678, 0 );
  TEST_RR_OP( 45, rol, 0x23456781, 0x12345678, 4 );
  TEST_RR_OP( 46, rol, 0x92345678, 0x92345678, 0 );
  TEST_RR_OP( 47, rol, 0x93456789, 0x99345678, 4 );

  #-------------------------------------------------------------
  # Source/Destination tests
  #-------------------------------------------------------------

  TEST_RR_SRC1_EQ_DEST( 22, rol, 0x00000080, 0x00000001, 7  );
  TEST_RR_SRC2_EQ_DEST( 23, rol, 0x00004000, 0x00000001, 14 );
  TEST_RR_SRC12_EQ_DEST( 24, rol, 24, 3 );

  #-------------------------------------------------------------
  # Bypassing tests
  #-------------------------------------------------------------

  TEST_RR_DEST_BYPASS( 25, 0, rol, 0x00000080, 0x00000001, 7  );
  TEST_RR_DEST_BYPASS( 26, 1, rol, 0x00004000, 0x00000001, 14 );
  TEST_RR_DEST_BYPASS( 27, 2, rol, 0x80000000, 0x00000001, 31 );

  TEST_RR_SRC12_BYPASS( 28, 0, 0, rol, 0x00000080, 0x00000001, 7  );
  TEST_RR_SRC12_BYPASS( 29, 0, 1, rol, 0x00004000, 0x00000001, 14 );
  TEST_RR_SRC12_BYPASS( 30, 0, 2, rol, 0x80000000, 0x00000001, 31 );
  TEST_RR_SRC12_BYPASS( 31, 1, 0, rol, 0x00000080, 0x00000001, 7  );
  TEST_RR_SRC12_BYPASS( 32, 1, 1, rol, 0x00004000, 0x00000001, 14 );
  TEST_RR_SRC12_BYPASS( 33, 2, 0, rol, 0x80000000, 0x00000001, 31 );

  TEST_RR_SRC21_BYPASS( 34, 0, 0, rol, 0x00000080, 0x00000001, 7  );
  TEST_RR_SRC21_BYPASS( 35, 0, 1, rol, 0x00004000, 0x00000001, 14 );
  TEST_RR_SRC21_BYPASS( 36, 0, 2, rol, 0x80000000, 0x00000001, 31 );
  TEST_RR_SRC21_BYPASS( 37, 1, 0, rol, 0x00000080, 0x00000001, 7  );
  TEST_RR_SRC21_BYPASS( 38, 1, 1, rol, 0x00004000, 0x00000001, 14 );
  TEST_RR_SRC21_BYPASS( 39, 2, 0, rol, 0x80000000, 0x00000001, 31 );

  TEST_RR_ZEROSRC1( 40, rol, 0, 15 );
  TEST_RR_ZEROSRC2( 41, rol, 32, 32 );
  TEST_RR_ZEROSRC12( 42, rol, 0 );
  TEST_RR_ZERODEST( 43, rol, 1024, 2048 );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END
