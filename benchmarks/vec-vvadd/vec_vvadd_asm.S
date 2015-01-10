# See LICENSE for license details.

#*****************************************************************************
# vvadd function (assembly version)
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

#define rVLen   a4

# WARNING: do not write to the s0,...,s9 registers without first saving them to
# the stack.  

#--------------------------------------------------------------------------
# void scalar_vvadd_asm( int n, float a[], float b[], float c[] )
#--------------------------------------------------------------------------

        .text
        .align 2
        .globl scalar_vvadd_asm
        .type  scalar_vvadd_asm,@function

scalar_vvadd_asm:

        # *****   Scalar Example   *****

        beq rN, zero, done    # exit early if n == 0 

loop:
        flw  f2, 0(rA)  
        flw  f3, 0(rB)  
        fadd.s f2, f2, f3
        fsw  f2, 0(rC)  
        addi rN, rN, -1
        addi rA, rA, 4 
        addi rB, rB, 4 
        addi rC, rC, 4 
        bne  rN, zero, loop
done:
        ret

              
#--------------------------------------------------------------------------
# void vt_vvadd_asm( int n, float a[], float b[], float c[] )
#--------------------------------------------------------------------------
              

        # ***** Vector-Thread Example *****

        .globl vt_vvadd_asm
        .type  vt_vvadd_asm,@function

vt_vvadd_asm:

        beq rN, zero, cpdone  
        la a5, vtcode

        # First, configure the vector unit.
        # rd (given vlen), desired vlen, num of x-regs, num of f-regs
        # For vvadd, we do not need to use any x-registers, and only two
        # floating point registers. By using fewer registers, hwacha can give us a longer vector length!
        # But make sure to use registers starting from x0, f0!
        # WARNING: there is a BUG if you tell it you want 0 registers of any type!
        # So here I'm asking for 1 x-register, even though I don't use any of them.
        vvcfgivl rVLen, rN, 1, 2  
                                  

stripmineloop:
        vsetvl rVLen, rN   # set the vector length 
                           # rN is the desired (application) vector length
                           # rVLen is what vector length we were given

        vflw vf0, rA       # vector loads
        vflw vf1, rB  
        vf 0(a5)           # jump to vector-fetch code
        vfsw vf0, rC       # vector store
        
        sub rN, rN, rVLen  # book keeping 
        slli a6, rVLen, 2  # turn num_elements into num_bytes
        add rA, rA, a6 
        add rB, rB, a6 
        add rC, rC, a6 
        bne rN, zero, stripmineloop

cpdone:    
        fence.v.l          # make stores visible to the control processor
        ret

vtcode:
        fadd.s f0, f0, f1   
        stop
        
        # The C code uses a jalr instruction to call this function
        # so we can use a jr to return back to where the function
        # was called.  Also known as "ret", for "return".

        ret
