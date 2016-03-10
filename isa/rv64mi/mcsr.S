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

  # Check that mcpuid reports the correct XLEN
#ifdef __riscv64
  TEST_CASE(2, a0, 0x2, csrr a0, misa; srl a0, a0, 62)
#else
  TEST_CASE(2, a0, 0x0, csrr a0, misa; srl a0, a0, 30)
#endif

  # Check that mhartid reports 0
  TEST_CASE(3, a0, 0x0, csrr a0, mhartid)

  # Check that reading mimpid, marchid, and mvendorid doesn't cause exceptions
  csrr a0, mimpid
  csrr a0, marchid
  csrr a0, mvendorid

  # Check that mtvec reports DEFAULT_MTVEC
  TEST_CASE(5, a0, DEFAULT_MTVEC, csrr a0, mtvec)

  TEST_PASSFAIL

RVTEST_CODE_END
