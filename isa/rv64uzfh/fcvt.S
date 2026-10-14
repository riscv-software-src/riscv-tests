# See LICENSE for license details.

#*****************************************************************************
# fcvt.S
#-----------------------------------------------------------------------------
#
# Test fcvt.h.{wu|w|lu|l}, fcvt.h.d, and fcvt.d.h instructions.
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV64UF
RVTEST_CODE_BEGIN

  #-------------------------------------------------------------
  # Arithmetic tests
  #-------------------------------------------------------------

  TEST_INT_FP_OP_H( 2,  fcvt.h.w,                   2.0,  2);
  TEST_INT_FP_OP_H( 3,  fcvt.h.w,                  -2.0, -2);

  TEST_INT_FP_OP_H( 4, fcvt.h.wu,                   2.0,  2);
  TEST_INT_FP_OP_H( 5, fcvt.h.wu,               0h:7c00, -2);

#if __riscv_xlen >= 64
  TEST_INT_FP_OP_H( 6,  fcvt.h.l,                   2.0,  2);
  TEST_INT_FP_OP_H( 7,  fcvt.h.l,                  -2.0, -2);

  TEST_INT_FP_OP_H( 8, fcvt.h.lu,                   2.0,  2);
  TEST_INT_FP_OP_H( 9, fcvt.h.lu,               0h:7c00, -2);
#endif
  
  TEST_FCVT_H_S( 10, -1.5, -1.5)

#if __riscv_xlen >= 64
  TEST_FCVT_H_D( 11, -1.5, -1.5)
#endif
  
  # Check each conversion independently so raw copies cannot pass a round trip.
  TEST_CASE( 12, a0, 0xffffffffbfc00000,
    la a1, half;
    flh f10, 0(a1);
    fcvt.s.h f13, f10;
    fmv.x.w a0, f13;
  )
  fsflags a0, x0;
  bnez a0, fail;

  TEST_CASE( 13, a0, 0xffffffffffffbe00,
    la a1, single;
    flw f10, 0(a1);
    fcvt.h.s f13, f10;
    fmv.x.h a0, f13;
  )
  fsflags a0, x0;
  bnez a0, fail;

#if __riscv_xlen >= 64
  TEST_CASE( 14, a0, 0xbff8000000000000,
    la a1, half;
    flh f10, 0(a1);
    fcvt.d.h f13, f10;
    fmv.x.d a0, f13;
  )
  fsflags a0, x0;
  bnez a0, fail;

  TEST_CASE( 15, a0, 0xffffffffffffbe00,
    la a1, double;
    fld f10, 0(a1);
    fcvt.h.d f13, f10;
    fmv.x.h a0, f13;
  )
  fsflags a0, x0;
  bnez a0, fail;
#endif

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

  .align 1
half: .float16 -1.5
  .align 2
single: .float -1.5
#if __riscv_xlen >= 64
  .align 3
double: .double -1.5
#endif

RVTEST_DATA_END
