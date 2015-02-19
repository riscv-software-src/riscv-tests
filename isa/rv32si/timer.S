# See LICENSE for license details.

#*****************************************************************************
# timer.S
#-----------------------------------------------------------------------------
#
# Test timer interrupt.
#

#include "riscv_test.h"
#include "test_macros.h"

#undef RVTEST_RV64S
#define RVTEST_RV64S RVTEST_RV32S

#include "../rv64si/timer.S"
