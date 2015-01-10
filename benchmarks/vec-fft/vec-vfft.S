# See LICENSE for license details.

        .text
        .align 2

#include "fft_const.h"

#if defined(FFT_FIXED)
  #define PTR_SHIFT 2
  #define PTR_SIZE  4

  #define DATA_LOAD lw
  #define DATA_STORE sw

  #define FFT_MUL mul
  #define FFT_ADD add
  #define FFT_SUB sub

  #define REG0 x3 
  #define REG1 x4
  #define REG2 x5
  #define REG3 x6
  #define REG4 x7
  #define REG5 x8
#elif defined(FFT_FLOATING)
  #if defined(FP_HALF)
    #define PTR_SHIFT 1
    #define PTR_SIZE  2

    #define DATA_LOAD flh
    #define DATA_STORE fsh

    #define FFT_MUL fmul.h
    #define FFT_ADD fadd.h
    #define FFT_SUB fsub.h
  #elif defined(FP_SINGLE)
    #define PTR_SHIFT 2
    #define PTR_SIZE  4
  
    #define DATA_LOAD flw
    #define DATA_STORE fsw
  
    #define FFT_MUL fmul.s
    #define FFT_ADD fadd.s
    #define FFT_SUB fsub.s
  #elif defined(FP_DOUBLE)
    #define PTR_SHIFT 3
    #define PTR_SIZE  8
  
    #define DATA_LOAD fld
    #define DATA_STORE fsd
  
    #define FFT_MUL fmul.d
    #define FFT_ADD fadd.d
    #define FFT_SUB fsub.d
  #endif

  #define REG0 f0
  #define REG1 f1
  #define REG2 f2
  #define REG3 f3
  #define REG4 f4
  #define REG5 f5
#else
  #error FFT_FIXED or FFT_FLOATING not defined
#endif

        .globl vf_test
vf_test:
        utidx x2
        add x1, x1, x2
        add x1, x1, x1
        stop

        .globl vf_fft_init
vf_fft_init:
# IN:
#   x1: lane start (utidx=0 actually has this pos due to stripmining)
#   x2: bit mask to select FFT block from op idx
#   x3: bit mask to select operand in FFT block from op idx
#   x4: necessary shift to adjust TF appropriately ( REMOVED )
#   x5: half the current FFT size (add to get the second op)
# OUT:
#   x1: Has the first operand pos = (opid & i_x2) << 1 + (opid & i_x3)
#   x2: Has the second operand pos = o_x1 + i_x5
#   x3: Has the twiddle factor pos = (opid & i_x3) << i_x4
        utidx x6
        add x6, x1, x6 # x6 <= opid
        and x2, x2, x6 # x2 <= opid & i_x2
        and x3, x3, x6 # x3 <= opid & i_x3
        slli x2, x2, 1 # x2 <= (opid & i_x2) << 1

        add x1, x2, x3 # x1 is now the proper result
        add x2, x1, x5 # x2 is now the proper result
        sll x3, x3, x4

        stop

        .globl vf_fft_scale
vf_fft_scale:
# IN:
#   x1: Has the first operand pos (reused)
#   x2: Has the second operand pos (reused)
#   x3: Has the twiddle factor pos (reused)
#   x4: Has the tf real ptr
#   x5: Has the tf imag ptr
#   x6: Has the workspace real ptr 
#   x7: Has the workspace imag ptr
#   x8: Has the fixed point shift ( REMOVED )
# OUT:
#   x1: Has the first operand offset = i_x1 << 3
#   x2: Has the second operand offset = i_x2 << 3
#   x3: Has the scale factor real
#   x4: Has the scale factor imag
        # Convert positions into actual memory offsets from table start
        slli x1, x1, PTR_SHIFT # x1 <= i_x1 << 3 (proper result)
        slli x2, x2, PTR_SHIFT # x2 <= i_x2 << 3 (proper result)
        slli x3, x3, PTR_SHIFT # x3 <= i_x3 << 3 (tf offset)

        # Compute memory locations
        add x4, x4, x3 # x4 <= load address for tf real
        add x5, x5, x3 # x5 <= load address for tf imag
        add x6, x6, x2 # x6 <= load address for op2 real
        add x7, x7, x2 # x7 <= load address for op2 imag

        # Actually read memory
        DATA_LOAD REG1, 0(x4) # tf real (a)
        DATA_LOAD REG2, 0(x5) # tf imag (bi)
        DATA_LOAD REG3, 0(x6) # op2 real (c)
        DATA_LOAD REG4, 0(x7) # op2 imag (di)

        # Do the math using 3 multiplies
        FFT_ADD REG0, REG1, REG2 # REG0 <= a + b
        FFT_SUB REG2, REG2, REG1 # REG2 <= b - a
        FFT_MUL REG0, REG0, REG4 # REG0 <= (a+b)d
#ifdef FFT_FIXED
        sra REG0, REG0, REG5 # DO NOT SHIFT FOR FLOATING
#endif
        FFT_MUL REG2, REG2, REG3 # REG2 <= (b-a)c
#ifdef FFT_FIXED
        sra REG2, REG2, REG5 # DO NOT SHIFT FOR FLOATING
#endif
        FFT_ADD REG3, REG3, REG4 # REG3 <= c + d
        FFT_MUL REG4, REG1, REG3 # REG4 <= a(c+d)
#ifdef FFT_FIXED
        sra REG4, REG4, REG5 # DO NOT SHIFT FOR FLOATING
#endif

        # Prepare final result
        FFT_SUB REG0, REG4, REG0 # REG0 <= a(c+d) - (a+b)d (scale real)
        FFT_ADD REG1, REG4, REG2 # REG1 <= a(c+d) + (b-a)c (scale imag)

        stop
/*
        # Four multiply version
        # Do the multiplications (a+bi)(c+di) needs ac ad bc bd
        mul x3, x4, x6 # x3 <= ac 
        mul x4, x4, x7 # x4 <= adi
        mul x6, x5, x6 # x6 <= bc
        mul x5, x5, x7 # x5 <= bdi
        sra x3, x3, x8 # These 4 shifts make sure the fixed pt properly aligned
        sra x4, x4, x8
        sra x5, x5, x8
        sra x6, x6, x8

        # Do the additions (ac - bd) and (bc + ad)
        sub x3, x3, x5 # x3 <= ac - bd (proper result)
        add x4, x4, x6 # x4 <= bc + ad (proper result)
*/

        .globl vf_fft_exec
vf_fft_exec:
# IN:
#   x1: Has the first operand offset (reused)
#   x2: Has the second operand offset (reused)
#   x3: Has the scale factor real (reused)
#   x4: Has the scale factor imag (reused)
#   x5: Has the workspace real ptr 
#   x6: Has the workspace imag ptr
# OUT:
#   x1: Has the first operand offset (carry)
#   x2: Has the second operand offset (carry)
#   x5: Has the first result real
#   x6: Has the first result imag
#   x7: Has the second result real
#   x8: Has the second result imag
        # Compute first operand memory locations
        add x5, x5, x1 # x5 <= load address for op1 real
        add x6, x6, x1 # x6 <= load address for op1 imag

        #actually read memory
        DATA_LOAD REG2, 0(x5) # op1 real
        DATA_LOAD REG3, 0(x6) # op1 imag

        # Do the add/subs (res1=op1+scale), (res2=op1-scale)
        FFT_SUB REG4, REG2, REG0 # res2 real
        FFT_SUB REG5, REG3, REG1 # res2 imag
        FFT_ADD REG2, REG2, REG0 # res1 real
        FFT_ADD REG3, REG3, REG1 # res1 imag

        stop

        .globl vf_fft_store1
vf_fft_store1:
# IN:
#   x1: Has the first operand offset (reused)
#   x2: Has the second operand offset (reused)
#   x3: Has the workspace real ptr
#   x4: Has the workspace imag ptr
#   x5: Has the first result real (reused)
#   x6: Has the first result imag (reused)
#   x7: Has the second result real (reused)
#   x8: Has the second result imag (reused)
# OUT:
#   x2: Has the second operand offset (carry)
#   x7: Has the second result real (carry)
#   x8: Has the second result imag (carry)
        # Compute first result memory locations
        add x3, x3, x1
        add x4, x4, x1

        # actually write memory
        DATA_STORE REG2, 0(x3)
        DATA_STORE REG3, 0(x4)

        stop

        .globl vf_fft_store2
vf_fft_store2:
# IN:
#   x2: Has the second operand offset
#   x3: Has the workspace real ptr
#   x4: Has the workspace imag ptr
#   x7: Has the second result real
#   x8: Has the second result imag
# OUT: (none)
        # Compute second result memory locations
        add x3, x3, x2
        add x4, x4, x2

        # actually write memory
        DATA_STORE REG4, 0(x3)
        DATA_STORE REG5, 0(x4)

        stop
