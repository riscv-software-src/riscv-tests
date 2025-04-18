# See LICENSE for license details.

#include "riscv_test.h"
#undef RVTEST_RV64UF
#define RVTEST_RV64UF RVTEST_RV32UF

#include "test_macros.h"
#undef TEST_FP_INT_OP_D
#define TEST_FP_INT_OP_D TEST_FP_INT_OP_D32

#include "../rv64ud/fcvt_w.S"
