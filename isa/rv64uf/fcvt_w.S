#*****************************************************************************
# fcvt_w.S
#-----------------------------------------------------------------------------
#
# Test fcvt{wu|w|lu|l}.{s|d} instructions.
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV64U
RVTEST_CODE_BEGIN

  #-------------------------------------------------------------
  # Arithmetic tests
  #-------------------------------------------------------------

  TEST_FP_INT_OP_S( 2,  fcvt.w.s, -1, -1.1, rtz);
  TEST_FP_INT_OP_S( 3,  fcvt.w.s, -1, -1.0, rtz);
  TEST_FP_INT_OP_S( 4,  fcvt.w.s,  0, -0.9, rtz);
  TEST_FP_INT_OP_S( 5,  fcvt.w.s,  0,  0.9, rtz);
  TEST_FP_INT_OP_S( 6,  fcvt.w.s,  1,  1.0, rtz);
  TEST_FP_INT_OP_S( 7,  fcvt.w.s,  1,  1.1, rtz);

  TEST_FP_INT_OP_S(12, fcvt.wu.s, -1, -3.0, rtz); # invalid
  TEST_FP_INT_OP_S(13, fcvt.wu.s, -1, -1.0, rtz); # invalid
  TEST_FP_INT_OP_S(14, fcvt.wu.s,  0, -0.9, rtz);
  TEST_FP_INT_OP_S(15, fcvt.wu.s,  0,  0.9, rtz);
  TEST_FP_INT_OP_S(16, fcvt.wu.s,  1,  1.0, rtz);
  TEST_FP_INT_OP_S(17, fcvt.wu.s,  1,  1.1, rtz);

  TEST_FP_INT_OP_S(22,  fcvt.l.s, -1, -1.1, rtz);
  TEST_FP_INT_OP_S(23,  fcvt.l.s, -1, -1.0, rtz);
  TEST_FP_INT_OP_S(24,  fcvt.l.s,  0, -0.9, rtz);
  TEST_FP_INT_OP_S(25,  fcvt.l.s,  0,  0.9, rtz);
  TEST_FP_INT_OP_S(26,  fcvt.l.s,  1,  1.0, rtz);
  TEST_FP_INT_OP_S(27,  fcvt.l.s,  1,  1.1, rtz);

  TEST_FP_INT_OP_S(32, fcvt.lu.s, -1, -3.0, rtz); # invalid
  TEST_FP_INT_OP_S(33, fcvt.lu.s, -1, -1.0, rtz); # invalid
  TEST_FP_INT_OP_S(34, fcvt.lu.s,  0, -0.9, rtz);
  TEST_FP_INT_OP_S(35, fcvt.lu.s,  0,  0.9, rtz);
  TEST_FP_INT_OP_S(36, fcvt.lu.s,  1,  1.0, rtz);
  TEST_FP_INT_OP_S(37, fcvt.lu.s,  1,  1.1, rtz);

  TEST_FP_INT_OP_D(42,  fcvt.w.d, -1, -1.1, rtz);
  TEST_FP_INT_OP_D(43,  fcvt.w.d, -1, -1.0, rtz);
  TEST_FP_INT_OP_D(44,  fcvt.w.d,  0, -0.9, rtz);
  TEST_FP_INT_OP_D(45,  fcvt.w.d,  0,  0.9, rtz);
  TEST_FP_INT_OP_D(46,  fcvt.w.d,  1,  1.0, rtz);
  TEST_FP_INT_OP_D(47,  fcvt.w.d,  1,  1.1, rtz);

  TEST_FP_INT_OP_D(52, fcvt.wu.d, -1, -3.0, rtz); # invalid
  TEST_FP_INT_OP_D(53, fcvt.wu.d, -1, -1.0, rtz); # invalid
  TEST_FP_INT_OP_D(54, fcvt.wu.d,  0, -0.9, rtz);
  TEST_FP_INT_OP_D(55, fcvt.wu.d,  0,  0.9, rtz);
  TEST_FP_INT_OP_D(56, fcvt.wu.d,  1,  1.0, rtz);
  TEST_FP_INT_OP_D(57, fcvt.wu.d,  1,  1.1, rtz);

  TEST_FP_INT_OP_D(62,  fcvt.l.d, -1, -1.1, rtz);
  TEST_FP_INT_OP_D(63,  fcvt.l.d, -1, -1.0, rtz);
  TEST_FP_INT_OP_D(64,  fcvt.l.d,  0, -0.9, rtz);
  TEST_FP_INT_OP_D(65,  fcvt.l.d,  0,  0.9, rtz);
  TEST_FP_INT_OP_D(66,  fcvt.l.d,  1,  1.0, rtz);
  TEST_FP_INT_OP_D(67,  fcvt.l.d,  1,  1.1, rtz);

  TEST_FP_INT_OP_D(72, fcvt.lu.d, -1, -3.0, rtz); # invalid
  TEST_FP_INT_OP_D(73, fcvt.lu.d, -1, -1.0, rtz); # invalid
  TEST_FP_INT_OP_D(74, fcvt.lu.d,  0, -0.9, rtz);
  TEST_FP_INT_OP_D(75, fcvt.lu.d,  0,  0.9, rtz);
  TEST_FP_INT_OP_D(76, fcvt.lu.d,  1,  1.0, rtz);
  TEST_FP_INT_OP_D(77, fcvt.lu.d,  1,  1.1, rtz);

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END
