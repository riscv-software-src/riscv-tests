# See LICENSE for license details.

#*****************************************************************************
# vsetcfg.S
#-----------------------------------------------------------------------------
#
# Test vsetcfg instruction without immediates.
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV64UV
RVTEST_CODE_BEGIN

  #-------------------------------------------------------------
  # Arithmetic tests
  #-------------------------------------------------------------

  #TEST_VVCFG( 2, 0, 0, 0xf8, 768, 768 );
  #TEST_VVCFG( 3, 0, 0, 0xf8, 769, 768 );
  #TEST_VVCFG( 4, 0, 0, 0xf8, 767, 767 );

  TEST_VVCFG( 5, 0, 0, 0x00, 2048, 2048 );
  TEST_VVCFG( 6, 0, 0, 0x00, 2049, 2048 );
  TEST_VVCFG( 7, 0, 0, 0x00, 2047, 2047 );

  #TEST_VVCFG( 8, 1, 0, 0xf8, 768, 768 );
  #TEST_VVCFG( 9, 1, 0, 0xf8, 769, 768 );
  #TEST_VVCFG( 10, 1, 0, 0xf8, 767, 767 );

  TEST_VVCFG( 11, 1, 0, 0x00, 2048, 2048 );
  TEST_VVCFG( 12, 1, 0, 0x00, 2049, 2048 );
  TEST_VVCFG( 13, 1, 0, 0x00, 2047, 2047 );

  #TEST_VVCFG( 14, 2, 0, 0xf8, 768, 768 );
  #TEST_VVCFG( 15, 2, 0, 0xf8, 769, 768 );
  #TEST_VVCFG( 16, 2, 0, 0xf8, 767, 767 );

  TEST_VVCFG( 17, 2, 0, 0x00, 2048, 2048 );
  TEST_VVCFG( 18, 2, 0, 0x00, 2049, 2048 );
  TEST_VVCFG( 19, 2, 0, 0x00, 2047, 2047 );

  #TEST_VVCFG( 20, 3, 0, 0xf8, 384, 384 );
  #TEST_VVCFG( 21, 3, 0, 0xf8, 385, 384 );
  #TEST_VVCFG( 22, 3, 0, 0xf8, 383, 383 );

  TEST_VVCFG( 23, 3, 0, 0x00, 1024, 1024 );
  TEST_VVCFG( 24, 3, 0, 0x00, 1025, 1024 );
  TEST_VVCFG( 25, 3, 0, 0x00, 1023, 1023 );

  #TEST_VVCFG( 26, 4, 0, 0xf8, 255, 255 );
  #TEST_VVCFG( 27, 4, 0, 0xf8, 256, 255 );
  #TEST_VVCFG( 28, 4, 0, 0xf8, 254, 254 );

  TEST_VVCFG( 29, 4, 0, 0x00, 680, 680 );
  TEST_VVCFG( 30, 4, 0, 0x00, 681, 680 );
  TEST_VVCFG( 31, 4, 0, 0x00, 679, 679 );

  #TEST_VVCFG( 32, 5, 0, 0xf8, 192, 192 );
  #TEST_VVCFG( 33, 5, 0, 0xf8, 193, 192 );
  #TEST_VVCFG( 34, 5, 0, 0xf8, 191, 191 );

  TEST_VVCFG( 35, 5, 0, 0x00, 512, 512 );
  TEST_VVCFG( 36, 5, 0, 0x00, 513, 512 );
  TEST_VVCFG( 37, 5, 0, 0x00, 511, 511 );

  #TEST_VVCFG( 38, 6, 0, 0xf8, 153, 153 );
  #TEST_VVCFG( 39, 6, 0, 0xf8, 154, 153 );
  #TEST_VVCFG( 40, 6, 0, 0xf8, 152, 152 );

  TEST_VVCFG( 41, 6, 0, 0x00, 408, 408 );
  TEST_VVCFG( 42, 6, 0, 0x00, 409, 408 );
  TEST_VVCFG( 43, 6, 0, 0x00, 407, 407 );

  #TEST_VVCFG( 44, 7, 0, 0xf8, 126, 126 );
  #TEST_VVCFG( 45, 7, 0, 0xf8, 127, 126 );
  #TEST_VVCFG( 46, 7, 0, 0xf8, 125, 125 );

  TEST_VVCFG( 47, 7, 0, 0x00, 336, 336 );
  TEST_VVCFG( 48, 7, 0, 0x00, 337, 336 );
  TEST_VVCFG( 49, 7, 0, 0x00, 335, 335 );

  #TEST_VVCFG( 50, 8, 0, 0xf8, 108, 108 );
  #TEST_VVCFG( 51, 8, 0, 0xf8, 109, 108 );
  #TEST_VVCFG( 52, 8, 0, 0xf8, 107, 107 );

  TEST_VVCFG( 53, 8, 0, 0x00, 288, 288 );
  TEST_VVCFG( 54, 8, 0, 0x00, 289, 288 );
  TEST_VVCFG( 55, 8, 0, 0x00, 287, 287 );

  #TEST_VVCFG( 56, 9, 0, 0xf8, 96, 96 );
  #TEST_VVCFG( 57, 9, 0, 0xf8, 97, 96 );
  #TEST_VVCFG( 58, 9, 0, 0xf8, 95, 95 );

  TEST_VVCFG( 59, 9, 0, 0x00, 256, 256 );
  TEST_VVCFG( 60, 9, 0, 0x00, 257, 256 );
  TEST_VVCFG( 61, 9, 0, 0x00, 255, 255 );

  #TEST_VVCFG( 62, 10, 0, 0xf8, 84, 84 );
  #TEST_VVCFG( 63, 10, 0, 0xf8, 85, 84 );
  #TEST_VVCFG( 64, 10, 0, 0xf8, 83, 83 );

  TEST_VVCFG( 65, 10, 0, 0x00, 224, 224 );
  TEST_VVCFG( 66, 10, 0, 0x00, 225, 224 );
  TEST_VVCFG( 67, 10, 0, 0x00, 223, 223 );

  #TEST_VVCFG( 68, 11, 0, 0xf8, 75, 75 );
  #TEST_VVCFG( 69, 11, 0, 0xf8, 76, 75 );
  #TEST_VVCFG( 70, 11, 0, 0xf8, 74, 74 );

  TEST_VVCFG( 71, 11, 0, 0x00, 200, 200 );
  TEST_VVCFG( 72, 11, 0, 0x00, 201, 200 );
  TEST_VVCFG( 73, 11, 0, 0x00, 199, 199 );

  #TEST_VVCFG( 74, 12, 0, 0xf8, 69, 69 );
  #TEST_VVCFG( 75, 12, 0, 0xf8, 70, 69 );
  #TEST_VVCFG( 76, 12, 0, 0xf8, 68, 68 );

  TEST_VVCFG( 77, 12, 0, 0x00, 184, 184 );
  TEST_VVCFG( 78, 12, 0, 0x00, 185, 184 );
  TEST_VVCFG( 79, 12, 0, 0x00, 183, 183 );

  #TEST_VVCFG( 80, 13, 0, 0xf8, 63, 63 );
  #TEST_VVCFG( 81, 13, 0, 0xf8, 64, 63 );
  #TEST_VVCFG( 82, 13, 0, 0xf8, 62, 62 );

  TEST_VVCFG( 83, 13, 0, 0x00, 168, 168 );
  TEST_VVCFG( 84, 13, 0, 0x00, 169, 168 );
  TEST_VVCFG( 85, 13, 0, 0x00, 167, 167 );

  #TEST_VVCFG( 86, 14, 0, 0xf8, 57, 57 );
  #TEST_VVCFG( 87, 14, 0, 0xf8, 58, 57 );
  #TEST_VVCFG( 88, 14, 0, 0xf8, 56, 56 );

  TEST_VVCFG( 89, 14, 0, 0x00, 152, 152 );
  TEST_VVCFG( 90, 14, 0, 0x00, 153, 152 );
  TEST_VVCFG( 91, 14, 0, 0x00, 151, 151 );

  #TEST_VVCFG( 92, 15, 0, 0xf8, 54, 54 );
  #TEST_VVCFG( 93, 15, 0, 0xf8, 55, 54 );
  #TEST_VVCFG( 94, 15, 0, 0xf8, 53, 53 );

  TEST_VVCFG( 95, 15, 0, 0x00, 144, 144 );
  TEST_VVCFG( 96, 15, 0, 0x00, 145, 144 );
  TEST_VVCFG( 97, 15, 0, 0x00, 143, 143 );

  #TEST_VVCFG( 98, 16, 0, 0xf8, 51, 51 );
  #TEST_VVCFG( 99, 16, 0, 0xf8, 52, 51 );
  #TEST_VVCFG( 100, 16, 0, 0xf8, 50, 50 );

  TEST_VVCFG( 101, 16, 0, 0x00, 136, 136 );
  TEST_VVCFG( 102, 16, 0, 0x00, 137, 136 );
  TEST_VVCFG( 103, 16, 0, 0x00, 135, 135 );

  #TEST_VVCFG( 104, 17, 0, 0xf8, 48, 48 );
  #TEST_VVCFG( 105, 17, 0, 0xf8, 49, 48 );
  #TEST_VVCFG( 106, 17, 0, 0xf8, 47, 47 );

  TEST_VVCFG( 107, 17, 0, 0x00, 128, 128 );
  TEST_VVCFG( 108, 17, 0, 0x00, 129, 128 );
  TEST_VVCFG( 109, 17, 0, 0x00, 127, 127 );

  #TEST_VVCFG( 110, 18, 0, 0xf8, 45, 45 );
  #TEST_VVCFG( 111, 18, 0, 0xf8, 46, 45 );
  #TEST_VVCFG( 112, 18, 0, 0xf8, 44, 44 );

  TEST_VVCFG( 113, 18, 0, 0x00, 120, 120 );
  TEST_VVCFG( 114, 18, 0, 0x00, 121, 120 );
  TEST_VVCFG( 115, 18, 0, 0x00, 119, 119 );

  #TEST_VVCFG( 116, 19, 0, 0xf8, 42, 42 );
  #TEST_VVCFG( 117, 19, 0, 0xf8, 43, 42 );
  #TEST_VVCFG( 118, 19, 0, 0xf8, 41, 41 );

  TEST_VVCFG( 119, 19, 0, 0x00, 112, 112 );
  TEST_VVCFG( 120, 19, 0, 0x00, 113, 112 );
  TEST_VVCFG( 121, 19, 0, 0x00, 111, 111 );

  #TEST_VVCFG( 122, 20, 0, 0xf8, 39, 39 );
  #TEST_VVCFG( 123, 20, 0, 0xf8, 40, 39 );
  #TEST_VVCFG( 124, 20, 0, 0xf8, 38, 38 );

  TEST_VVCFG( 125, 20, 0, 0x00, 104, 104 );
  TEST_VVCFG( 126, 20, 0, 0x00, 105, 104 );
  TEST_VVCFG( 127, 20, 0, 0x00, 103, 103 );

  #TEST_VVCFG( 128, 21, 0, 0xf8, 36, 36 );
  #TEST_VVCFG( 129, 21, 0, 0xf8, 37, 36 );
  #TEST_VVCFG( 130, 21, 0, 0xf8, 35, 35 );

  TEST_VVCFG( 131, 21, 0, 0x00, 96, 96 );
  TEST_VVCFG( 132, 21, 0, 0x00, 97, 96 );
  TEST_VVCFG( 133, 21, 0, 0x00, 95, 95 );

  #TEST_VVCFG( 134, 22, 0, 0xf8, 36, 36 );
  #TEST_VVCFG( 135, 22, 0, 0xf8, 37, 36 );
  #TEST_VVCFG( 136, 22, 0, 0xf8, 35, 35 );

  TEST_VVCFG( 137, 22, 0, 0x00, 96, 96 );
  TEST_VVCFG( 138, 22, 0, 0x00, 97, 96 );
  TEST_VVCFG( 139, 22, 0, 0x00, 95, 95 );

  #TEST_VVCFG( 140, 23, 0, 0xf8, 33, 33 );
  #TEST_VVCFG( 141, 23, 0, 0xf8, 34, 33 );
  #TEST_VVCFG( 142, 23, 0, 0xf8, 32, 32 );

  TEST_VVCFG( 143, 23, 0, 0x00, 88, 88 );
  TEST_VVCFG( 144, 23, 0, 0x00, 89, 88 );
  TEST_VVCFG( 145, 23, 0, 0x00, 87, 87 );

  #TEST_VVCFG( 146, 24, 0, 0xf8, 33, 33 );
  #TEST_VVCFG( 147, 24, 0, 0xf8, 34, 33 );
  #TEST_VVCFG( 148, 24, 0, 0xf8, 32, 32 );

  TEST_VVCFG( 149, 24, 0, 0x00, 88, 88 );
  TEST_VVCFG( 150, 24, 0, 0x00, 89, 88 );
  TEST_VVCFG( 151, 24, 0, 0x00, 87, 87 );

  #TEST_VVCFG( 152, 25, 0, 0xf8, 30, 30 );
  #TEST_VVCFG( 153, 25, 0, 0xf8, 31, 30 );
  #TEST_VVCFG( 154, 25, 0, 0xf8, 29, 29 );

  TEST_VVCFG( 155, 25, 0, 0x00, 80, 80 );
  TEST_VVCFG( 156, 25, 0, 0x00, 81, 80 );
  TEST_VVCFG( 157, 25, 0, 0x00, 79, 79 );

  #TEST_VVCFG( 158, 26, 0, 0xf8, 30, 30 );
  #TEST_VVCFG( 159, 26, 0, 0xf8, 31, 30 );
  #TEST_VVCFG( 160, 26, 0, 0xf8, 29, 29 );

  TEST_VVCFG( 161, 26, 0, 0x00, 80, 80 );
  TEST_VVCFG( 162, 26, 0, 0x00, 81, 80 );
  TEST_VVCFG( 163, 26, 0, 0x00, 79, 79 );

  #TEST_VVCFG( 164, 27, 0, 0xf8, 27, 27 );
  #TEST_VVCFG( 165, 27, 0, 0xf8, 28, 27 );
  #TEST_VVCFG( 166, 27, 0, 0xf8, 26, 26 );

  TEST_VVCFG( 167, 27, 0, 0x00, 72, 72 );
  TEST_VVCFG( 168, 27, 0, 0x00, 73, 72 );
  TEST_VVCFG( 169, 27, 0, 0x00, 71, 71 );

  #TEST_VVCFG( 170, 28, 0, 0xf8, 27, 27 );
  #TEST_VVCFG( 171, 28, 0, 0xf8, 28, 27 );
  #TEST_VVCFG( 172, 28, 0, 0xf8, 26, 26 );

  TEST_VVCFG( 173, 28, 0, 0x00, 72, 72 );
  TEST_VVCFG( 174, 28, 0, 0x00, 73, 72 );
  TEST_VVCFG( 175, 28, 0, 0x00, 71, 71 );

  #TEST_VVCFG( 176, 29, 0, 0xf8, 27, 27 );
  #TEST_VVCFG( 177, 29, 0, 0xf8, 28, 27 );
  #TEST_VVCFG( 178, 29, 0, 0xf8, 26, 26 );

  TEST_VVCFG( 179, 29, 0, 0x00, 72, 72 );
  TEST_VVCFG( 180, 29, 0, 0x00, 73, 72 );
  TEST_VVCFG( 181, 29, 0, 0x00, 71, 71 );

  #TEST_VVCFG( 182, 30, 0, 0xf8, 24, 24 );
  #TEST_VVCFG( 183, 30, 0, 0xf8, 25, 24 );
  #TEST_VVCFG( 184, 30, 0, 0xf8, 23, 23 );

  TEST_VVCFG( 185, 30, 0, 0x00, 64, 64 );
  TEST_VVCFG( 186, 30, 0, 0x00, 65, 64 );
  TEST_VVCFG( 187, 30, 0, 0x00, 63, 63 );

  #TEST_VVCFG( 188, 31, 0, 0xf8, 24, 24 );
  #TEST_VVCFG( 189, 31, 0, 0xf8, 25, 24 );
  #TEST_VVCFG( 190, 31, 0, 0xf8, 23, 23 );

  TEST_VVCFG( 191, 31, 0, 0x00, 64, 64 );
  TEST_VVCFG( 192, 31, 0, 0x00, 65, 64 );
  TEST_VVCFG( 193, 31, 0, 0x00, 63, 63 );

  #TEST_VVCFG( 194, 32, 0, 0xf8, 24, 24 );
  #TEST_VVCFG( 195, 32, 0, 0xf8, 25, 24 );
  #TEST_VVCFG( 196, 32, 0, 0xf8, 23, 23 );

  TEST_VVCFG( 197, 32, 0, 0x00, 64, 64 );
  TEST_VVCFG( 198, 32, 0, 0x00, 65, 64 );
  TEST_VVCFG( 199, 32, 0, 0x00, 63, 63 );

  #TEST_VVCFG( 200, 32, 0, 0xf8, 24, 24 );
  #TEST_VVCFG( 201, 32, 0, 0xf8, 25, 24 );
  #TEST_VVCFG( 202, 32, 0, 0xf8, 23, 23 );

  TEST_VVCFG( 203, 32, 0, 0x00, 64, 64 );
  TEST_VVCFG( 204, 32, 0, 0x00, 65, 64 );
  TEST_VVCFG( 205, 32, 0, 0x00, 63, 63 );

  #TEST_VVCFG( 206, 32, 1, 0xf8, 24, 24 );
  #TEST_VVCFG( 207, 32, 1, 0xf8, 25, 24 );
  #TEST_VVCFG( 208, 32, 1, 0xf8, 23, 23 );

  TEST_VVCFG( 209, 32, 1, 0x00, 64, 64 );
  TEST_VVCFG( 210, 32, 1, 0x00, 65, 64 );
  TEST_VVCFG( 211, 32, 1, 0x00, 63, 63 );

  #TEST_VVCFG( 212, 32, 2, 0xf8, 21, 21 );
  #TEST_VVCFG( 213, 32, 2, 0xf8, 22, 21 );
  #TEST_VVCFG( 214, 32, 2, 0xf8, 20, 20 );

  TEST_VVCFG( 215, 32, 2, 0x00, 56, 56 );
  TEST_VVCFG( 216, 32, 2, 0x00, 57, 56 );
  TEST_VVCFG( 217, 32, 2, 0x00, 55, 55 );

  #TEST_VVCFG( 218, 32, 3, 0xf8, 21, 21 );
  #TEST_VVCFG( 219, 32, 3, 0xf8, 22, 21 );
  #TEST_VVCFG( 220, 32, 3, 0xf8, 20, 20 );

  TEST_VVCFG( 221, 32, 3, 0x00, 56, 56 );
  TEST_VVCFG( 222, 32, 3, 0x00, 57, 56 );
  TEST_VVCFG( 223, 32, 3, 0x00, 55, 55 );

  #TEST_VVCFG( 224, 32, 4, 0xf8, 21, 21 );
  #TEST_VVCFG( 225, 32, 4, 0xf8, 22, 21 );
  #TEST_VVCFG( 226, 32, 4, 0xf8, 20, 20 );

  TEST_VVCFG( 227, 32, 4, 0x00, 56, 56 );
  TEST_VVCFG( 228, 32, 4, 0x00, 57, 56 );
  TEST_VVCFG( 229, 32, 4, 0x00, 55, 55 );

  #TEST_VVCFG( 230, 32, 5, 0xf8, 21, 21 );
  #TEST_VVCFG( 231, 32, 5, 0xf8, 22, 21 );
  #TEST_VVCFG( 232, 32, 5, 0xf8, 20, 20 );

  TEST_VVCFG( 233, 32, 5, 0x00, 56, 56 );
  TEST_VVCFG( 234, 32, 5, 0x00, 57, 56 );
  TEST_VVCFG( 235, 32, 5, 0x00, 55, 55 );

  #TEST_VVCFG( 236, 32, 6, 0xf8, 18, 18 );
  #TEST_VVCFG( 237, 32, 6, 0xf8, 19, 18 );
  #TEST_VVCFG( 238, 32, 6, 0xf8, 17, 17 );

  TEST_VVCFG( 239, 32, 6, 0x00, 48, 48 );
  TEST_VVCFG( 240, 32, 6, 0x00, 49, 48 );
  TEST_VVCFG( 241, 32, 6, 0x00, 47, 47 );

  #TEST_VVCFG( 242, 32, 7, 0xf8, 18, 18 );
  #TEST_VVCFG( 243, 32, 7, 0xf8, 19, 18 );
  #TEST_VVCFG( 244, 32, 7, 0xf8, 17, 17 );

  TEST_VVCFG( 245, 32, 7, 0x00, 48, 48 );
  TEST_VVCFG( 246, 32, 7, 0x00, 49, 48 );
  TEST_VVCFG( 247, 32, 7, 0x00, 47, 47 );

  #TEST_VVCFG( 248, 32, 8, 0xf8, 18, 18 );
  #TEST_VVCFG( 249, 32, 8, 0xf8, 19, 18 );
  #TEST_VVCFG( 250, 32, 8, 0xf8, 17, 17 );

  TEST_VVCFG( 251, 32, 8, 0x00, 48, 48 );
  TEST_VVCFG( 252, 32, 8, 0x00, 49, 48 );
  TEST_VVCFG( 253, 32, 8, 0x00, 47, 47 );

  #TEST_VVCFG( 254, 32, 9, 0xf8, 18, 18 );
  #TEST_VVCFG( 255, 32, 9, 0xf8, 19, 18 );
  #TEST_VVCFG( 256, 32, 9, 0xf8, 17, 17 );

  TEST_VVCFG( 257, 32, 9, 0x00, 48, 48 );
  TEST_VVCFG( 258, 32, 9, 0x00, 49, 48 );
  TEST_VVCFG( 259, 32, 9, 0x00, 47, 47 );

  #TEST_VVCFG( 260, 32, 10, 0xf8, 18, 18 );
  #TEST_VVCFG( 261, 32, 10, 0xf8, 19, 18 );
  #TEST_VVCFG( 262, 32, 10, 0xf8, 17, 17 );

  TEST_VVCFG( 263, 32, 10, 0x00, 48, 48 );
  TEST_VVCFG( 264, 32, 10, 0x00, 49, 48 );
  TEST_VVCFG( 265, 32, 10, 0x00, 47, 47 );

  #TEST_VVCFG( 266, 32, 11, 0xf8, 18, 18 );
  #TEST_VVCFG( 267, 32, 11, 0xf8, 19, 18 );
  #TEST_VVCFG( 268, 32, 11, 0xf8, 17, 17 );

  TEST_VVCFG( 269, 32, 11, 0x00, 48, 48 );
  TEST_VVCFG( 270, 32, 11, 0x00, 49, 48 );
  TEST_VVCFG( 271, 32, 11, 0x00, 47, 47 );

  #TEST_VVCFG( 272, 32, 12, 0xf8, 15, 15 );
  #TEST_VVCFG( 273, 32, 12, 0xf8, 16, 15 );
  #TEST_VVCFG( 274, 32, 12, 0xf8, 14, 14 );

  TEST_VVCFG( 275, 32, 12, 0x00, 40, 40 );
  TEST_VVCFG( 276, 32, 12, 0x00, 41, 40 );
  TEST_VVCFG( 277, 32, 12, 0x00, 39, 39 );

  #TEST_VVCFG( 278, 32, 13, 0xf8, 15, 15 );
  #TEST_VVCFG( 279, 32, 13, 0xf8, 16, 15 );
  #TEST_VVCFG( 280, 32, 13, 0xf8, 14, 14 );

  TEST_VVCFG( 281, 32, 13, 0x00, 40, 40 );
  TEST_VVCFG( 282, 32, 13, 0x00, 41, 40 );
  TEST_VVCFG( 283, 32, 13, 0x00, 39, 39 );

  #TEST_VVCFG( 284, 32, 14, 0xf8, 15, 15 );
  #TEST_VVCFG( 285, 32, 14, 0xf8, 16, 15 );
  #TEST_VVCFG( 286, 32, 14, 0xf8, 14, 14 );

  TEST_VVCFG( 287, 32, 14, 0x00, 40, 40 );
  TEST_VVCFG( 288, 32, 14, 0x00, 41, 40 );
  TEST_VVCFG( 289, 32, 14, 0x00, 39, 39 );

  #TEST_VVCFG( 290, 32, 15, 0xf8, 15, 15 );
  #TEST_VVCFG( 291, 32, 15, 0xf8, 16, 15 );
  #TEST_VVCFG( 292, 32, 15, 0xf8, 14, 14 );

  TEST_VVCFG( 293, 32, 15, 0x00, 40, 40 );
  TEST_VVCFG( 294, 32, 15, 0x00, 41, 40 );
  TEST_VVCFG( 295, 32, 15, 0x00, 39, 39 );

  #TEST_VVCFG( 296, 32, 16, 0xf8, 15, 15 );
  #TEST_VVCFG( 297, 32, 16, 0xf8, 16, 15 );
  #TEST_VVCFG( 298, 32, 16, 0xf8, 14, 14 );

  TEST_VVCFG( 299, 32, 16, 0x00, 40, 40 );
  TEST_VVCFG( 300, 32, 16, 0x00, 41, 40 );
  TEST_VVCFG( 301, 32, 16, 0x00, 39, 39 );

  #TEST_VVCFG( 302, 32, 17, 0xf8, 15, 15 );
  #TEST_VVCFG( 303, 32, 17, 0xf8, 16, 15 );
  #TEST_VVCFG( 304, 32, 17, 0xf8, 14, 14 );

  TEST_VVCFG( 305, 32, 17, 0x00, 40, 40 );
  TEST_VVCFG( 306, 32, 17, 0x00, 41, 40 );
  TEST_VVCFG( 307, 32, 17, 0x00, 39, 39 );

  #TEST_VVCFG( 308, 32, 18, 0xf8, 15, 15 );
  #TEST_VVCFG( 309, 32, 18, 0xf8, 16, 15 );
  #TEST_VVCFG( 310, 32, 18, 0xf8, 14, 14 );

  TEST_VVCFG( 311, 32, 18, 0x00, 40, 40 );
  TEST_VVCFG( 312, 32, 18, 0x00, 41, 40 );
  TEST_VVCFG( 313, 32, 18, 0x00, 39, 39 );

  #TEST_VVCFG( 314, 32, 19, 0xf8, 15, 15 );
  #TEST_VVCFG( 315, 32, 19, 0xf8, 16, 15 );
  #TEST_VVCFG( 316, 32, 19, 0xf8, 14, 14 );

  TEST_VVCFG( 317, 32, 19, 0x00, 40, 40 );
  TEST_VVCFG( 318, 32, 19, 0x00, 41, 40 );
  TEST_VVCFG( 319, 32, 19, 0x00, 39, 39 );

  #TEST_VVCFG( 320, 32, 20, 0xf8, 15, 15 );
  #TEST_VVCFG( 321, 32, 20, 0xf8, 16, 15 );
  #TEST_VVCFG( 322, 32, 20, 0xf8, 14, 14 );

  TEST_VVCFG( 323, 32, 20, 0x00, 40, 40 );
  TEST_VVCFG( 324, 32, 20, 0x00, 41, 40 );
  TEST_VVCFG( 325, 32, 20, 0x00, 39, 39 );

  #TEST_VVCFG( 326, 32, 21, 0xf8, 12, 12 );
  #TEST_VVCFG( 327, 32, 21, 0xf8, 13, 12 );
  #TEST_VVCFG( 328, 32, 21, 0xf8, 11, 11 );

  TEST_VVCFG( 329, 32, 21, 0x00, 32, 32 );
  TEST_VVCFG( 330, 32, 21, 0x00, 33, 32 );
  TEST_VVCFG( 331, 32, 21, 0x00, 31, 31 );

  #TEST_VVCFG( 332, 32, 22, 0xf8, 12, 12 );
  #TEST_VVCFG( 333, 32, 22, 0xf8, 13, 12 );
  #TEST_VVCFG( 334, 32, 22, 0xf8, 11, 11 );

  TEST_VVCFG( 335, 32, 22, 0x00, 32, 32 );
  TEST_VVCFG( 336, 32, 22, 0x00, 33, 32 );
  TEST_VVCFG( 337, 32, 22, 0x00, 31, 31 );

  #TEST_VVCFG( 338, 32, 23, 0xf8, 12, 12 );
  #TEST_VVCFG( 339, 32, 23, 0xf8, 13, 12 );
  #TEST_VVCFG( 340, 32, 23, 0xf8, 11, 11 );

  TEST_VVCFG( 341, 32, 23, 0x00, 32, 32 );
  TEST_VVCFG( 342, 32, 23, 0x00, 33, 32 );
  TEST_VVCFG( 343, 32, 23, 0x00, 31, 31 );

  #TEST_VVCFG( 344, 32, 24, 0xf8, 12, 12 );
  #TEST_VVCFG( 345, 32, 24, 0xf8, 13, 12 );
  #TEST_VVCFG( 346, 32, 24, 0xf8, 11, 11 );

  TEST_VVCFG( 347, 32, 24, 0x00, 32, 32 );
  TEST_VVCFG( 348, 32, 24, 0x00, 33, 32 );
  TEST_VVCFG( 349, 32, 24, 0x00, 31, 31 );

  #TEST_VVCFG( 350, 32, 25, 0xf8, 12, 12 );
  #TEST_VVCFG( 351, 32, 25, 0xf8, 13, 12 );
  #TEST_VVCFG( 352, 32, 25, 0xf8, 11, 11 );

  TEST_VVCFG( 353, 32, 25, 0x00, 32, 32 );
  TEST_VVCFG( 354, 32, 25, 0x00, 33, 32 );
  TEST_VVCFG( 355, 32, 25, 0x00, 31, 31 );

  #TEST_VVCFG( 356, 32, 26, 0xf8, 12, 12 );
  #TEST_VVCFG( 357, 32, 26, 0xf8, 13, 12 );
  #TEST_VVCFG( 358, 32, 26, 0xf8, 11, 11 );

  TEST_VVCFG( 359, 32, 26, 0x00, 32, 32 );
  TEST_VVCFG( 360, 32, 26, 0x00, 33, 32 );
  TEST_VVCFG( 361, 32, 26, 0x00, 31, 31 );

  #TEST_VVCFG( 362, 32, 27, 0xf8, 12, 12 );
  #TEST_VVCFG( 363, 32, 27, 0xf8, 13, 12 );
  #TEST_VVCFG( 364, 32, 27, 0xf8, 11, 11 );

  TEST_VVCFG( 365, 32, 27, 0x00, 32, 32 );
  TEST_VVCFG( 366, 32, 27, 0x00, 33, 32 );
  TEST_VVCFG( 367, 32, 27, 0x00, 31, 31 );

  #TEST_VVCFG( 368, 32, 28, 0xf8, 12, 12 );
  #TEST_VVCFG( 369, 32, 28, 0xf8, 13, 12 );
  #TEST_VVCFG( 370, 32, 28, 0xf8, 11, 11 );

  TEST_VVCFG( 371, 32, 28, 0x00, 32, 32 );
  TEST_VVCFG( 372, 32, 28, 0x00, 33, 32 );
  TEST_VVCFG( 373, 32, 28, 0x00, 31, 31 );

  #TEST_VVCFG( 374, 32, 29, 0xf8, 12, 12 );
  #TEST_VVCFG( 375, 32, 29, 0xf8, 13, 12 );
  #TEST_VVCFG( 376, 32, 29, 0xf8, 11, 11 );

  TEST_VVCFG( 377, 32, 29, 0x00, 32, 32 );
  TEST_VVCFG( 378, 32, 29, 0x00, 33, 32 );
  TEST_VVCFG( 379, 32, 29, 0x00, 31, 31 );

  #TEST_VVCFG( 380, 32, 30, 0xf8, 12, 12 );
  #TEST_VVCFG( 381, 32, 30, 0xf8, 13, 12 );
  #TEST_VVCFG( 382, 32, 30, 0xf8, 11, 11 );

  TEST_VVCFG( 383, 32, 30, 0x00, 32, 32 );
  TEST_VVCFG( 384, 32, 30, 0x00, 33, 32 );
  TEST_VVCFG( 385, 32, 30, 0x00, 31, 31 );

  #TEST_VVCFG( 386, 32, 31, 0xf8, 12, 12 );
  #TEST_VVCFG( 387, 32, 31, 0xf8, 13, 12 );
  #TEST_VVCFG( 388, 32, 31, 0xf8, 11, 11 );

  TEST_VVCFG( 389, 32, 31, 0x00, 32, 32 );
  TEST_VVCFG( 390, 32, 31, 0x00, 33, 32 );
  TEST_VVCFG( 391, 32, 31, 0x00, 31, 31 );

  #TEST_VVCFG( 392, 32, 32, 0xf8, 12, 12 );
  #TEST_VVCFG( 393, 32, 32, 0xf8, 13, 12 );
  #TEST_VVCFG( 394, 32, 32, 0xf8, 11, 11 );

  TEST_VVCFG( 395, 32, 32, 0x00, 32, 32 );
  TEST_VVCFG( 396, 32, 32, 0x00, 33, 32 );
  TEST_VVCFG( 397, 32, 32, 0x00, 31, 31 );

  #-------------------------------------------------------------
  # Source/Destination tests
  #-------------------------------------------------------------

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END
