# See LICENSE for license details.

#*****************************************************************************
# st_ld.S
#-----------------------------------------------------------------------------
#
# Test store and load instructions
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV64U
RVTEST_CODE_BEGIN

  #-------------------------------------------------------------
  # Bypassing Tests
  #-------------------------------------------------------------

  # Test sb and lb (signed byte)
  TEST_ST_LD_BYPASS(2,  lb,  sb, 0xffffffffffffffdd, 0, tdat );
  TEST_ST_LD_BYPASS(3,  lb,  sb, 0xffffffffffffffcd, 1, tdat );
  TEST_ST_LD_BYPASS(4,  lb,  sb, 0xffffffffffffffcc, 2, tdat );
  TEST_ST_LD_BYPASS(5,  lb,  sb, 0xffffffffffffffbc, 3, tdat );
  TEST_ST_LD_BYPASS(6,  lb,  sb, 0xffffffffffffffbb, 4, tdat );
  TEST_ST_LD_BYPASS(7,  lb,  sb, 0xffffffffffffffab, 5, tdat );

  TEST_ST_LD_BYPASS(8,  lb, sb, 0x33, 0, tdat );
  TEST_ST_LD_BYPASS(9,  lb, sb, 0x23, 1, tdat );
  TEST_ST_LD_BYPASS(10, lb, sb, 0x22, 2, tdat );
  TEST_ST_LD_BYPASS(11, lb, sb, 0x12, 3, tdat );
  TEST_ST_LD_BYPASS(12, lb, sb, 0x11, 4, tdat );
  TEST_ST_LD_BYPASS(13, lb, sb, 0x01, 5, tdat );

  # Test sb and lbu (unsigned byte)
  TEST_ST_LD_BYPASS(14, lbu, sb, 0x33, 0, tdat );
  TEST_ST_LD_BYPASS(15, lbu, sb, 0x23, 1, tdat );
  TEST_ST_LD_BYPASS(16, lbu, sb, 0x22, 2, tdat );
  TEST_ST_LD_BYPASS(17, lbu, sb, 0x12, 3, tdat );
  TEST_ST_LD_BYPASS(18, lbu, sb, 0x11, 4, tdat );
  TEST_ST_LD_BYPASS(19, lbu, sb, 0x01, 5, tdat );

  # Test sw and lw (signed word)
  TEST_ST_LD_BYPASS(20, lw, sw, 0xffffffffaabbccdd, 0,  tdat );
  TEST_ST_LD_BYPASS(21, lw, sw, 0xffffffffdaabbccd, 4,  tdat );
  TEST_ST_LD_BYPASS(22, lw, sw, 0xffffffffddaabbcc, 8,  tdat );
  TEST_ST_LD_BYPASS(23, lw, sw, 0xffffffffcddaabbc, 12, tdat );
  TEST_ST_LD_BYPASS(24, lw, sw, 0xffffffffccddaabb, 16, tdat );
  TEST_ST_LD_BYPASS(25, lw, sw, 0xffffffffbccddaab, 20, tdat );

  TEST_ST_LD_BYPASS(26, lw, sw, 0x00112233, 0,  tdat );
  TEST_ST_LD_BYPASS(27, lw, sw, 0x30011223, 4,  tdat );
  TEST_ST_LD_BYPASS(28, lw, sw, 0x33001122, 8,  tdat );
  TEST_ST_LD_BYPASS(29, lw, sw, 0x23300112, 12, tdat );
  TEST_ST_LD_BYPASS(30, lw, sw, 0x22330011, 16, tdat );
  TEST_ST_LD_BYPASS(31, lw, sw, 0x12233001, 20, tdat );

  # Test sh and lh (signed halfword)
  TEST_ST_LD_BYPASS(32, lh, sh, 0xffffffffffffccdd, 0, tdat );
  TEST_ST_LD_BYPASS(33, lh, sh, 0xffffffffffffbccd, 2, tdat );
  TEST_ST_LD_BYPASS(34, lh, sh, 0xffffffffffffbbcc, 4, tdat );
  TEST_ST_LD_BYPASS(35, lh, sh, 0xffffffffffffabbc, 6, tdat );
  TEST_ST_LD_BYPASS(36, lh, sh, 0xffffffffffffaabb, 8, tdat );
  TEST_ST_LD_BYPASS(37, lh, sh, 0xffffffffffffdaab, 10, tdat );

  TEST_ST_LD_BYPASS(38, lh, sh, 0x2233, 0, tdat );
  TEST_ST_LD_BYPASS(39, lh, sh, 0x1223, 2, tdat );
  TEST_ST_LD_BYPASS(40, lh, sh, 0x1122, 4, tdat );
  TEST_ST_LD_BYPASS(41, lh, sh, 0x0112, 6, tdat );
  TEST_ST_LD_BYPASS(42, lh, sh, 0x0011, 8, tdat );
  TEST_ST_LD_BYPASS(43, lh, sh, 0x3001, 10, tdat );

  # Test sh and lhu (unsigned halfword)
  TEST_ST_LD_BYPASS(44, lhu, sh, 0x2233, 0, tdat );
  TEST_ST_LD_BYPASS(45, lhu, sh, 0x1223, 2, tdat );
  TEST_ST_LD_BYPASS(46, lhu, sh, 0x1122, 4, tdat );
  TEST_ST_LD_BYPASS(47, lhu, sh, 0x0112, 6, tdat );
  TEST_ST_LD_BYPASS(48, lhu, sh, 0x0011, 8, tdat );
  TEST_ST_LD_BYPASS(49, lhu, sh, 0x3001, 10, tdat );

  # RV64-specific tests for ld, sd, and lwu
#if __riscv_xlen == 64
  # Test sd and ld (doubleword)
  TEST_ST_LD_BYPASS(50, ld, sd, 0x0011223344556677, 0,  tdat );
  TEST_ST_LD_BYPASS(51, ld, sd, 0x1122334455667788, 8,  tdat );
  TEST_ST_LD_BYPASS(52, ld, sd, 0x2233445566778899, 16, tdat );
  TEST_ST_LD_BYPASS(53, ld, sd, 0xabbccdd, 0,  tdat );
  TEST_ST_LD_BYPASS(54, ld, sd, 0xaabbccd, 8,  tdat );
  TEST_ST_LD_BYPASS(55, ld, sd, 0xdaabbcc, 16, tdat );
  TEST_ST_LD_BYPASS(56, ld, sd, 0xddaabbc, 24, tdat );
  TEST_ST_LD_BYPASS(57, ld, sd, 0xcddaabb, 32, tdat );
  TEST_ST_LD_BYPASS(58, ld, sd, 0xccddaab, 40, tdat );

  TEST_ST_LD_BYPASS(59, ld, sd, 0x00112233, 0,  tdat );
  TEST_ST_LD_BYPASS(60, ld, sd, 0x30011223, 8,  tdat );
  TEST_ST_LD_BYPASS(61, ld, sd, 0x33001122, 16, tdat );
  TEST_ST_LD_BYPASS(62, ld, sd, 0x23300112, 24, tdat );
  TEST_ST_LD_BYPASS(63, ld, sd, 0x22330011, 32, tdat );
  TEST_ST_LD_BYPASS(64, ld, sd, 0x12233001, 40, tdat );

  # Test sw and lwu (unsigned word)
  TEST_ST_LD_BYPASS(65, lwu, sw, 0x00112233, 0,  tdat );
  TEST_ST_LD_BYPASS(66, lwu, sw, 0x33001122, 8,  tdat );
  TEST_ST_LD_BYPASS(67, lwu, sw, 0x30011223, 4,  tdat );
  TEST_ST_LD_BYPASS(68, lwu, sw, 0x23300112, 12, tdat );
  TEST_ST_LD_BYPASS(69, lwu, sw, 0x22330011, 16, tdat );
  TEST_ST_LD_BYPASS(70, lwu, sw, 0x12233001, 20, tdat );
#endif

  li a0, 0xef         # Immediate load for manual store test
  la a1, tdat         # Load address of tdat
  sb a0, 3(a1)        # Store byte at offset 3 of tdat
  lb a2, 3(a1)        # Load byte back for verification

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

tdat:
    .rept 20
    .word 0xdeadbeef
    .endr


RVTEST_DATA_END
