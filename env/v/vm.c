#include <stdint.h>
#include <string.h>
#include <stdio.h>

#include "riscv_test.h"

void trap_entry();
void pop_tf(trapframe_t*);

static void cputchar(int x)
{
  while (mtpcr(PCR_TOHOST, 0x0101000000000000 | (unsigned char)x));
}

static void cputstring(const char* s)
{
  while(*s)
    cputchar(*s++);
  cputchar('\n');
}

static void terminate(int code)
{
  while (mtpcr(PCR_TOHOST, code));
  while (1);
}

#define stringify1(x) #x
#define stringify(x) stringify1(x)
#define assert(x) do { \
  if (x) break; \
  cputstring("Assertion failed: " stringify(x)); \
  terminate(3); \
} while(0)

#define RELOC(x) ((typeof(x))((char*)(x) + (PGSIZE*MAX_TEST_PAGES)))

typedef struct { pte_t addr; void* next; } freelist_t;

pte_t l1pt[PTES_PER_PT] __attribute__((aligned(PGSIZE)));
pte_t l2pt[PTES_PER_PT] __attribute__((aligned(PGSIZE)));
pte_t l3pt[PTES_PER_PT] __attribute__((aligned(PGSIZE)));
freelist_t user_mapping[MAX_TEST_PAGES];
freelist_t freelist_nodes[MAX_TEST_PAGES];
freelist_t *freelist_head, *freelist_tail;

void printhex(uint64_t x)
{
  char str[17];
  for (int i = 0; i < 16; i++)
  {
    str[15-i] = (x & 0xF) + ((x & 0xF) < 10 ? '0' : 'a'-10);
    x >>= 4;
  }
  str[16] = 0;

  cputstring(str);
}

void evict(unsigned long addr)
{
  assert(addr >= PGSIZE && addr < RELOC(0L));
  addr = addr/PGSIZE*PGSIZE;

  freelist_t* node = RELOC(&user_mapping[addr/PGSIZE]);
  if (node->addr)
  {
    memcpy((void*)RELOC(addr), (void*)addr, PGSIZE);
    RELOC(&user_mapping[addr/PGSIZE])->addr = 0;

    if (*RELOC(&freelist_tail) == 0)
      *RELOC(&freelist_head) = *RELOC(&freelist_tail) = node;
    else
    {
      (*RELOC(&freelist_tail))->next = node;
      *RELOC(&freelist_tail) = node;
    }
  }
}

void handle_fault(unsigned long addr)
{
  assert(addr >= PGSIZE && addr < RELOC(0L));
  addr = addr/PGSIZE*PGSIZE;

  freelist_t* node = *RELOC(&freelist_head);
  assert(node);
  *RELOC(&freelist_head) = node->next;
  if (*RELOC(&freelist_head) == *RELOC(&freelist_tail))
    *RELOC(&freelist_tail) = 0;

  *RELOC(&l3pt[addr/PGSIZE]) = node->addr | PTE_UW | PTE_UR | PTE_UX | PTE_SW | PTE_SR | PTE_SX | PTE_V;
  mtpcr(PCR_FATC, 0);

  assert(RELOC(&user_mapping[addr/PGSIZE])->addr == 0);
  *RELOC(&user_mapping[addr/PGSIZE]) = *node;
  memcpy((void*)addr, (void*)RELOC(addr), PGSIZE);

  __builtin___clear_cache(0,0);
}

void emulate_vxcptsave(trapframe_t* tf)
{
  long where = tf->gpr[(tf->insn >> 22) & 0x1F];

  asm volatile ("vxcptevac %0" : : "r"(where));
  fencevl();
}

void do_vxcptrestore(long* where)
{
  vxcpthold();

  int idx = 0;
  long dword, cmd, pf;
  int first = 1;

  while (1)
  {
    dword = where[idx++];

    if (dword < 0) break;

    if (dword_bit_cnt(dword))
    {
      venqcnt(dword, pf | (dword_bit_cmd(where[idx]) << 1));
    }
    else
    {
      if (!first)
      {
        venqcmd(cmd, pf);
      }

      first = 0;
      cmd = dword;
      pf = dword_bit_pf(cmd);

      if (dword_bit_imm1(cmd))
      {
        venqimm1(where[idx++], pf);
      }
      if (dword_bit_imm2(cmd))
      {
        venqimm2(where[idx++], pf);
      }
    }
  }
  if (!first)
  {
    venqcmd(cmd, pf);
  }
}

void emulate_vxcptrestore(trapframe_t* tf)
{
  long* where = (long*)tf->gpr[(tf->insn >> 22) & 0x1F];
  vxcptkill();
  //vcfg(tf->veccfg);
  do_vxcptrestore(where);
}

void restore_vector(trapframe_t* tf)
{
  mtpcr(PCR_VECBANK, tf->vecbank);
  //vcfg(tf->veccfg);

  if (mfpcr(PCR_IMPL) == IMPL_ROCKET)
    do_vxcptrestore(tf->evac);
  else
    asm volatile("vxcptrestore %0" : : "r"(tf->evac) : "memory");
}

void handle_trap(trapframe_t* tf)
{
  if (tf->cause == CAUSE_SYSCALL)
  {
    int n = tf->gpr[18];

    for (long i = 1; i < MAX_TEST_PAGES; i++)
      evict(i*PGSIZE);

    terminate(n);
  }
  else if (tf->cause == CAUSE_FAULT_FETCH)
    handle_fault(tf->epc);
  else if (tf->cause == CAUSE_ILLEGAL_INSTRUCTION)
  {
    int fssr;
    asm ("la %0, 1f; lw %0, 0(%0); b 2f; 1: fssr x0; 2:" : "=r"(fssr));

    if (tf->insn == fssr)
      terminate(1); // FP test on non-FP hardware.  "succeed."
    else if ((tf->insn & 0xF83FFFFF) == 0x37B)
      emulate_vxcptsave(tf);
    else if ((tf->insn & 0xF83FFFFF) == 0x77B)
      emulate_vxcptrestore(tf);
    else
      assert(0);
    tf->epc += 4;
  }
  else if (tf->cause == CAUSE_FAULT_LOAD || tf->cause == CAUSE_FAULT_STORE ||
           tf->cause == CAUSE_VECTOR_FAULT_LOAD || tf->cause == CAUSE_VECTOR_FAULT_STORE ||
           tf->cause == CAUSE_VECTOR_FAULT_FETCH)
    handle_fault(tf->badvaddr);
  else
    assert(0);

out:
#if 0
  if (!(tf->sr & SR_PS) && (tf->sr & SR_EV))
    restore_vector(tf);
#endif
  pop_tf(tf);
}

void vm_boot(long test_addr, long seed)
{
  while (mfpcr(PCR_HARTID) > 0); // only core 0 proceeds

  assert(SIZEOF_TRAPFRAME_T == sizeof(trapframe_t));

  seed = 1 + (seed % MAX_TEST_PAGES);
  freelist_head = RELOC(&freelist_nodes[0]);
  freelist_tail = RELOC(&freelist_nodes[MAX_TEST_PAGES-1]);
  for (long i = 0; i < MAX_TEST_PAGES; i++)
  {
    freelist_nodes[i].addr = (MAX_TEST_PAGES+i)*PGSIZE;
    freelist_nodes[i].next = RELOC(&freelist_nodes[i+1]);
    seed = LFSR_NEXT(seed);
  }
  freelist_nodes[MAX_TEST_PAGES-1].next = 0;

  assert(MAX_TEST_PAGES*2 < PTES_PER_PT);
  l1pt[0] = (pte_t)l2pt | PTE_V | PTE_T;
  l2pt[0] = (pte_t)l3pt | PTE_V | PTE_T;
  for (long i = 0; i < MAX_TEST_PAGES; i++)
    l3pt[i] = l3pt[i+MAX_TEST_PAGES] = (i*PGSIZE) | PTE_SW | PTE_SR | PTE_SX | PTE_V;

  mtpcr(PCR_PTBR, l1pt);
  mtpcr(PCR_SR, mfpcr(PCR_SR) | SR_VM | SR_EF);

  // relocate
  long adjustment = RELOC(0L), tmp;
  mtpcr(PCR_EVEC, (char*)&trap_entry + adjustment);
  asm volatile ("add sp, sp, %1; rdpc %0; addi %0, %0, 16; add %0, %0, %1; jr %0" : "=&r"(tmp) : "r"(adjustment));

  memset(RELOC(&l3pt[0]), 0, MAX_TEST_PAGES*sizeof(pte_t));
  mtpcr(PCR_FATC, 0);

  trapframe_t tf;
  memset(&tf, 0, sizeof(tf));
  tf.sr = SR_EF | SR_EV | SR_S | SR_U64 | SR_S64 | SR_VM;
  tf.epc = test_addr;

  pop_tf(&tf);
}
