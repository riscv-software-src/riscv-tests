#*****************************************************************************
# vsetvl.S
#-----------------------------------------------------------------------------
#
# Test vsetvl instruction.
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV64U
RVTEST_CODE_BEGIN

  #-------------------------------------------------------------
  # Arithmetic tests
  #-------------------------------------------------------------

  TEST_VSETVL( 2, 0, 0, 0x07, 768, 768 );
  TEST_VSETVL( 3, 0, 0, 0x07, 769, 768 );
  TEST_VSETVL( 4, 0, 0, 0x07, 767, 767 );

  TEST_VSETVL( 5, 0, 0, 0xff, 2048, 2048 );
  TEST_VSETVL( 6, 0, 0, 0xff, 2049, 2048 );
  TEST_VSETVL( 7, 0, 0, 0xff, 2047, 2047 );

  TEST_VSETVL( 8, 1, 0, 0x07, 768, 768 );
  TEST_VSETVL( 9, 1, 0, 0x07, 769, 768 );
  TEST_VSETVL( 10, 1, 0, 0x07, 767, 767 );

  TEST_VSETVL( 11, 1, 0, 0xff, 2048, 2048 );
  TEST_VSETVL( 12, 1, 0, 0xff, 2049, 2048 );
  TEST_VSETVL( 13, 1, 0, 0xff, 2047, 2047 );

  TEST_VSETVL( 14, 2, 0, 0x07, 768, 768 );
  TEST_VSETVL( 15, 2, 0, 0x07, 769, 768 );
  TEST_VSETVL( 16, 2, 0, 0x07, 767, 767 );

  TEST_VSETVL( 17, 2, 0, 0xff, 2048, 2048 );
  TEST_VSETVL( 18, 2, 0, 0xff, 2049, 2048 );
  TEST_VSETVL( 19, 2, 0, 0xff, 2047, 2047 );

  TEST_VSETVL( 20, 3, 0, 0x07, 384, 384 );
  TEST_VSETVL( 21, 3, 0, 0x07, 385, 384 );
  TEST_VSETVL( 22, 3, 0, 0x07, 383, 383 );

  TEST_VSETVL( 23, 3, 0, 0xff, 1024, 1024 );
  TEST_VSETVL( 24, 3, 0, 0xff, 1025, 1024 );
  TEST_VSETVL( 25, 3, 0, 0xff, 1023, 1023 );

  TEST_VSETVL( 26, 4, 0, 0x07, 255, 255 );
  TEST_VSETVL( 27, 4, 0, 0x07, 256, 255 );
  TEST_VSETVL( 28, 4, 0, 0x07, 254, 254 );

  TEST_VSETVL( 29, 4, 0, 0xff, 680, 680 );
  TEST_VSETVL( 30, 4, 0, 0xff, 681, 680 );
  TEST_VSETVL( 31, 4, 0, 0xff, 679, 679 );

  TEST_VSETVL( 32, 5, 0, 0x07, 192, 192 );
  TEST_VSETVL( 33, 5, 0, 0x07, 193, 192 );
  TEST_VSETVL( 34, 5, 0, 0x07, 191, 191 );

  TEST_VSETVL( 35, 5, 0, 0xff, 512, 512 );
  TEST_VSETVL( 36, 5, 0, 0xff, 513, 512 );
  TEST_VSETVL( 37, 5, 0, 0xff, 511, 511 );

  TEST_VSETVL( 38, 6, 0, 0x07, 153, 153 );
  TEST_VSETVL( 39, 6, 0, 0x07, 154, 153 );
  TEST_VSETVL( 40, 6, 0, 0x07, 152, 152 );

  TEST_VSETVL( 41, 6, 0, 0xff, 408, 408 );
  TEST_VSETVL( 42, 6, 0, 0xff, 409, 408 );
  TEST_VSETVL( 43, 6, 0, 0xff, 407, 407 );

  TEST_VSETVL( 44, 7, 0, 0x07, 126, 126 );
  TEST_VSETVL( 45, 7, 0, 0x07, 127, 126 );
  TEST_VSETVL( 46, 7, 0, 0x07, 125, 125 );

  TEST_VSETVL( 47, 7, 0, 0xff, 336, 336 );
  TEST_VSETVL( 48, 7, 0, 0xff, 337, 336 );
  TEST_VSETVL( 49, 7, 0, 0xff, 335, 335 );

  TEST_VSETVL( 50, 8, 0, 0x07, 108, 108 );
  TEST_VSETVL( 51, 8, 0, 0x07, 109, 108 );
  TEST_VSETVL( 52, 8, 0, 0x07, 107, 107 );

  TEST_VSETVL( 53, 8, 0, 0xff, 288, 288 );
  TEST_VSETVL( 54, 8, 0, 0xff, 289, 288 );
  TEST_VSETVL( 55, 8, 0, 0xff, 287, 287 );

  TEST_VSETVL( 56, 9, 0, 0x07, 96, 96 );
  TEST_VSETVL( 57, 9, 0, 0x07, 97, 96 );
  TEST_VSETVL( 58, 9, 0, 0x07, 95, 95 );

  TEST_VSETVL( 59, 9, 0, 0xff, 256, 256 );
  TEST_VSETVL( 60, 9, 0, 0xff, 257, 256 );
  TEST_VSETVL( 61, 9, 0, 0xff, 255, 255 );

  TEST_VSETVL( 62, 10, 0, 0x07, 84, 84 );
  TEST_VSETVL( 63, 10, 0, 0x07, 85, 84 );
  TEST_VSETVL( 64, 10, 0, 0x07, 83, 83 );

  TEST_VSETVL( 65, 10, 0, 0xff, 224, 224 );
  TEST_VSETVL( 66, 10, 0, 0xff, 225, 224 );
  TEST_VSETVL( 67, 10, 0, 0xff, 223, 223 );

  TEST_VSETVL( 68, 11, 0, 0x07, 75, 75 );
  TEST_VSETVL( 69, 11, 0, 0x07, 76, 75 );
  TEST_VSETVL( 70, 11, 0, 0x07, 74, 74 );

  TEST_VSETVL( 71, 11, 0, 0xff, 200, 200 );
  TEST_VSETVL( 72, 11, 0, 0xff, 201, 200 );
  TEST_VSETVL( 73, 11, 0, 0xff, 199, 199 );

  TEST_VSETVL( 74, 12, 0, 0x07, 69, 69 );
  TEST_VSETVL( 75, 12, 0, 0x07, 70, 69 );
  TEST_VSETVL( 76, 12, 0, 0x07, 68, 68 );

  TEST_VSETVL( 77, 12, 0, 0xff, 184, 184 );
  TEST_VSETVL( 78, 12, 0, 0xff, 185, 184 );
  TEST_VSETVL( 79, 12, 0, 0xff, 183, 183 );

  TEST_VSETVL( 80, 13, 0, 0x07, 63, 63 );
  TEST_VSETVL( 81, 13, 0, 0x07, 64, 63 );
  TEST_VSETVL( 82, 13, 0, 0x07, 62, 62 );

  TEST_VSETVL( 83, 13, 0, 0xff, 168, 168 );
  TEST_VSETVL( 84, 13, 0, 0xff, 169, 168 );
  TEST_VSETVL( 85, 13, 0, 0xff, 167, 167 );

  TEST_VSETVL( 86, 14, 0, 0x07, 57, 57 );
  TEST_VSETVL( 87, 14, 0, 0x07, 58, 57 );
  TEST_VSETVL( 88, 14, 0, 0x07, 56, 56 );

  TEST_VSETVL( 89, 14, 0, 0xff, 152, 152 );
  TEST_VSETVL( 90, 14, 0, 0xff, 153, 152 );
  TEST_VSETVL( 91, 14, 0, 0xff, 151, 151 );

  TEST_VSETVL( 92, 15, 0, 0x07, 54, 54 );
  TEST_VSETVL( 93, 15, 0, 0x07, 55, 54 );
  TEST_VSETVL( 94, 15, 0, 0x07, 53, 53 );

  TEST_VSETVL( 95, 15, 0, 0xff, 144, 144 );
  TEST_VSETVL( 96, 15, 0, 0xff, 145, 144 );
  TEST_VSETVL( 97, 15, 0, 0xff, 143, 143 );

  TEST_VSETVL( 98, 16, 0, 0x07, 51, 51 );
  TEST_VSETVL( 99, 16, 0, 0x07, 52, 51 );
  TEST_VSETVL( 100, 16, 0, 0x07, 50, 50 );

  TEST_VSETVL( 101, 16, 0, 0xff, 136, 136 );
  TEST_VSETVL( 102, 16, 0, 0xff, 137, 136 );
  TEST_VSETVL( 103, 16, 0, 0xff, 135, 135 );

  TEST_VSETVL( 104, 17, 0, 0x07, 48, 48 );
  TEST_VSETVL( 105, 17, 0, 0x07, 49, 48 );
  TEST_VSETVL( 106, 17, 0, 0x07, 47, 47 );

  TEST_VSETVL( 107, 17, 0, 0xff, 128, 128 );
  TEST_VSETVL( 108, 17, 0, 0xff, 129, 128 );
  TEST_VSETVL( 109, 17, 0, 0xff, 127, 127 );

  TEST_VSETVL( 110, 18, 0, 0x07, 45, 45 );
  TEST_VSETVL( 111, 18, 0, 0x07, 46, 45 );
  TEST_VSETVL( 112, 18, 0, 0x07, 44, 44 );

  TEST_VSETVL( 113, 18, 0, 0xff, 120, 120 );
  TEST_VSETVL( 114, 18, 0, 0xff, 121, 120 );
  TEST_VSETVL( 115, 18, 0, 0xff, 119, 119 );

  TEST_VSETVL( 116, 19, 0, 0x07, 42, 42 );
  TEST_VSETVL( 117, 19, 0, 0x07, 43, 42 );
  TEST_VSETVL( 118, 19, 0, 0x07, 41, 41 );

  TEST_VSETVL( 119, 19, 0, 0xff, 112, 112 );
  TEST_VSETVL( 120, 19, 0, 0xff, 113, 112 );
  TEST_VSETVL( 121, 19, 0, 0xff, 111, 111 );

  TEST_VSETVL( 122, 20, 0, 0x07, 39, 39 );
  TEST_VSETVL( 123, 20, 0, 0x07, 40, 39 );
  TEST_VSETVL( 124, 20, 0, 0x07, 38, 38 );

  TEST_VSETVL( 125, 20, 0, 0xff, 104, 104 );
  TEST_VSETVL( 126, 20, 0, 0xff, 105, 104 );
  TEST_VSETVL( 127, 20, 0, 0xff, 103, 103 );

  TEST_VSETVL( 128, 21, 0, 0x07, 36, 36 );
  TEST_VSETVL( 129, 21, 0, 0x07, 37, 36 );
  TEST_VSETVL( 130, 21, 0, 0x07, 35, 35 );

  TEST_VSETVL( 131, 21, 0, 0xff, 96, 96 );
  TEST_VSETVL( 132, 21, 0, 0xff, 97, 96 );
  TEST_VSETVL( 133, 21, 0, 0xff, 95, 95 );

  TEST_VSETVL( 134, 22, 0, 0x07, 36, 36 );
  TEST_VSETVL( 135, 22, 0, 0x07, 37, 36 );
  TEST_VSETVL( 136, 22, 0, 0x07, 35, 35 );

  TEST_VSETVL( 137, 22, 0, 0xff, 96, 96 );
  TEST_VSETVL( 138, 22, 0, 0xff, 97, 96 );
  TEST_VSETVL( 139, 22, 0, 0xff, 95, 95 );

  TEST_VSETVL( 140, 23, 0, 0x07, 33, 33 );
  TEST_VSETVL( 141, 23, 0, 0x07, 34, 33 );
  TEST_VSETVL( 142, 23, 0, 0x07, 32, 32 );

  TEST_VSETVL( 143, 23, 0, 0xff, 88, 88 );
  TEST_VSETVL( 144, 23, 0, 0xff, 89, 88 );
  TEST_VSETVL( 145, 23, 0, 0xff, 87, 87 );

  TEST_VSETVL( 146, 24, 0, 0x07, 33, 33 );
  TEST_VSETVL( 147, 24, 0, 0x07, 34, 33 );
  TEST_VSETVL( 148, 24, 0, 0x07, 32, 32 );

  TEST_VSETVL( 149, 24, 0, 0xff, 88, 88 );
  TEST_VSETVL( 150, 24, 0, 0xff, 89, 88 );
  TEST_VSETVL( 151, 24, 0, 0xff, 87, 87 );

  TEST_VSETVL( 152, 25, 0, 0x07, 30, 30 );
  TEST_VSETVL( 153, 25, 0, 0x07, 31, 30 );
  TEST_VSETVL( 154, 25, 0, 0x07, 29, 29 );

  TEST_VSETVL( 155, 25, 0, 0xff, 80, 80 );
  TEST_VSETVL( 156, 25, 0, 0xff, 81, 80 );
  TEST_VSETVL( 157, 25, 0, 0xff, 79, 79 );

  TEST_VSETVL( 158, 26, 0, 0x07, 30, 30 );
  TEST_VSETVL( 159, 26, 0, 0x07, 31, 30 );
  TEST_VSETVL( 160, 26, 0, 0x07, 29, 29 );

  TEST_VSETVL( 161, 26, 0, 0xff, 80, 80 );
  TEST_VSETVL( 162, 26, 0, 0xff, 81, 80 );
  TEST_VSETVL( 163, 26, 0, 0xff, 79, 79 );

  TEST_VSETVL( 164, 27, 0, 0x07, 27, 27 );
  TEST_VSETVL( 165, 27, 0, 0x07, 28, 27 );
  TEST_VSETVL( 166, 27, 0, 0x07, 26, 26 );

  TEST_VSETVL( 167, 27, 0, 0xff, 72, 72 );
  TEST_VSETVL( 168, 27, 0, 0xff, 73, 72 );
  TEST_VSETVL( 169, 27, 0, 0xff, 71, 71 );

  TEST_VSETVL( 170, 28, 0, 0x07, 27, 27 );
  TEST_VSETVL( 171, 28, 0, 0x07, 28, 27 );
  TEST_VSETVL( 172, 28, 0, 0x07, 26, 26 );

  TEST_VSETVL( 173, 28, 0, 0xff, 72, 72 );
  TEST_VSETVL( 174, 28, 0, 0xff, 73, 72 );
  TEST_VSETVL( 175, 28, 0, 0xff, 71, 71 );

  TEST_VSETVL( 176, 29, 0, 0x07, 27, 27 );
  TEST_VSETVL( 177, 29, 0, 0x07, 28, 27 );
  TEST_VSETVL( 178, 29, 0, 0x07, 26, 26 );

  TEST_VSETVL( 179, 29, 0, 0xff, 72, 72 );
  TEST_VSETVL( 180, 29, 0, 0xff, 73, 72 );
  TEST_VSETVL( 181, 29, 0, 0xff, 71, 71 );

  TEST_VSETVL( 182, 30, 0, 0x07, 24, 24 );
  TEST_VSETVL( 183, 30, 0, 0x07, 25, 24 );
  TEST_VSETVL( 184, 30, 0, 0x07, 23, 23 );

  TEST_VSETVL( 185, 30, 0, 0xff, 64, 64 );
  TEST_VSETVL( 186, 30, 0, 0xff, 65, 64 );
  TEST_VSETVL( 187, 30, 0, 0xff, 63, 63 );

  TEST_VSETVL( 188, 31, 0, 0x07, 24, 24 );
  TEST_VSETVL( 189, 31, 0, 0x07, 25, 24 );
  TEST_VSETVL( 190, 31, 0, 0x07, 23, 23 );

  TEST_VSETVL( 191, 31, 0, 0xff, 64, 64 );
  TEST_VSETVL( 192, 31, 0, 0xff, 65, 64 );
  TEST_VSETVL( 193, 31, 0, 0xff, 63, 63 );

  TEST_VSETVL( 194, 32, 0, 0x07, 24, 24 );
  TEST_VSETVL( 195, 32, 0, 0x07, 25, 24 );
  TEST_VSETVL( 196, 32, 0, 0x07, 23, 23 );

  TEST_VSETVL( 197, 32, 0, 0xff, 64, 64 );
  TEST_VSETVL( 198, 32, 0, 0xff, 65, 64 );
  TEST_VSETVL( 199, 32, 0, 0xff, 63, 63 );

  TEST_VSETVL( 200, 32, 0, 0x07, 24, 24 );
  TEST_VSETVL( 201, 32, 0, 0x07, 25, 24 );
  TEST_VSETVL( 202, 32, 0, 0x07, 23, 23 );

  TEST_VSETVL( 203, 32, 0, 0xff, 64, 64 );
  TEST_VSETVL( 204, 32, 0, 0xff, 65, 64 );
  TEST_VSETVL( 205, 32, 0, 0xff, 63, 63 );

  TEST_VSETVL( 206, 32, 1, 0x07, 24, 24 );
  TEST_VSETVL( 207, 32, 1, 0x07, 25, 24 );
  TEST_VSETVL( 208, 32, 1, 0x07, 23, 23 );

  TEST_VSETVL( 209, 32, 1, 0xff, 64, 64 );
  TEST_VSETVL( 210, 32, 1, 0xff, 65, 64 );
  TEST_VSETVL( 211, 32, 1, 0xff, 63, 63 );

  TEST_VSETVL( 212, 32, 2, 0x07, 21, 21 );
  TEST_VSETVL( 213, 32, 2, 0x07, 22, 21 );
  TEST_VSETVL( 214, 32, 2, 0x07, 20, 20 );

  TEST_VSETVL( 215, 32, 2, 0xff, 56, 56 );
  TEST_VSETVL( 216, 32, 2, 0xff, 57, 56 );
  TEST_VSETVL( 217, 32, 2, 0xff, 55, 55 );

  TEST_VSETVL( 218, 32, 3, 0x07, 21, 21 );
  TEST_VSETVL( 219, 32, 3, 0x07, 22, 21 );
  TEST_VSETVL( 220, 32, 3, 0x07, 20, 20 );

  TEST_VSETVL( 221, 32, 3, 0xff, 56, 56 );
  TEST_VSETVL( 222, 32, 3, 0xff, 57, 56 );
  TEST_VSETVL( 223, 32, 3, 0xff, 55, 55 );

  TEST_VSETVL( 224, 32, 4, 0x07, 21, 21 );
  TEST_VSETVL( 225, 32, 4, 0x07, 22, 21 );
  TEST_VSETVL( 226, 32, 4, 0x07, 20, 20 );

  TEST_VSETVL( 227, 32, 4, 0xff, 56, 56 );
  TEST_VSETVL( 228, 32, 4, 0xff, 57, 56 );
  TEST_VSETVL( 229, 32, 4, 0xff, 55, 55 );

  TEST_VSETVL( 230, 32, 5, 0x07, 21, 21 );
  TEST_VSETVL( 231, 32, 5, 0x07, 22, 21 );
  TEST_VSETVL( 232, 32, 5, 0x07, 20, 20 );

  TEST_VSETVL( 233, 32, 5, 0xff, 56, 56 );
  TEST_VSETVL( 234, 32, 5, 0xff, 57, 56 );
  TEST_VSETVL( 235, 32, 5, 0xff, 55, 55 );

  TEST_VSETVL( 236, 32, 6, 0x07, 18, 18 );
  TEST_VSETVL( 237, 32, 6, 0x07, 19, 18 );
  TEST_VSETVL( 238, 32, 6, 0x07, 17, 17 );

  TEST_VSETVL( 239, 32, 6, 0xff, 48, 48 );
  TEST_VSETVL( 240, 32, 6, 0xff, 49, 48 );
  TEST_VSETVL( 241, 32, 6, 0xff, 47, 47 );

  TEST_VSETVL( 242, 32, 7, 0x07, 18, 18 );
  TEST_VSETVL( 243, 32, 7, 0x07, 19, 18 );
  TEST_VSETVL( 244, 32, 7, 0x07, 17, 17 );

  TEST_VSETVL( 245, 32, 7, 0xff, 48, 48 );
  TEST_VSETVL( 246, 32, 7, 0xff, 49, 48 );
  TEST_VSETVL( 247, 32, 7, 0xff, 47, 47 );

  TEST_VSETVL( 248, 32, 8, 0x07, 18, 18 );
  TEST_VSETVL( 249, 32, 8, 0x07, 19, 18 );
  TEST_VSETVL( 250, 32, 8, 0x07, 17, 17 );

  TEST_VSETVL( 251, 32, 8, 0xff, 48, 48 );
  TEST_VSETVL( 252, 32, 8, 0xff, 49, 48 );
  TEST_VSETVL( 253, 32, 8, 0xff, 47, 47 );

  TEST_VSETVL( 254, 32, 9, 0x07, 18, 18 );
  TEST_VSETVL( 255, 32, 9, 0x07, 19, 18 );
  TEST_VSETVL( 256, 32, 9, 0x07, 17, 17 );

  TEST_VSETVL( 257, 32, 9, 0xff, 48, 48 );
  TEST_VSETVL( 258, 32, 9, 0xff, 49, 48 );
  TEST_VSETVL( 259, 32, 9, 0xff, 47, 47 );

  TEST_VSETVL( 260, 32, 10, 0x07, 18, 18 );
  TEST_VSETVL( 261, 32, 10, 0x07, 19, 18 );
  TEST_VSETVL( 262, 32, 10, 0x07, 17, 17 );

  TEST_VSETVL( 263, 32, 10, 0xff, 48, 48 );
  TEST_VSETVL( 264, 32, 10, 0xff, 49, 48 );
  TEST_VSETVL( 265, 32, 10, 0xff, 47, 47 );

  TEST_VSETVL( 266, 32, 11, 0x07, 18, 18 );
  TEST_VSETVL( 267, 32, 11, 0x07, 19, 18 );
  TEST_VSETVL( 268, 32, 11, 0x07, 17, 17 );

  TEST_VSETVL( 269, 32, 11, 0xff, 48, 48 );
  TEST_VSETVL( 270, 32, 11, 0xff, 49, 48 );
  TEST_VSETVL( 271, 32, 11, 0xff, 47, 47 );

  TEST_VSETVL( 272, 32, 12, 0x07, 15, 15 );
  TEST_VSETVL( 273, 32, 12, 0x07, 16, 15 );
  TEST_VSETVL( 274, 32, 12, 0x07, 14, 14 );

  TEST_VSETVL( 275, 32, 12, 0xff, 40, 40 );
  TEST_VSETVL( 276, 32, 12, 0xff, 41, 40 );
  TEST_VSETVL( 277, 32, 12, 0xff, 39, 39 );

  TEST_VSETVL( 278, 32, 13, 0x07, 15, 15 );
  TEST_VSETVL( 279, 32, 13, 0x07, 16, 15 );
  TEST_VSETVL( 280, 32, 13, 0x07, 14, 14 );

  TEST_VSETVL( 281, 32, 13, 0xff, 40, 40 );
  TEST_VSETVL( 282, 32, 13, 0xff, 41, 40 );
  TEST_VSETVL( 283, 32, 13, 0xff, 39, 39 );

  TEST_VSETVL( 284, 32, 14, 0x07, 15, 15 );
  TEST_VSETVL( 285, 32, 14, 0x07, 16, 15 );
  TEST_VSETVL( 286, 32, 14, 0x07, 14, 14 );

  TEST_VSETVL( 287, 32, 14, 0xff, 40, 40 );
  TEST_VSETVL( 288, 32, 14, 0xff, 41, 40 );
  TEST_VSETVL( 289, 32, 14, 0xff, 39, 39 );

  TEST_VSETVL( 290, 32, 15, 0x07, 15, 15 );
  TEST_VSETVL( 291, 32, 15, 0x07, 16, 15 );
  TEST_VSETVL( 292, 32, 15, 0x07, 14, 14 );

  TEST_VSETVL( 293, 32, 15, 0xff, 40, 40 );
  TEST_VSETVL( 294, 32, 15, 0xff, 41, 40 );
  TEST_VSETVL( 295, 32, 15, 0xff, 39, 39 );

  TEST_VSETVL( 296, 32, 16, 0x07, 15, 15 );
  TEST_VSETVL( 297, 32, 16, 0x07, 16, 15 );
  TEST_VSETVL( 298, 32, 16, 0x07, 14, 14 );

  TEST_VSETVL( 299, 32, 16, 0xff, 40, 40 );
  TEST_VSETVL( 300, 32, 16, 0xff, 41, 40 );
  TEST_VSETVL( 301, 32, 16, 0xff, 39, 39 );

  TEST_VSETVL( 302, 32, 17, 0x07, 15, 15 );
  TEST_VSETVL( 303, 32, 17, 0x07, 16, 15 );
  TEST_VSETVL( 304, 32, 17, 0x07, 14, 14 );

  TEST_VSETVL( 305, 32, 17, 0xff, 40, 40 );
  TEST_VSETVL( 306, 32, 17, 0xff, 41, 40 );
  TEST_VSETVL( 307, 32, 17, 0xff, 39, 39 );

  TEST_VSETVL( 308, 32, 18, 0x07, 15, 15 );
  TEST_VSETVL( 309, 32, 18, 0x07, 16, 15 );
  TEST_VSETVL( 310, 32, 18, 0x07, 14, 14 );

  TEST_VSETVL( 311, 32, 18, 0xff, 40, 40 );
  TEST_VSETVL( 312, 32, 18, 0xff, 41, 40 );
  TEST_VSETVL( 313, 32, 18, 0xff, 39, 39 );

  TEST_VSETVL( 314, 32, 19, 0x07, 15, 15 );
  TEST_VSETVL( 315, 32, 19, 0x07, 16, 15 );
  TEST_VSETVL( 316, 32, 19, 0x07, 14, 14 );

  TEST_VSETVL( 317, 32, 19, 0xff, 40, 40 );
  TEST_VSETVL( 318, 32, 19, 0xff, 41, 40 );
  TEST_VSETVL( 319, 32, 19, 0xff, 39, 39 );

  TEST_VSETVL( 320, 32, 20, 0x07, 15, 15 );
  TEST_VSETVL( 321, 32, 20, 0x07, 16, 15 );
  TEST_VSETVL( 322, 32, 20, 0x07, 14, 14 );

  TEST_VSETVL( 323, 32, 20, 0xff, 40, 40 );
  TEST_VSETVL( 324, 32, 20, 0xff, 41, 40 );
  TEST_VSETVL( 325, 32, 20, 0xff, 39, 39 );

  TEST_VSETVL( 326, 32, 21, 0x07, 12, 12 );
  TEST_VSETVL( 327, 32, 21, 0x07, 13, 12 );
  TEST_VSETVL( 328, 32, 21, 0x07, 11, 11 );

  TEST_VSETVL( 329, 32, 21, 0xff, 32, 32 );
  TEST_VSETVL( 330, 32, 21, 0xff, 33, 32 );
  TEST_VSETVL( 331, 32, 21, 0xff, 31, 31 );

  TEST_VSETVL( 332, 32, 22, 0x07, 12, 12 );
  TEST_VSETVL( 333, 32, 22, 0x07, 13, 12 );
  TEST_VSETVL( 334, 32, 22, 0x07, 11, 11 );

  TEST_VSETVL( 335, 32, 22, 0xff, 32, 32 );
  TEST_VSETVL( 336, 32, 22, 0xff, 33, 32 );
  TEST_VSETVL( 337, 32, 22, 0xff, 31, 31 );

  TEST_VSETVL( 338, 32, 23, 0x07, 12, 12 );
  TEST_VSETVL( 339, 32, 23, 0x07, 13, 12 );
  TEST_VSETVL( 340, 32, 23, 0x07, 11, 11 );

  TEST_VSETVL( 341, 32, 23, 0xff, 32, 32 );
  TEST_VSETVL( 342, 32, 23, 0xff, 33, 32 );
  TEST_VSETVL( 343, 32, 23, 0xff, 31, 31 );

  TEST_VSETVL( 344, 32, 24, 0x07, 12, 12 );
  TEST_VSETVL( 345, 32, 24, 0x07, 13, 12 );
  TEST_VSETVL( 346, 32, 24, 0x07, 11, 11 );

  TEST_VSETVL( 347, 32, 24, 0xff, 32, 32 );
  TEST_VSETVL( 348, 32, 24, 0xff, 33, 32 );
  TEST_VSETVL( 349, 32, 24, 0xff, 31, 31 );

  TEST_VSETVL( 350, 32, 25, 0x07, 12, 12 );
  TEST_VSETVL( 351, 32, 25, 0x07, 13, 12 );
  TEST_VSETVL( 352, 32, 25, 0x07, 11, 11 );

  TEST_VSETVL( 353, 32, 25, 0xff, 32, 32 );
  TEST_VSETVL( 354, 32, 25, 0xff, 33, 32 );
  TEST_VSETVL( 355, 32, 25, 0xff, 31, 31 );

  TEST_VSETVL( 356, 32, 26, 0x07, 12, 12 );
  TEST_VSETVL( 357, 32, 26, 0x07, 13, 12 );
  TEST_VSETVL( 358, 32, 26, 0x07, 11, 11 );

  TEST_VSETVL( 359, 32, 26, 0xff, 32, 32 );
  TEST_VSETVL( 360, 32, 26, 0xff, 33, 32 );
  TEST_VSETVL( 361, 32, 26, 0xff, 31, 31 );

  TEST_VSETVL( 362, 32, 27, 0x07, 12, 12 );
  TEST_VSETVL( 363, 32, 27, 0x07, 13, 12 );
  TEST_VSETVL( 364, 32, 27, 0x07, 11, 11 );

  TEST_VSETVL( 365, 32, 27, 0xff, 32, 32 );
  TEST_VSETVL( 366, 32, 27, 0xff, 33, 32 );
  TEST_VSETVL( 367, 32, 27, 0xff, 31, 31 );

  TEST_VSETVL( 368, 32, 28, 0x07, 12, 12 );
  TEST_VSETVL( 369, 32, 28, 0x07, 13, 12 );
  TEST_VSETVL( 370, 32, 28, 0x07, 11, 11 );

  TEST_VSETVL( 371, 32, 28, 0xff, 32, 32 );
  TEST_VSETVL( 372, 32, 28, 0xff, 33, 32 );
  TEST_VSETVL( 373, 32, 28, 0xff, 31, 31 );

  TEST_VSETVL( 374, 32, 29, 0x07, 12, 12 );
  TEST_VSETVL( 375, 32, 29, 0x07, 13, 12 );
  TEST_VSETVL( 376, 32, 29, 0x07, 11, 11 );

  TEST_VSETVL( 377, 32, 29, 0xff, 32, 32 );
  TEST_VSETVL( 378, 32, 29, 0xff, 33, 32 );
  TEST_VSETVL( 379, 32, 29, 0xff, 31, 31 );

  TEST_VSETVL( 380, 32, 30, 0x07, 12, 12 );
  TEST_VSETVL( 381, 32, 30, 0x07, 13, 12 );
  TEST_VSETVL( 382, 32, 30, 0x07, 11, 11 );

  TEST_VSETVL( 383, 32, 30, 0xff, 32, 32 );
  TEST_VSETVL( 384, 32, 30, 0xff, 33, 32 );
  TEST_VSETVL( 385, 32, 30, 0xff, 31, 31 );

  TEST_VSETVL( 386, 32, 31, 0x07, 12, 12 );
  TEST_VSETVL( 387, 32, 31, 0x07, 13, 12 );
  TEST_VSETVL( 388, 32, 31, 0x07, 11, 11 );

  TEST_VSETVL( 389, 32, 31, 0xff, 32, 32 );
  TEST_VSETVL( 390, 32, 31, 0xff, 33, 32 );
  TEST_VSETVL( 391, 32, 31, 0xff, 31, 31 );

  TEST_VSETVL( 392, 32, 32, 0x07, 12, 12 );
  TEST_VSETVL( 393, 32, 32, 0x07, 13, 12 );
  TEST_VSETVL( 394, 32, 32, 0x07, 11, 11 );

  TEST_VSETVL( 395, 32, 32, 0xff, 32, 32 );
  TEST_VSETVL( 396, 32, 32, 0xff, 33, 32 );
  TEST_VSETVL( 397, 32, 32, 0xff, 31, 31 );

  #-------------------------------------------------------------
  # Source/Destination tests
  #-------------------------------------------------------------

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END
