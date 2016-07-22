# See LICENSE for license details.

#include "riscv_test.h"
#undef RVTEST_RV64M
#define RVTEST_RV64M RVTEST_RV32M

#undef VM_SV39
#define VM_SV39 VM_SV32

#include "../rv64si/dirty.S"
