# See LICENSE for license details.

#*****************************************************************************
# cmplxmult function (assembly version)
#-----------------------------------------------------------------------------


#--------------------------------------------------------------------------
# Headers and Defines
#--------------------------------------------------------------------------
 
# Here are some defines that make writing assembly code easier.

# I'm using the knowledge that rN will be placed in register a0, rA will be
# placed into register a1, etc., based on the calling convention for functions.
 

#define rN      a0
#define rA      a1
#define rB      a2
#define rC      a3

#define rVlen   a6
#define rStride a7

#define rAI t0
#define rBI t1
#define rCI t2

# WARNING: do not write to the s0,...,s9 registers without first saving them to
# the stack.  

#--------------------------------------------------------------------------
# void scalar_cmplxmult_asm( int n, float a[], float b[], float c[] )
#--------------------------------------------------------------------------

        .text
        .align 2
        .globl scalar_cmplxmult_asm
        .type  scalar_cmplxmult_asm,@function

scalar_cmplxmult_asm:

        # *****   Scalar Example   *****

        blez rN, done    # exit early if n < 0 

loop:
      # The following code is a naive implementation...
      # Re-ordering instructions may increase performance, also, 
      # RISC-V supports instrucitons such as the "fmuladd" and "fmulsub".
      # fmsub.s fa2,fa4,fa3,ft1
      # Finally, unrolling and other fun transformations can also provide
      # performance gains.

        flw  f2, 0(rA)  
        flw  f3, 4(rA)  
        flw  f4, 0(rB)  
        flw  f5, 4(rB)  
        fmul.s f6, f2, f4
        fmul.s f7, f3, f5
        fmul.s f8, f3, f4
        fmul.s f9, f2, f5
        fsub.s f10, f6, f7
        fadd.s f11, f8, f9
        fsw  f10, 0(rC)  
        fsw  f11, 4(rC)  
        addi rN, rN, -1
        addi rA, rA, 8 
        addi rB, rB, 8 
        addi rC, rC, 8 
        bne  rN, zero, loop
done:
        ret

 
#--------------------------------------------------------------------------
# void vt_cmplxmult_asm( int n, float a[], float b[], float c[] )
#--------------------------------------------------------------------------
 

        # ***** Vector-Thread Example *****

        .globl vt_cmplxmult_asm
        .type  vt_cmplxmult_asm,@function

        # HINT: because you are dealing with an array of structures, a regular,
        # vanilla vector-load/vector-store won't work here!

vt_cmplxmult_asm:
        
        blez rN, cpdone  
        la a4, vtcode
        li rStride, 8

        vvcfgivl rVlen, rN, 1, 7

stripmineloop:

         # ADD YOUR CODE HERE....
        vsetvl rVlen, rN   # set the vector length
                           # rN is the desired (application) vector length
                           # rVLen is what vector length we were given

        vflstw vf2, rA, rStride       # real number vector load of A
        addi rAI, rA, 4
        vflstw vf4, rB, rStride  # real number vector load of B
        addi rBI, rB, 4
        vflstw vf3, rAI, rStride #imaginary number vector load of A
        vflstw vf5, rBI, rStride #imaginary vector number load of B

        vf 0(a4)           # jump to vector-fetch code

        vfsstw vf0, rC, rStride       # real number vector store C
        addi rCI, rC, 4
        vfsstw vf1, rCI, rStride # imaginary

        slli a5, rVlen, 3
        sub rN, rN, rVlen  # book keeping
        add rA, rA, a5
        add rB, rB, a5
        add rC, rC, a5
        bne rN, zero, stripmineloop
         # Step 0: set the vector length 
         # Step 1: perform your vector loads
         # Step 2: jump to the vector-fetch code to perform the calculation
         # Step 3: perform the vector store
         # Step 4: book keeping, update the pointers, etc.

cpdone:    
        fence.v.l 
        ret

vtcode:
        # ADD YOUR VECTOR-ELEMENT CODE HERE ... 
        fmul.s f0, f2, f4
        fmsub.s f0, f3, f5, f0

        fmul.s f1, f2, f5
        fmadd.s f1, f3, f4, f1
        stop
        
        # The C code uses a jalr instruction to call this function
        # so we can use a jr to return back to where the function
        # was called.  Also known as "ret", for "return".

        ret

