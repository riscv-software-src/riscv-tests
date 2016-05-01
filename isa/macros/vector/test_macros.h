// See LICENSE for license details.

#ifndef __TEST_MACROS_VECTOR_H
#define __TEST_MACROS_VECTOR_H

#undef EXTRA_INIT
#define EXTRA_INIT RVTEST_VEC_ENABLE

#-----------------------------------------------------------------------
# Helper macros
#-----------------------------------------------------------------------

#define TEST_CASE( testnum, testreg, correctval, code... ) \
  TEST_CASE_NREG( testnum, 32, 32, testreg, correctval, code )

# We use j fail, because for some cases branches are not enough to jump to fail

#define TEST_CASE_NREG( testnum, nxreg, nfreg, testreg, correctval, code... ) \
test_ ## testnum: \
  vsetcfg nxreg,nfreg; \
  li a3,2048; \
  vsetvl a3,a3; \
1:auipc a0,%pcrel_hi(vtcode ## testnum); \
  vf %pcrel_lo(1b)(a0); \
  la a4,dst; \
  vsd v ## testreg, a4; \
  fence; \
  li a1,correctval; \
  li a2,0; \
  li TESTNUM, testnum; \
test_loop ## testnum: \
  ld a0,0(a4); \
  beq a0,a1,skip ## testnum; \
  j fail; \
skip ## testnum : \
  addi a4,a4,8; \
  addi a2,a2,1; \
  bne a2,a3,test_loop ## testnum; \
  j next ## testnum; \
vtcode ## testnum : \
  code; \
  stop; \
next ## testnum :

# We use a macro hack to simpify code generation for various numbers
# of bubble cycles.

#define TEST_INSERT_NOPS_0
#define TEST_INSERT_NOPS_1  nop; TEST_INSERT_NOPS_0
#define TEST_INSERT_NOPS_2  nop; TEST_INSERT_NOPS_1
#define TEST_INSERT_NOPS_3  nop; TEST_INSERT_NOPS_2
#define TEST_INSERT_NOPS_4  nop; TEST_INSERT_NOPS_3
#define TEST_INSERT_NOPS_5  nop; TEST_INSERT_NOPS_4
#define TEST_INSERT_NOPS_6  nop; TEST_INSERT_NOPS_5
#define TEST_INSERT_NOPS_7  nop; TEST_INSERT_NOPS_6
#define TEST_INSERT_NOPS_8  nop; TEST_INSERT_NOPS_7
#define TEST_INSERT_NOPS_9  nop; TEST_INSERT_NOPS_8
#define TEST_INSERT_NOPS_10 nop; TEST_INSERT_NOPS_9


#-----------------------------------------------------------------------
# RV64UI MACROS
#-----------------------------------------------------------------------

#-----------------------------------------------------------------------
# Tests for instructions with immediate operand
#-----------------------------------------------------------------------

#define SEXT_IMM(x) ((x) | (-(((x) >> 11) & 1) << 11))

#define TEST_IMM_OP( testnum, inst, result, val1, imm ) \
    TEST_CASE_NREG( testnum, 4, 0, x3, result, \
      li  x1, val1; \
      inst x3, x1, SEXT_IMM(imm); \
    )

#define TEST_IMM_SRC1_EQ_DEST( testnum, inst, result, val1, imm ) \
    TEST_CASE_NREG( testnum, 2, 0, x1, result, \
      li  x1, val1; \
      inst x1, x1, SEXT_IMM(imm); \
    )

#define TEST_IMM_DEST_BYPASS( testnum, nop_cycles, inst, result, val1, imm ) \
    TEST_CASE_NREG( testnum, 5, 0, x4, result, \
      li  x1, val1; \
      inst x3, x1, SEXT_IMM(imm); \
      TEST_INSERT_NOPS_ ## nop_cycles \
      addi  x4, x3, 0; \
    )

#define TEST_IMM_SRC1_BYPASS( testnum, nop_cycles, inst, result, val1, imm ) \
    TEST_CASE_NREG( testnum, 4, 0, x3, result, \
      li  x1, val1; \
      TEST_INSERT_NOPS_ ## nop_cycles \
      inst x3, x1, SEXT_IMM(imm); \
    )

#define TEST_IMM_ZEROSRC1( testnum, inst, result, imm ) \
    TEST_CASE_NREG( testnum, 2, 0, x1, result, \
      inst x1, x0, SEXT_IMM(imm); \
    )

#define TEST_IMM_ZERODEST( testnum, inst, val1, imm ) \
    TEST_CASE_NREG( testnum, 2, 0, x0, 0, \
      li  x1, val1; \
      inst x0, x1, SEXT_IMM(imm); \
    )

#-----------------------------------------------------------------------
# Tests for an instruction with register operands
#-----------------------------------------------------------------------

#define TEST_R_OP( testnum, inst, result, val1 ) \
    TEST_CASE_NREG( testnum, 4, 0, x3, result, \
      li  x1, val1; \
      inst x3, x1; \
    )

#define TEST_R_SRC1_EQ_DEST( testnum, inst, result, val1 ) \
    TEST_CASE_NREG( testnum, 2, 0, x1, result, \
      li  x1, val1; \
      inst x1, x1; \
    )

#define TEST_R_DEST_BYPASS( testnum, nop_cycles, inst, result, val1 ) \
    TEST_CASE_NREG( testnum, 5, 0, x4, result, \
      li  x1, val1; \
      inst x3, x1; \
      TEST_INSERT_NOPS_ ## nop_cycles \
      addi  x4, x3, 0; \
    )

#-----------------------------------------------------------------------
# Tests for an instruction with register-register operands
#-----------------------------------------------------------------------

#define TEST_RR_OP( testnum, inst, result, val1, val2 ) \
    TEST_CASE_NREG( testnum, 4, 0, x3, result, \
      li  x1, val1; \
      li  x2, val2; \
      inst x3, x1, x2; \
    )

#define TEST_RR_SRC1_EQ_DEST( testnum, inst, result, val1, val2 ) \
    TEST_CASE_NREG( testnum, 3, 0, x1, result, \
      li  x1, val1; \
      li  x2, val2; \
      inst x1, x1, x2; \
    )

#define TEST_RR_SRC2_EQ_DEST( testnum, inst, result, val1, val2 ) \
    TEST_CASE_NREG( testnum, 3, 0, x2, result, \
      li  x1, val1; \
      li  x2, val2; \
      inst x2, x1, x2; \
    )

#define TEST_RR_SRC12_EQ_DEST( testnum, inst, result, val1 ) \
    TEST_CASE_NREG( testnum, 2, 0, x1, result, \
      li  x1, val1; \
      inst x1, x1, x1; \
    )

#define TEST_RR_DEST_BYPASS( testnum, nop_cycles, inst, result, val1, val2 ) \
    TEST_CASE_NREG( testnum, 5, 0, x4, result, \
      li  x1, val1; \
      li  x2, val2; \
      inst x3, x1, x2; \
      TEST_INSERT_NOPS_ ## nop_cycles \
      addi  x4, x3, 0; \
    )

#define TEST_RR_SRC12_BYPASS( testnum, src1_nops, src2_nops, inst, result, val1, val2 ) \
    TEST_CASE_NREG( testnum, 4, 0, x3, result, \
      li  x1, val1; \
      TEST_INSERT_NOPS_ ## src1_nops \
      li  x2, val2; \
      TEST_INSERT_NOPS_ ## src2_nops \
      inst x3, x1, x2; \
    )

#define TEST_RR_SRC21_BYPASS( testnum, src1_nops, src2_nops, inst, result, val1, val2 ) \
    TEST_CASE_NREG( testnum, 4, 0, x3, result, \
      li  x2, val2; \
      TEST_INSERT_NOPS_ ## src1_nops \
      li  x1, val1; \
      TEST_INSERT_NOPS_ ## src2_nops \
      inst x3, x1, x2; \
    )

#define TEST_RR_ZEROSRC1( testnum, inst, result, val ) \
    TEST_CASE_NREG( testnum, 3, 0, x2, result, \
      li x1, val; \
      inst x2, x0, x1; \
    )

#define TEST_RR_ZEROSRC2( testnum, inst, result, val ) \
    TEST_CASE_NREG( testnum, 3, 0, x2, result, \
      li x1, val; \
      inst x2, x1, x0; \
    )

#define TEST_RR_ZEROSRC12( testnum, inst, result ) \
    TEST_CASE_NREG( testnum, 2, 0, x1, result, \
      inst x1, x0, x0; \
    )

#define TEST_RR_ZERODEST( testnum, inst, val1, val2 ) \
    TEST_CASE_NREG( testnum, 3, 0, x0, 0, \
      li x1, val1; \
      li x2, val2; \
      inst x0, x1, x2; \
    )


#-----------------------------------------------------------------------
# RV64UF MACROS
#-----------------------------------------------------------------------

#-----------------------------------------------------------------------
# Tests floating-point instructions
#-----------------------------------------------------------------------

#define TEST_FP_OP_S_INTERNAL_NREG( testnum, nxreg, nfreg, result, val1, val2, val3, code... ) \
test_ ## testnum: \
  vsetcfg nxreg,nfreg; \
  li a3,2048; \
  vsetvl a3,a3; \
  la  a5, test_ ## testnum ## _data ;\
  vflstw vf0, a5, x0; \
  addi a5,a5,4; \
  vflstw vf1, a5, x0; \
  addi a5,a5,4; \
  vflstw vf2, a5, x0; \
  addi a5,a5,4; \
1:auipc a0,%pcrel_hi(vtcode ## testnum); \
  vf %pcrel_lo(1b)(a0); \
  la a4,dst; \
  vsw vx1, a4; \
  fence; \
  lw  a1, 0(a5); \
  li a2, 0; \
  li TESTNUM, testnum; \
test_loop ## testnum: \
  lw a0,0(a4); \
  beq a0,a1,skip ## testnum; \
  j fail; \
skip ## testnum : \
  addi a4,a4,4; \
  addi a2,a2,1; \
  bne a2,a3,test_loop ## testnum; \
  j 1f; \
vtcode ## testnum : \
  code; \
  stop; \
  .align 2; \
  test_ ## testnum ## _data: \
  .float val1; \
  .float val2; \
  .float val3; \
  .result; \
1:

#define TEST_FP_OP_D_INTERNAL_NREG( testnum, nxreg, nfreg, result, val1, val2, val3, code... ) \
test_ ## testnum: \
  vsetcfg nxreg,nfreg; \
  li a3,2048; \
  vsetvl a3,a3; \
  la  a5, test_ ## testnum ## _data ;\
  vflstd vf0, a5, x0; \
  addi a5,a5,8; \
  vflstd vf1, a5, x0; \
  addi a5,a5,8; \
  vflstd vf2, a5, x0; \
  addi a5,a5,8; \
1:auipc a0,%pcrel_hi(vtcode ## testnum); \
  vf %pcrel_lo(1b)(a0); \
  la a4,dst; \
  vsd vx1, a4; \
  fence; \
  ld  a1, 0(a5); \
  li a2, 0; \
  li TESTNUM, testnum; \
test_loop ## testnum: \
  ld a0,0(a4); \
  beq a0,a1,skip ## testnum; \
  j fail; \
skip ## testnum : \
  addi a4,a4,8; \
  addi a2,a2,1; \
  bne a2,a3,test_loop ## testnum; \
  j 1f; \
vtcode ## testnum : \
  code; \
  stop; \
  .align 3; \
  test_ ## testnum ## _data: \
  .double val1; \
  .double val2; \
  .double val3; \
  .result; \
1:

#define TEST_FCVT_S_D( testnum, result, val1 ) \
  TEST_FP_OP_D_INTERNAL_NREG( testnum, 2, 4, double result, val1, 0.0, 0.0, \
                    fcvt.s.d f3, f0; fcvt.d.s f3, f3; fmv.x.d x1, f3)

#define TEST_FCVT_D_S( testnum, result, val1 ) \
  TEST_FP_OP_S_INTERNAL_NREG( testnum, 2, 4, float result, val1, 0.0, 0.0, \
                    fcvt.d.s f3, f0; fcvt.s.d f3, f3; fmv.x.s x1, f3)

#define TEST_FP_OP2_S( testnum, inst, flags, result, val1, val2 ) \
  TEST_FP_OP_S_INTERNAL_NREG( testnum, 2, 4, float result, val1, val2, 0.0, \
                    inst f3, f0, f1; fmv.x.s x1, f3)

#define TEST_FP_OP2_D( testnum, inst, flags, result, val1, val2 ) \
  TEST_FP_OP_D_INTERNAL_NREG( testnum, 2, 4, double result, val1, val2, 0.0, \
                    inst f3, f0, f1; fmv.x.d x1, f3)

#define TEST_FP_OP3_S( testnum, inst, flags, result, val1, val2, val3 ) \
  TEST_FP_OP_S_INTERNAL_NREG( testnum, 2, 4, float result, val1, val2, val3, \
                    inst f3, f0, f1, f2; fmv.x.s x1, f3)

#define TEST_FP_OP3_D( testnum, inst, flags, result, val1, val2, val3 ) \
  TEST_FP_OP_D_INTERNAL_NREG( testnum, 2, 4, double result, val1, val2, val3, \
                    inst f3, f0, f1, f2; fmv.x.d x1, f3)

#define TEST_FP_INT_OP_S( testnum, inst, flags, result, val1, rm ) \
  TEST_FP_OP_S_INTERNAL_NREG( testnum, 2, 4, word result, val1, 0.0, 0.0, \
                    inst x1, f0, rm)

#define TEST_FP_INT_OP_D( testnum, inst, flags, result, val1, rm ) \
  TEST_FP_OP_D_INTERNAL_NREG( testnum, 2, 4, dword result, val1, 0.0, 0.0, \
                    inst x1, f0, rm)

#define TEST_FP_CMP_OP_S( testnum, inst, result, val1, val2 ) \
  TEST_FP_OP_S_INTERNAL_NREG( testnum, 2, 4, word result, val1, val2, 0.0, \
                    inst x1, f0, f1)

#define TEST_FP_CMP_OP_D( testnum, inst, result, val1, val2 ) \
  TEST_FP_OP_D_INTERNAL_NREG( testnum, 2, 4, dword result, val1, val2, 0.0, \
                    inst x1, f0, f1)

#define TEST_INT_FP_OP_S( testnum, inst, result, val1 ) \
test_ ## testnum: \
  vsetcfg 2,1; \
  li a3,2048; \
  vsetvl a3,a3; \
1:auipc a0,%pcrel_hi(vtcode ## testnum); \
  vf %pcrel_lo(1b)(a0); \
  la a4,dst; \
  vsw vx1, a4; \
  fence; \
  la  a5, test_ ## testnum ## _data ;\
  lw  a1, 0(a5); \
  li a2, 0; \
  li TESTNUM, testnum; \
test_loop ## testnum: \
  lw a0,0(a4); \
  beq a0,a1,skip ## testnum; \
  j fail; \
skip ## testnum : \
  addi a4,a4,4; \
  addi a2,a2,1; \
  bne a2,a3,test_loop ## testnum; \
  j 1f; \
vtcode ## testnum : \
  li x1, val1; \
  inst f0, x1; \
  fmv.x.s x1, f0; \
  stop; \
  .align 2; \
  test_ ## testnum ## _data: \
  .float result; \
1:

#define TEST_INT_FP_OP_D( testnum, inst, result, val1 ) \
test_ ## testnum: \
  vsetcfg 2,1; \
  li a3,2048; \
  vsetvl a3,a3; \
1:auipc a0,%pcrel_hi(vtcode ## testnum); \
  vf %pcrel_lo(1b)(a0); \
  la a4,dst; \
  vsd vx1, a4; \
  fence; \
  la  a5, test_ ## testnum ## _data ;\
  ld  a1, 0(a5); \
  li a2, 0; \
  li TESTNUM, testnum; \
test_loop ## testnum: \
  ld a0,0(a4); \
  beq a0,a1,skip ## testnum; \
  j fail; \
skip ## testnum : \
  addi a4,a4,8; \
  addi a2,a2,1; \
  bne a2,a3,test_loop ## testnum; \
  j 1f; \
vtcode ## testnum : \
  li x1, val1; \
  inst f0, x1; \
  fmv.x.d x1, f0; \
  stop; \
  .align 3; \
  test_ ## testnum ## _data: \
  .double result; \
1:


#-----------------------------------------------------------------------
# RV64UV MACROS
#-----------------------------------------------------------------------

#-----------------------------------------------------------------------
# Test branch instructions
#-----------------------------------------------------------------------

#define TEST_BR2_OP_TAKEN( testnum, inst, val1, val2) \
    TEST_CASE_NREG( testnum, 4, 0, x3, 0, \
      li x1, val1; \
      li x2, val2; \
      add x3, x0, x0; \
      inst x1, x2, 2f; \
      addi x3, x3, 1; \
1:    j 3f; \
      addi x3, x3, 4; \
2:    inst x1, x2, 1b; \
      addi x3, x3, 2; \
3: \
    )

#define TEST_BR2_OP_NOTTAKEN( testnum, inst, val1, val2 ) \
  TEST_CASE_NREG( testnum, 4, 0, x3, 0, \
    li  x1, val1; \
    li  x2, val2; \
    add x3, x0, x0; \
    inst x1, x2, 1f; \
    j 2f; \
1:  addi x3, x3, 1; \
    j 3f; \
2:  inst x1, x2, 1b; \
3: \
                  )

#define TEST_BR2_SRC12_BYPASS( testnum, src1_nops, src2_nops, inst, val1, val2 ) \
  TEST_CASE_NREG( testnum, 6, 0, x3, 0, \
    add x3, x0, x0; \
    li  x4, 0; \
1:  li  x1, val1; \
    TEST_INSERT_NOPS_ ## src1_nops \
    li  x2, val2; \
    TEST_INSERT_NOPS_ ## src2_nops \
    inst x1, x2, 2f; \
    addi  x4, x4, 1; \
    li  x5, 2; \
    bne x4, x5, 1b; \
    j 3f; \
2:  add x3, x3, 1; \
3:  \
  )

#define TEST_BR2_SRC21_BYPASS( testnum, src1_nops, src2_nops, inst, val1, val2 ) \
  TEST_CASE_NREG( testnum, 6, 0, x3, 0, \
    add x3, x0, x0; \
    li  x4, 0; \
1:  li  x2, val2; \
    TEST_INSERT_NOPS_ ## src1_nops \
    li  x1, val1; \
    TEST_INSERT_NOPS_ ## src2_nops \
    inst x1, x2, 2f; \
    addi  x4, x4, 1; \
    li  x5, 2; \
    bne x4, x4, 1b; \
    j 3f; \
2:  add x3, x3, 1; \
3: \
                  )

#define TEST_BR2_DIVERGED_ODD_EVEN( testnum, inst, n, result, code...)   \
  TEST_CASE_NREG( testnum, 5, 0, x3, result, \
    utidx x1; \
    andi x2, x1, 1;\
    add x3, x0, x0; \
    li x4, n; \
1: \
    beq x0, x2, 2f; \
    code; \
    j 3f; \
2: \
    code; \
3: \
    addi x4, x4, -1; \
    bne x4, x0, 1b; \
                  )

#define TEST_BR2_DIVERGED_FULL12( testnum, inst, n, result, code... )    \
  TEST_CASE_NREG( testnum, 5, 0, x3, result, \
    utidx x1; \
    sltiu x2, x1, 1; \
    add x3, x0, x0; \
    li x4, n; \
1: \
    inst x2, x4, 2f; \
    addi x1, x1, -1; \
    sltiu x2, x1, 1; \
    j 1b; \
2: \
    code; \
                 )

#define TEST_BR2_DIVERGED_FULL21( testnum, inst, n, result, code... )    \
  TEST_CASE_NREG( testnum, 5, 0, x3, result, \
    utidx x1; \
    sltiu x2, x1, 1; \
    add x3, x0, x0; \
    li x4, n; \
1: \
    inst x4, x2, 2f; \
    addi x1, x1, -1; \
    sltiu x2, x1, 1; \
    j 1b; \
2: \
    code; \
                 )

#define TEST_CASE_NREG_MEM( testnum, nxreg, nfreg, correctval, code... ) \
test_ ## testnum: \
  vsetcfg nxreg,nfreg; \
  li a3,2048; \
  vsetvl a3,a3; \
1:auipc a0,%pcrel_hi(vtcode ## testnum); \
  vf %pcrel_lo(1b)(a0); \
  la a4,dst; \
  fence; \
  li a1,correctval; \
  li a2,0; \
  li TESTNUM, testnum; \
test_loop ## testnum: \
  ld a0,0(a4); \
  beq a0,a1,skip ## testnum; \
  j fail; \
skip ## testnum : \
  addi a4,a4,8; \
  addi a2,a2,1; \
  bne a2,a3,test_loop ## testnum; \
  j next ## testnum; \
vtcode ## testnum : \
  code; \
  stop; \
next ## testnum :

#define TEST_BR2_DIVERGED_MEM_FULL12( testnum, inst, n) \
  TEST_CASE_NREG_MEM( testnum, 7, 0, 1, \
    utidx x5; \
    slli x5, x5, 3; \
    la x6, dst; \
    add x5, x5, x6; \
    sd x0, 0(x5); \
    utidx x1; \
    sltiu x2, x1, 1; \
    li x4, n; \
1: \
    inst x2, x4, 2f; \
    addi x1, x1, -1; \
    sltiu x2, x1, 1; \
    j 1b; \
2: \
    ld x3, 0(x5); \
    addi x3, x3, 1; \
    sd x3, 0(x5); \
                 )

#define TEST_BR2_DIVERGED_MEM_FULL21( testnum, inst, n) \
  TEST_CASE_NREG_MEM( testnum, 7, 0, 1, \
    utidx x5; \
    slli x5, x5, 3; \
    la x6, dst; \
    add x5, x5, x6; \
    sd x0, 0(x5); \
    utidx x1; \
    sltiu x2, x1, 1; \
    li x4, n; \
1: \
    inst x4, x2, 2f; \
    addi x1, x1, -1; \
    sltiu x2, x1, 1; \
    j 1b; \
2: \
    ld x3, 0(x5); \
    addi x3, x3, 1; \
    sd x3, 0(x5); \
                 )

#-----------------------------------------------------------------------
# Pass and fail code (assumes test num is in TESTNUM)
#-----------------------------------------------------------------------

#define TEST_PASSFAIL \
        bne x0, TESTNUM, pass; \
fail: \
        RVTEST_FAIL; \
pass: \
        RVTEST_PASS \


#-----------------------------------------------------------------------
# Test data section
#-----------------------------------------------------------------------

#define TEST_DATA \
        .data; \
        .align 3; \
dst: \
        .skip 16384; \

#endif
