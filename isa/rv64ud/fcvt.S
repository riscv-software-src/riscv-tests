# See LICENSE for license details.

#*****************************************************************************
# fcvt.S
#-----------------------------------------------------------------------------
#
# Test fcvt.d.{wu|w|lu|l}, fcvt.s.d, and fcvt.d.s instructions.
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV64UF
RVTEST_CODE_BEGIN

#if __riscv_xlen == 32
    # Replace the function with the 32-bit variant defined in test_macros.h
    #undef TEST_INT_FP_OP_D
    #define TEST_INT_FP_OP_D TEST_INT_FP_OP_D32

    #undef TEST_FCVT_S_D
    #define TEST_FCVT_S_D TEST_FCVT_S_D32
#endif

  #-------------------------------------------------------------
  # Arithmetic tests
  #-------------------------------------------------------------

  TEST_INT_FP_OP_D(2,  fcvt.d.w,                   2.0,  2);
  TEST_INT_FP_OP_D(3,  fcvt.d.w,                  -2.0, -2);

  TEST_INT_FP_OP_D(4, fcvt.d.wu,                   2.0,  2);
  TEST_INT_FP_OP_D(5, fcvt.d.wu,            4294967294, -2);

#if __riscv_xlen >= 64
  TEST_INT_FP_OP_D(6,  fcvt.d.l,                   2.0,  2);
  TEST_INT_FP_OP_D(7,  fcvt.d.l,                  -2.0, -2);

  TEST_INT_FP_OP_D(8, fcvt.d.lu,                   2.0,  2);
  TEST_INT_FP_OP_D(9, fcvt.d.lu, 1.8446744073709552e19, -2);
#endif

  TEST_FCVT_S_D(10, -1.5, -1.5)
  TEST_FCVT_D_S(11, -1.5, -1.5)

#if __riscv_xlen >= 64
  TEST_CASE(12, a0, qNaNd,
    la a1, test_data_22;
    ld a2, 0(a1);
    fmv.d.x f2, a2;
    fcvt.s.d f2, f2;
    fcvt.d.s f2, f2;
    fmv.x.d a0, f2;
  )
#else
  TEST_CASE_D32(12, a0, a1, qNaNd,
    la a1, test_data_22;
    fld f2, 0(a1);
    fcvt.s.d f2, f2;
    fcvt.d.s f2, f2;
    fsd f2, 0(a1);
    lw a0, 0(a1);
    lw a1, 4(a1)
  )
#endif

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

test_data_22:
  .dword 0x7ffcffffffff8004

RVTEST_DATA_END
