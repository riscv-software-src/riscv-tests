# See LICENSE for license details.

#*****************************************************************************
# mcsr.S
#-----------------------------------------------------------------------------
#
# Test various M-mode CSRs.
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV64M
RVTEST_CODE_BEGIN

  # Check that mcpuid reports RV64
  TEST_CASE(2, a0, 0x2, csrr a0, mcpuid; srl a0, a0, 62)

  # Check that mhartid reports 0
  TEST_CASE(3, a0, 0x0, csrr a0, mhartid)

  # Check that mimpid reports UC Berkeley
  TEST_CASE(4, a0, 0x1, csrr a0, mimpid; sll a0, a0, 48; srl a0, a0, 48)

  # Check that mtvec reports DEFAULT_MTVEC
  TEST_CASE(5, a0, DEFAULT_MTVEC, csrr a0, mtvec)

  TEST_PASSFAIL

RVTEST_CODE_END
