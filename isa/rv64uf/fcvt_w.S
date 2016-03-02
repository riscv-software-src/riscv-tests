# See LICENSE for license details.

#*****************************************************************************
# fcvt_w.S
#-----------------------------------------------------------------------------
#
# Test fcvt{wu|w|lu|l}.{s|d} instructions.
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV64UF
RVTEST_CODE_BEGIN

  #-------------------------------------------------------------
  # Arithmetic tests
  #-------------------------------------------------------------

  TEST_FP_INT_OP_S( 2,  fcvt.w.s, 0x01,         -1, -1.1, rtz);
  TEST_FP_INT_OP_S( 3,  fcvt.w.s, 0x00,         -1, -1.0, rtz);
  TEST_FP_INT_OP_S( 4,  fcvt.w.s, 0x01,          0, -0.9, rtz);
  TEST_FP_INT_OP_S( 5,  fcvt.w.s, 0x01,          0,  0.9, rtz);
  TEST_FP_INT_OP_S( 6,  fcvt.w.s, 0x00,          1,  1.0, rtz);
  TEST_FP_INT_OP_S( 7,  fcvt.w.s, 0x01,          1,  1.1, rtz);
  TEST_FP_INT_OP_S( 8,  fcvt.w.s, 0x10,     -1<<31, -3e9, rtz);
  TEST_FP_INT_OP_S( 9,  fcvt.w.s, 0x10,  (1<<31)-1,  3e9, rtz);

  TEST_FP_INT_OP_S(12, fcvt.wu.s, 0x10,          0, -3.0, rtz);
  TEST_FP_INT_OP_S(13, fcvt.wu.s, 0x10,          0, -1.0, rtz);
  TEST_FP_INT_OP_S(14, fcvt.wu.s, 0x01,          0, -0.9, rtz);
  TEST_FP_INT_OP_S(15, fcvt.wu.s, 0x01,          0,  0.9, rtz);
  TEST_FP_INT_OP_S(16, fcvt.wu.s, 0x00,          1,  1.0, rtz);
  TEST_FP_INT_OP_S(17, fcvt.wu.s, 0x01,          1,  1.1, rtz);
  TEST_FP_INT_OP_S(18, fcvt.wu.s, 0x10,          0, -3e9, rtz);
  TEST_FP_INT_OP_S(19, fcvt.wu.s, 0x00, 3000000000,  3e9, rtz);

  TEST_FP_INT_OP_S(22,  fcvt.l.s, 0x01,         -1, -1.1, rtz);
  TEST_FP_INT_OP_S(23,  fcvt.l.s, 0x00,         -1, -1.0, rtz);
  TEST_FP_INT_OP_S(24,  fcvt.l.s, 0x01,          0, -0.9, rtz);
  TEST_FP_INT_OP_S(25,  fcvt.l.s, 0x01,          0,  0.9, rtz);
  TEST_FP_INT_OP_S(26,  fcvt.l.s, 0x00,          1,  1.0, rtz);
  TEST_FP_INT_OP_S(27,  fcvt.l.s, 0x01,          1,  1.1, rtz);

  TEST_FP_INT_OP_S(32, fcvt.lu.s, 0x10,          0, -3.0, rtz);
  TEST_FP_INT_OP_S(33, fcvt.lu.s, 0x10,          0, -1.0, rtz);
  TEST_FP_INT_OP_S(34, fcvt.lu.s, 0x01,          0, -0.9, rtz);
  TEST_FP_INT_OP_S(35, fcvt.lu.s, 0x01,          0,  0.9, rtz);
  TEST_FP_INT_OP_S(36, fcvt.lu.s, 0x00,          1,  1.0, rtz);
  TEST_FP_INT_OP_S(37, fcvt.lu.s, 0x01,          1,  1.1, rtz);
  TEST_FP_INT_OP_S(38, fcvt.lu.s, 0x10,          0, -3e9, rtz);

  TEST_FP_INT_OP_D(42,  fcvt.w.d, 0x01,         -1, -1.1, rtz);
  TEST_FP_INT_OP_D(43,  fcvt.w.d, 0x00,         -1, -1.0, rtz);
  TEST_FP_INT_OP_D(44,  fcvt.w.d, 0x01,          0, -0.9, rtz);
  TEST_FP_INT_OP_D(45,  fcvt.w.d, 0x01,          0,  0.9, rtz);
  TEST_FP_INT_OP_D(46,  fcvt.w.d, 0x00,          1,  1.0, rtz);
  TEST_FP_INT_OP_D(47,  fcvt.w.d, 0x01,          1,  1.1, rtz);
  TEST_FP_INT_OP_D(48,  fcvt.w.d, 0x10,     -1<<31, -3e9, rtz);
  TEST_FP_INT_OP_D(49,  fcvt.w.d, 0x10,  (1<<31)-1,  3e9, rtz);

  TEST_FP_INT_OP_D(52, fcvt.wu.d, 0x10,          0, -3.0, rtz);
  TEST_FP_INT_OP_D(53, fcvt.wu.d, 0x10,          0, -1.0, rtz);
  TEST_FP_INT_OP_D(54, fcvt.wu.d, 0x01,          0, -0.9, rtz);
  TEST_FP_INT_OP_D(55, fcvt.wu.d, 0x01,          0,  0.9, rtz);
  TEST_FP_INT_OP_D(56, fcvt.wu.d, 0x00,          1,  1.0, rtz);
  TEST_FP_INT_OP_D(57, fcvt.wu.d, 0x01,          1,  1.1, rtz);
  TEST_FP_INT_OP_D(58, fcvt.wu.d, 0x10,          0, -3e9, rtz);
  TEST_FP_INT_OP_D(59, fcvt.wu.d, 0x00, 0xffffffffb2d05e00, 3e9, rtz);

  TEST_FP_INT_OP_D(62,  fcvt.l.d, 0x01,         -1, -1.1, rtz);
  TEST_FP_INT_OP_D(63,  fcvt.l.d, 0x00,         -1, -1.0, rtz);
  TEST_FP_INT_OP_D(64,  fcvt.l.d, 0x01,          0, -0.9, rtz);
  TEST_FP_INT_OP_D(65,  fcvt.l.d, 0x01,          0,  0.9, rtz);
  TEST_FP_INT_OP_D(66,  fcvt.l.d, 0x00,          1,  1.0, rtz);
  TEST_FP_INT_OP_D(67,  fcvt.l.d, 0x01,          1,  1.1, rtz);
  TEST_FP_INT_OP_D(68,  fcvt.l.d, 0x00,-3000000000, -3e9, rtz);
  TEST_FP_INT_OP_D(69,  fcvt.l.d, 0x00, 3000000000,  3e9, rtz);
  TEST_FP_INT_OP_D(60,  fcvt.l.d, 0x10,     -1<<63,-3e19, rtz);
  TEST_FP_INT_OP_D(61,  fcvt.l.d, 0x10,  (1<<63)-1, 3e19, rtz);

  TEST_FP_INT_OP_D(72, fcvt.lu.d, 0x10,          0, -3.0, rtz);
  TEST_FP_INT_OP_D(73, fcvt.lu.d, 0x10,          0, -1.0, rtz);
  TEST_FP_INT_OP_D(74, fcvt.lu.d, 0x01,          0, -0.9, rtz);
  TEST_FP_INT_OP_D(75, fcvt.lu.d, 0x01,          0,  0.9, rtz);
  TEST_FP_INT_OP_D(76, fcvt.lu.d, 0x00,          1,  1.0, rtz);
  TEST_FP_INT_OP_D(77, fcvt.lu.d, 0x01,          1,  1.1, rtz);
  TEST_FP_INT_OP_D(78, fcvt.lu.d, 0x10,          0, -3e9, rtz);
  TEST_FP_INT_OP_D(79, fcvt.lu.d, 0x00, 3000000000,  3e9, rtz);

  # test negative NaN, negative infinity conversion
  TEST_CASE( 80, x1, 0x000000007fffffff, la x1, tdat  ; flw f1,  0(x1); fcvt.w.s x1, f1)
  TEST_CASE( 81, x1, 0x7fffffffffffffff, la x1, tdat  ; flw f1,  0(x1); fcvt.l.s x1, f1)
  TEST_CASE( 82, x1, 0xffffffff80000000, la x1, tdat  ; flw f1,  8(x1); fcvt.w.s x1, f1)
  TEST_CASE( 83, x1, 0x8000000000000000, la x1, tdat  ; flw f1,  8(x1); fcvt.l.s x1, f1)

  TEST_CASE( 84, x1, 0x000000007fffffff, la x1, tdat_d; fld f1,  0(x1); fcvt.w.d x1, f1)
  TEST_CASE( 85, x1, 0x7fffffffffffffff, la x1, tdat_d; fld f1,  0(x1); fcvt.l.d x1, f1)
  TEST_CASE( 86, x1, 0xffffffff80000000, la x1, tdat_d; fld f1, 16(x1); fcvt.w.d x1, f1)
  TEST_CASE( 87, x1, 0x8000000000000000, la x1, tdat_d; fld f1, 16(x1); fcvt.l.d x1, f1)

  # test positive NaN, positive infinity conversion
  TEST_CASE( 88, x1, 0x000000007fffffff, la x1, tdat  ; flw f1,  4(x1); fcvt.w.s x1, f1)
  TEST_CASE( 89, x1, 0x7fffffffffffffff, la x1, tdat  ; flw f1,  4(x1); fcvt.l.s x1, f1)
  TEST_CASE( 90, x1, 0x000000007fffffff, la x1, tdat  ; flw f1, 12(x1); fcvt.w.s x1, f1)
  TEST_CASE( 91, x1, 0x7fffffffffffffff, la x1, tdat  ; flw f1, 12(x1); fcvt.l.s x1, f1)

  TEST_CASE( 92, x1, 0x000000007fffffff, la x1, tdat_d; fld f1,  8(x1); fcvt.w.d x1, f1)
  TEST_CASE( 93, x1, 0x7fffffffffffffff, la x1, tdat_d; fld f1,  8(x1); fcvt.l.d x1, f1)
  TEST_CASE( 94, x1, 0x000000007fffffff, la x1, tdat_d; fld f1, 24(x1); fcvt.w.d x1, f1)
  TEST_CASE( 95, x1, 0x7fffffffffffffff, la x1, tdat_d; fld f1, 24(x1); fcvt.l.d x1, f1)

  # test NaN, infinity conversions to unsigned integer
  TEST_CASE( 96, x1, 0xffffffffffffffff, la x1, tdat  ; flw f1,  0(x1); fcvt.wu.s x1, f1)
  TEST_CASE( 97, x1, 0xffffffffffffffff, la x1, tdat  ; flw f1,  4(x1); fcvt.wu.s x1, f1)
  TEST_CASE( 98, x1,                  0, la x1, tdat  ; flw f1,  8(x1); fcvt.wu.s x1, f1)
  TEST_CASE( 99, x1, 0xffffffffffffffff, la x1, tdat  ; flw f1, 12(x1); fcvt.wu.s x1, f1)
  TEST_CASE(100, x1, 0xffffffffffffffff, la x1, tdat  ; flw f1,  0(x1); fcvt.lu.s x1, f1)
  TEST_CASE(101, x1, 0xffffffffffffffff, la x1, tdat  ; flw f1,  4(x1); fcvt.lu.s x1, f1)
  TEST_CASE(102, x1,                  0, la x1, tdat  ; flw f1,  8(x1); fcvt.lu.s x1, f1)
  TEST_CASE(103, x1, 0xffffffffffffffff, la x1, tdat  ; flw f1, 12(x1); fcvt.lu.s x1, f1)
   
  TEST_CASE(104, x1, 0xffffffffffffffff, la x1, tdat_d; fld f1,  0(x1); fcvt.wu.d x1, f1)
  TEST_CASE(105, x1, 0xffffffffffffffff, la x1, tdat_d; fld f1,  8(x1); fcvt.wu.d x1, f1)
  TEST_CASE(106, x1,                  0, la x1, tdat_d; fld f1, 16(x1); fcvt.wu.d x1, f1)
  TEST_CASE(107, x1, 0xffffffffffffffff, la x1, tdat_d; fld f1, 24(x1); fcvt.wu.d x1, f1)
  TEST_CASE(108, x1, 0xffffffffffffffff, la x1, tdat_d; fld f1,  0(x1); fcvt.lu.d x1, f1)
  TEST_CASE(109, x1, 0xffffffffffffffff, la x1, tdat_d; fld f1,  8(x1); fcvt.lu.d x1, f1)
  TEST_CASE(110, x1,                  0, la x1, tdat_d; fld f1, 16(x1); fcvt.lu.d x1, f1)
  TEST_CASE(111, x1, 0xffffffffffffffff, la x1, tdat_d; fld f1, 24(x1); fcvt.lu.d x1, f1)

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

# -NaN, NaN, -inf, +inf
tdat:
.word 0xffffffff
.word 0x7fffffff
.word 0xff800000
.word 0x7f800000

tdat_d:
.dword 0xffffffffffffffff
.dword 0x7fffffffffffffff
.dword 0xfff0000000000000
.dword 0x7ff0000000000000

RVTEST_DATA_END
