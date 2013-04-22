#ifndef _ENV_VIRTUAL_SINGLE_CORE_H
#define _ENV_VIRTUAL_SINGLE_CORE_H

//-----------------------------------------------------------------------
// Begin Macro
//-----------------------------------------------------------------------

#define RVTEST_RV64U                                                    \

#define RVTEST_RV64S                                                    \

#define RVTEST_FP_ENABLE                                                \
  mfpcr t0, cr0;                                                        \
  or    t0, t0, 2;                                                      \
  mtpcr t0, cr0;                                                        \
  mtfsr x0;                                                             \

#define RVTEST_VEC_ENABLE                                               \
  mfpcr t0, cr0;                                                        \
  ori   t0, t0, 4;                                                      \
  mtpcr t0, cr0;                                                        \
  li    t0, 0xff;                                                       \
  mtpcr t0, cr11;                                                       \

#define RVTEST_CODE_BEGIN                                               \
        .text;                                                          \
        .align  13;                                                     \
        .global userstart;                                              \
userstart:                                                              \

//-----------------------------------------------------------------------
// End Macro
//-----------------------------------------------------------------------

#define RVTEST_CODE_END                                                 \

//-----------------------------------------------------------------------
// Pass/Fail Macro
//-----------------------------------------------------------------------

#define RVTEST_PASS li a0, 1; syscall;
#define RVTEST_FAIL sll a0, x28, 1; 1:beqz a0, 1b; or a0, a0, 1; syscall;

//-----------------------------------------------------------------------
// Data Section Macro
//-----------------------------------------------------------------------

#define RVTEST_DATA_BEGIN
#define RVTEST_DATA_END

//#define RVTEST_DATA_BEGIN .align 4; .global begin_signature; begin_signature:
//#define RVTEST_DATA_END .align 4; .global end_signature; end_signature:

//-----------------------------------------------------------------------
// Supervisor mode definitions and macros
//-----------------------------------------------------------------------

#include "pcr.h"

#define vvcfg(nxregs, nfregs) ({ \
          asm volatile ("vvcfg %0,%1" : : "r"(nxregs), "r"(nfregs)); })

#define vsetvl(vl) ({ long __tmp; \
          asm volatile ("vsetvl %0,%1" : "=r"(__tmp) : "r"(vl)); })

#define vcfg(word) ({ vvcfg((word)>>12, (word)>>18); vsetvl((word)); })

#define dword_bit_cmd(dw) ((dw >> 32) & 0x1)
#define dword_bit_cnt(dw) (!dword_bit_cmd(dw))
#define dword_bit_imm1(dw) ((dw >> 35) & 0x1)
#define dword_bit_imm2(dw) ((dw >> 34) & 0x1)
#define dword_bit_pf(dw) ((dw >> 36) & 0x1)

#define fencevl() ({ \
          asm volatile ("fence.v.l" ::: "memory"); })

#define vxcptkill() ({ \
          asm volatile ("vxcptkill"); })

#define vxcpthold() ({ \
          asm volatile ("vxcpthold"); })

#define venqcmd(bits, pf) ({ \
          asm volatile ("venqcmd %0,%1" : : "r"(bits), "r"(pf)); })

#define venqimm1(bits, pf) ({ \
          asm volatile ("venqimm1 %0,%1" : : "r"(bits), "r"(pf)); })

#define venqimm2(bits, pf) ({ \
          asm volatile ("venqimm2 %0,%1" : : "r"(bits), "r"(pf)); })
 
#define venqcnt(bits, pf) ({ \
          asm volatile ("venqcnt %0,%1" :: "r"(bits), "r"(pf)); })

#define MAX_TEST_PAGES 63 // this must be the period of the LFSR below
#define LFSR_NEXT(x) (((((x)^((x)>>1)) & 1) << 5) | ((x) >> 1))

#define PGSHIFT 13
#define PGSIZE (1 << PGSHIFT)

#define SIZEOF_TRAPFRAME_T 1336

#ifndef __ASSEMBLER__


typedef unsigned long pte_t;
#define LEVELS (sizeof(pte_t) == sizeof(uint64_t) ? 3 : 2)
#define PTIDXBITS (PGSHIFT - (sizeof(pte_t) == 8 ? 3 : 2))
#define VPN_BITS (PTIDXBITS * LEVELS)
#define VA_BITS (VPN_BITS + PGSHIFT)
#define PTES_PER_PT (PGSIZE/sizeof(pte_t))

typedef struct
{
  long gpr[32];
  long sr;
  long epc;
  long badvaddr;
  long cause;
  long insn;
  long vecbank;
  long veccfg;
  long evac[128];
} trapframe_t;
#endif

#endif
