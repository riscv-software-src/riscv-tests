#*****************************************************************************
# ipi.S
#-----------------------------------------------------------------------------
#
# Test interprocessor interrupts.
#

#include "riscv_test.h"
#include "test_macros.h"

#undef RVTEST_RV64S
#define RVTEST_RV64S RVTEST_RV32S

#include "../rv64si/ipi.S"
