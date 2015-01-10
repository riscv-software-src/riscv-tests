# See LICENSE for license details.

#*****************************************************************************
# matmul function (assembly version)
#-----------------------------------------------------------------------------


#--------------------------------------------------------------------------
# Headers and Defines
#--------------------------------------------------------------------------

#include "pcr.h"

# Here are some defines that make writing assembly code easier.

# I'm using the knowledge that rLda will be placed in register a0, rA will be
# placed into register a1, etc., based on the calling convention for functions.

#define rN      a0
#define rLda    a0
#define rA      a1
#define rB      a2
#define rC      a3
#define rATmp2  v0
#define rBTmp2  s0

        
# given vector-length
#define rVlen   a7

# address of VT function
#define rVTAddr v1
#define rTemp0  t0

# desired app vector length (number of elements to vectorize)
#define rNum    t1

#define rATemp  t2
#define rBTemp  t3
#define rCTemp  t4
#define rI      t5
#define rJ      s1
#define rK      s2
#define rLda4   a4
#define rK4     a5
#define rI4     a6
        
# WARNING: do not write to the s0,...,s9 registers without first saving them to
# the stack!

#--------------------------------------------------------------------------
# void scalar_matmul_asm( int n, float a[], float b[], float c[] )
#--------------------------------------------------------------------------

        .text
        .align 2
        .globl scalar_matmul_asm
        .type  scalar_matmul_asm,@function

scalar_matmul_asm:

        # *****   Scalar Example   *****

        blez rLda, done    # exit early if lda < 0

        move rJ, zero
loopj:
        move rI, zero
loopi:
        move rK, zero
loopk:
        mul rTemp0, rJ, rLda    # calculate indices... I'm being SUPER naive here:
        add rATemp, rK, rTemp0  #   this could be a lot more clever!
        slli rATemp, rATemp, 2
        add rATemp, rA, rATemp

        mul rTemp0, rK, rLda
        add rBTemp, rI, rTemp0
        slli rBTemp, rBTemp, 2
        add rBTemp, rB, rBTemp

        mul rTemp0, rJ, rLda
        add rCTemp, rI, rTemp0
        slli rCTemp, rCTemp, 2
        add rCTemp, rC, rCTemp

        flw  f2, 0(rATemp)      # again, I'm being very lazy...
                                #   I can lift this out of the inner loop!
        flw  f3, 0(rBTemp)
        flw  f4, 0(rCTemp)
        fmul.s f3, f2, f3
        fadd.s f4, f4, f3
        fsw  f4, 0(rCTemp)
endk:
        addi rK, rK, 1
        blt rK, rLda, loopk
endi:
        addi rI, rI, 1
        blt rI, rLda, loopi
endj:
        addi rJ, rJ, 1
        blt rJ, rLda, loopj
done:
        ret


#--------------------------------------------------------------------------
# void vt_matmul_asm( int n, float a[], float b[], float c[] )
#--------------------------------------------------------------------------


        # ***** Vector-Thread Example *****

        .globl vt_matmul_asm
        .type  vt_matmul_asm,@function

vt_matmul_asm:
        addi sp, sp, -24
        sd s0, 0(sp)
        sd s1, 8(sp)
        sd s2, 16(sp)

        
        # turn on vector unit
        setpcr status, SR_EV

        blez rLda, cpdone    # exit early if lda < 0


        la rVTAddr, vtcode
        slli rLda4, rLda, 2
        
        #for starters ask for all the registers. We shouldn't need this many
        #but we'll trim it when we have correctness in hand
        vvcfgivl rVlen, rNum, 1, 5

        
        move rJ, zero
vec_loopj:
        move rI, zero
vec_loopi:      
        slli rI4, rI, 2
        
        sub rNum, rN, rI  # book keeping 
        vsetvl rVlen, rNum   # set the vector length
                             # rN is the desired (application) vector length
                             # rVlen is what vector length we were given

        #####################################
        #    LOADS FOR C                    #   
        #####################################
        mul rTemp0, rJ, rLda4
        add rCTemp, rI4, rTemp0

        add rCTemp, rC, rCTemp
        vflw  vf2, rCTemp

        add rCTemp, rCTemp, rLda4
        vflw  vf4, rCTemp


        #################################
        # address calculation lifts     #
        #################################
        mul rTemp0, rJ, rLda4
        add rATmp2, rA, rTemp0

        add rBTmp2, rI4, rB
        move rK, zero
vec_loopk:
        slli rK4, rK, 2

        #####################################
        #    LOADS FOR A                    #   
        #####################################
        
        add rATemp, rK4, rATmp2
        vflstw  vf0, rATemp, zero       

        add rATemp, rATemp, rLda4
        vflstw  vf3, rATemp, zero


        #####################################
        #    LOADS FOR B                    #   
        #####################################
        mul rTemp0, rK, rLda4
        add rBTemp, rBTmp2, rTemp0
        vflw  vf1, rBTemp
        vf 0(rVTAddr)

        #####################################
        #    LOADS FOR A                    #   
        #####################################
        add rATemp, rK4, rATmp2
        addi rATemp, rATemp, 4
        vflstw  vf0, rATemp, zero       

        add rATemp, rATemp, rLda4
        vflstw  vf3, rATemp, zero


        #####################################
        #    LOADS FOR B                    #   
        #####################################
        add rBTemp, rBTemp, rLda4
        vflw  vf1, rBTemp
        vf 0(rVTAddr)

        #####################################
        #    LOADS FOR A                    #   
        #####################################
        add rATemp, rK4, rATmp2
        addi rATemp, rATemp, 8
        vflstw  vf0, rATemp, zero       

        add rATemp, rATemp, rLda4
        vflstw  vf3, rATemp, zero


        #####################################
        #    LOADS FOR B                    #   
        #####################################
        add rBTemp, rBTemp, rLda4
        vflw  vf1, rBTemp
        vf 0(rVTAddr)


        #####################################
        #    LOADS FOR A                    #   
        #####################################
        add rATemp, rK4, rATmp2
        addi rATemp, rATemp, 12
        vflstw  vf0, rATemp, zero       

        add rATemp, rATemp, rLda4
        vflstw  vf3, rATemp, zero


        #####################################
        #    LOADS FOR B                    #   
        #####################################
        add rBTemp, rBTemp, rLda4
        vflw  vf1, rBTemp
        vf 0(rVTAddr)

vec_endk:
        addi rK, rK, 4
        blt rK, rLda, vec_loopk

vec_endi:
        #####################################
        #    STORES FOR C                   #   
        #####################################
        vfsw  vf4, rCTemp
        sub   rCTemp, rCTemp, rLda4
        vfsw  vf2, rCTemp

        add rI, rI, rVlen
        blt rI, rLda, vec_loopi
vec_endj:
        addi rJ, rJ, 2
#       fence.v.l
        blt rJ, rLda, vec_loopj


cpdone:
        fence.v.l
        ld s0, 0(sp)
        ld s1, 8(sp)
        ld s2, 16(sp)
        addi sp, sp, 24


        ret

vtcode:
        # ADD YOUR VECTOR-ELEMENT CODE HERE ...

        #TODO: hit this with a fused multiply add.

        fmadd.s f2, f0, f1, f2
        fmadd.s f4, f3, f1, f4
        #fmadd.s f6, f5, f1, f6
        #fmadd.s f8, f7, f1, f8

        
        #fmul.s f1, f0, f1
        #fadd.s f2, f2, f1
        stop

transpose:
        # turn on vector unit
        setpcr status, SR_EV

        
        blez rLda, cpdone    # exit early if lda < 0
        vvcfgivl rVlen, rNum, 1, 1

        move rI, zero
tloopi:
        sub   rNum, rLda, rI 
        vsetvl rVlen, rNum

        move rJ, zero
tloopj:

        mul rTemp0, rJ, rLda
        add rATemp, rI, rTemp0
        slli rATemp, rATemp, 2
        add rATemp, rA, rATemp

        mul rTemp0, rI, rLda
        add rBTemp, rJ, rTemp0
        slli rBTemp, rBTemp, 2
        add rBTemp, rB, rBTemp

        #flw f0, 0(rBTemp)
        #fsw f0, 0(rATemp)
        vflstw vf0, rBTemp, rLda4
        vfsw   vf0, rATemp
        
tendj:
        addi rJ, rJ, 1
        blt  rJ, rLda, tloopj
tendi:
        #addi rI, rI, 1
        add rI, rI, rVlen
        blt  rI, rLda, tloopi

        ret
        # The C code uses a jalr instruction to call this function
        # so we can use a jr to return back to where the function
        # was called.  Also known as "ret", for "return".

        ret



#####################################
#     NOPS TO AVOID OVERPREFETCH    #
#####################################
#       srli rTemp0, rLda, 4 
#nop_lp:        addi rTemp0, rTemp0, -1
#       bgez  rTemp0, nop_lp
