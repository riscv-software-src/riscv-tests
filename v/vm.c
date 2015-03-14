// See LICENSE for license details.

#include <stdint.h>
#include <string.h>
#include <stdio.h>

#include "riscv_test.h"

void trap_entry();
void pop_tf(trapframe_t*);

static void cputchar(int x)
{
  while (swap_csr(tohost, 0x0101000000000000 | (unsigned char)x));
  while (swap_csr(fromhost, 0) == 0);
}

static void cputstring(const char* s)
{
  while(*s)
    cputchar(*s++);
}

static void terminate(int code)
{
  while (swap_csr(tohost, code));
  while (1);
}

#define stringify1(x) #x
#define stringify(x) stringify1(x)
#define assert(x) do { \
  if (x) break; \
  cputstring("Assertion failed: " stringify(x) "\n"); \
  terminate(3); \
} while(0)

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
  assert(addr >= PGSIZE && addr < MAX_TEST_PAGES * PGSIZE);
  addr = addr/PGSIZE*PGSIZE;

  freelist_t* node = &user_mapping[addr/PGSIZE];
  if (node->addr)
  {
    // check referenced and dirty bits
    assert(l3pt[addr/PGSIZE] & PTE_R);
    if (memcmp((void*)addr, (void*)node->addr, PGSIZE)) {
      assert(l3pt[addr/PGSIZE] & PTE_D);
      memcpy((void*)addr, (void*)node->addr, PGSIZE);
    }

    user_mapping[addr/PGSIZE].addr = 0;

    if (freelist_tail == 0)
      freelist_head = freelist_tail = node;
    else
    {
      freelist_tail->next = node;
      freelist_tail = node;
    }
  }
}

void handle_fault(unsigned long addr)
{
  assert(addr >= PGSIZE && addr < MAX_TEST_PAGES * PGSIZE);
  addr = addr/PGSIZE*PGSIZE;

  freelist_t* node = freelist_head;
  assert(node);
  freelist_head = node->next;
  if (freelist_head == freelist_tail)
    freelist_tail = 0;

  l3pt[addr/PGSIZE] = node->addr | PTE_UW | PTE_UR | PTE_UX | PTE_SW | PTE_SR | PTE_SX | PTE_V;
  asm volatile ("sfence.vm");

  assert(user_mapping[addr/PGSIZE].addr == 0);
  user_mapping[addr/PGSIZE] = *node;
  memcpy((void*)node->addr, (void*)addr, PGSIZE);

  __builtin___clear_cache(0,0);
}

static void do_vxcptrestore(long* where)
{
  vsetcfg(where[0]);
  vsetvl(where[1]);

  vxcpthold();

  int idx = 2;
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

static void restore_vector(trapframe_t* tf)
{
  do_vxcptrestore(tf->hwacha_opaque);
}

void handle_trap(trapframe_t* tf)
{
  if (tf->cause == CAUSE_SCALL)
  {
    int n = tf->gpr[10];

    for (long i = 1; i < MAX_TEST_PAGES; i++)
      evict(i*PGSIZE);

    terminate(n);
  }
  else if (tf->cause == CAUSE_FAULT_FETCH)
    handle_fault(tf->epc);
  else if (tf->cause == CAUSE_ILLEGAL_INSTRUCTION)
  {
    assert(tf->epc % 4 == 0);

    int* fssr;
    asm ("jal %0, 1f; fssr x0; 1:" : "=r"(fssr));

    if (*(int*)tf->epc == *fssr)
      terminate(1); // FP test on non-FP hardware.  "succeed."
    else
      assert(!"illegal instruction");
    tf->epc += 4;
  }
  else if (tf->cause == CAUSE_FAULT_LOAD || tf->cause == CAUSE_FAULT_STORE)
    handle_fault(tf->badvaddr);
  else if ((long)tf->cause < 0 && (uint8_t)tf->cause == IRQ_COP)
  {
    if (tf->hwacha_cause == HWACHA_CAUSE_VF_FAULT_FETCH ||
        tf->hwacha_cause == HWACHA_CAUSE_FAULT_LOAD ||
        tf->hwacha_cause == HWACHA_CAUSE_FAULT_STORE)
    {
      long badvaddr = vxcptaux();
      handle_fault(badvaddr);
    }
    else
      assert(!"unexpected interrupt");
  }
  else
    assert(!"unexpected exception");

out:
  if (!(tf->sr & MSTATUS_PRV1) && (tf->sr & MSTATUS_XS))
    restore_vector(tf);
  pop_tf(tf);
}

void vm_boot(long test_addr, long seed)
{
  while (read_csr(hartid) > 0); // only core 0 proceeds

  assert(SIZEOF_TRAPFRAME_T == sizeof(trapframe_t));

  l1pt[0] = (pte_t)l2pt | PTE_V | PTE_T;
  l2pt[0] = (pte_t)l3pt | PTE_V | PTE_T;
  write_csr(sptbr, l1pt);
  set_csr(mstatus, MSTATUS_IE1 | MSTATUS_FS /* | MSTATUS_XS */ | MSTATUS_MPRV);
  clear_csr(mstatus, MSTATUS_VM | MSTATUS_UA | MSTATUS_PRV1);
  set_csr(mstatus, (long)VM_SV43 << __builtin_ctzl(MSTATUS_VM));
  set_csr(mstatus, (long)UA_RV64 << __builtin_ctzl(MSTATUS_UA));

  seed = 1 + (seed % MAX_TEST_PAGES);
  freelist_head = &freelist_nodes[0];
  freelist_tail = &freelist_nodes[MAX_TEST_PAGES-1];
  for (long i = 0; i < MAX_TEST_PAGES; i++)
  {
    freelist_nodes[i].addr = (MAX_TEST_PAGES + seed)*PGSIZE;
    freelist_nodes[i].next = &freelist_nodes[i+1];
    seed = LFSR_NEXT(seed);
  }
  freelist_nodes[MAX_TEST_PAGES-1].next = 0;

  trapframe_t tf;
  memset(&tf, 0, sizeof(tf));
  tf.epc = test_addr;
  pop_tf(&tf);
}

void double_fault()
{
  assert(!"double fault!");
}
