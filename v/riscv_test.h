#ifndef _ENV_VIRTUAL_SINGLE_CORE_H
#define _ENV_VIRTUAL_SINGLE_CORE_H

#include "../p/riscv_test.h"

//-----------------------------------------------------------------------
// Begin Macro
//-----------------------------------------------------------------------

#undef RVTEST_FP_ENABLE
#define RVTEST_FP_ENABLE fssr x0

#undef RVTEST_RV64UV
#define RVTEST_RV64UV                                                   \
	RVTEST_RV64UF

#undef RVTEST_CODE_BEGIN
#define RVTEST_CODE_BEGIN                                               \
        .text;                                                          \
        .align  13;                                                     \
        .global userstart;                                              \
userstart:                                                              \
        init

//-----------------------------------------------------------------------
// Pass/Fail Macro
//-----------------------------------------------------------------------

#undef RVTEST_PASS
#define RVTEST_PASS li a0, 1; scall

#undef RVTEST_FAIL
#define RVTEST_FAIL sll a0, TESTNUM, 1; 1:beqz a0, 1b; or a0, a0, 1; scall;

//-----------------------------------------------------------------------
// Data Section Macro
//-----------------------------------------------------------------------

#undef RVTEST_DATA_BEGIN
#define RVTEST_DATA_BEGIN

#undef RVTEST_DATA_END
#define RVTEST_DATA_END

//-----------------------------------------------------------------------
// Supervisor mode definitions and macros
//-----------------------------------------------------------------------

#define dword_bit_cmd(dw) ((dw >> 32) & 0x1)
#define dword_bit_cnt(dw) (!dword_bit_cmd(dw))
#define dword_bit_imm1(dw) ((dw >> 35) & 0x1)
#define dword_bit_imm2(dw) ((dw >> 34) & 0x1)
#define dword_bit_pf(dw) ((dw >> 36) & 0x1)

#define fence() ({ \
          asm volatile ("fence" ::: "memory"); })

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

#define SIZEOF_TRAPFRAME_T 20776
#define SIZEOF_TRAPFRAME_T_SCALAR 296

#ifndef __ASSEMBLER__

static inline void vsetcfg(long cfg)
{
  asm volatile ("vsetcfg %0" : : "r"(cfg));
}

static inline void vsetvl(long vl)
{
  long __tmp;
  asm volatile ("vsetvl %0,%1" : "=r"(__tmp) : "r"(vl));
}

static inline long vgetcfg()
{
  int cfg;
  asm volatile ("vgetcfg %0" : "=r"(cfg) :);
  return cfg;
}

static inline long vgetvl()
{
  int vl;
  asm volatile ("vgetvl %0" : "=r"(vl) :);
}

static inline long vxcptaux()
{
  long aux;
  asm volatile ("vxcptaux %0" : "=r"(aux) :);
  return aux;
}

static inline long vxcptcause()
{
  long cause;
  asm volatile ("vxcptcause %0" : "=r"(cause) :);
  return cause;
}

static inline void vxcptrestore(long* mem)
{
  asm volatile("vxcptrestore %0" : : "r"(mem) : "memory");
}

static inline void vxcptevac(long* mem)
{
  asm volatile ("vxcptevac %0" : : "r"(mem));
}

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
  long hwacha_cause;
  long hwacha_opaque[2560];
} trapframe_t;
#endif

#endif
