#*****************************************************************************
# csr.S
#-----------------------------------------------------------------------------
#
# Test CSRRx and CSRRxI instructions.
#

#include "riscv_test.h"
#include "test_macros.h"

#undef RVTEST_RV64S
#define RVTEST_RV64S RVTEST_RV32S

#include "../rv64si/csr.S"
