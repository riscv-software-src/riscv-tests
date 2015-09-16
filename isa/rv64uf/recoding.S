# See LICENSE for license details.

#*****************************************************************************
# recoding.S
#-----------------------------------------------------------------------------
#
# Test corner cases of John Hauser's microarchitectural recoding scheme.
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV64UF
RVTEST_CODE_BEGIN

  # Infinity has a redundant internal form in Rocket.
  # Make sure two different internal infinities compare as equal.
  li TESTNUM, 8
  flw f0, minf, a0
  flw f1, three, a0
  fmul.s f1, f1, f0
  TEST_CASE( 8, a0, 1, feq.s a0, f0, f1)
  TEST_CASE( 9, a0, 1, fle.s a0, f0, f1)
  TEST_CASE(10, a0, 0, flt.s a0, f0, f1)

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

minf: .float -Inf
three: .float 3.0

RVTEST_DATA_END
