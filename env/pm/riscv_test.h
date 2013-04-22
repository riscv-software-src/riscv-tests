#ifndef _ENV_PHYSICAL_MULTI_CORE_H
#define _ENV_PHYSICAL_MULTI_CORE_H

//-----------------------------------------------------------------------
// Begin Macro
//-----------------------------------------------------------------------

#define RVTEST_RV64U                                                    \

#define RVTEST_RV64S                                                    \

#define RVTEST_FP_ENABLE                                                \
  setpcr cr0, 2;                                                        \
  mfpcr a0, cr0;                                                        \
  and   a0, a0, 2;                                                      \
  beqz  a0, 1f;                                                         \
  mtfsr x0;                                                             \
1:

#define RVTEST_VEC_ENABLE                                               \
  mfpcr a0, cr0;                                                        \
  ori   a0, a0, 4;                                                      \
  mtpcr a0, cr0;                                                        \
  li    a0, 0xff;                                                       \
  mtpcr a0, cr18;                                                       \

#define RVTEST_CODE_BEGIN                                               \
        .text;                                                          \
        .align  4;                                                      \
        .global _start;                                                 \
_start:                                                                 \
        RVTEST_FP_ENABLE                                                \
        RVTEST_VEC_ENABLE                                               \

//-----------------------------------------------------------------------
// End Macro
//-----------------------------------------------------------------------

#define RVTEST_CODE_END                                                 \

//-----------------------------------------------------------------------
// Pass/Fail Macro
//-----------------------------------------------------------------------

#define RVTEST_FAIL                                                     \
        fence;                                                          \
        beqz x28, 1f;                                                   \
        sll x28, x28, 1;                                                \
        or x28, x28, 1;                                                 \
        mtpcr x28, cr30;                                                \
1:      b 1b;                                                           \

#define RVTEST_PASS                                                     \
        fence;                                                          \
        li  x1, 1;                                                      \
        mtpcr x1, cr30;                                                 \
1:      b 1b;                                                           \

//-----------------------------------------------------------------------
// Data Section Macro
//-----------------------------------------------------------------------

#define RVTEST_DATA_BEGIN
#define RVTEST_DATA_END

//#define RVTEST_DATA_BEGIN .align 4; .global begin_signature; begin_signature:
//#define RVTEST_DATA_END .align 4; .global end_signature; end_signature:

#endif
