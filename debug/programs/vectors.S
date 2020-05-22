#include "encoding.h"

#define get_field(reg, mask) (((reg) & (mask)) / ((mask) & ~((mask) << 1)))
#define set_field(reg, mask, val) (((reg) & ~(mask)) | (((val) * ((mask) & ~((mask) << 1))) & (mask)))

        .global main
        .global main_end
        .global main_post_csrr

        // Load constants into all registers so we can test no register are
        // clobbered after attaching.
main:
        // Set VS=1
        csrr    t0, CSR_MSTATUS
        li      t1, set_field(0, MSTATUS_VS, 1)
        or      t0, t0, t1
        csrw    CSR_MSTATUS, t0

1:
        li      t0, 64
        //vslide1down.vx  vd, vs2, rs1, vm
        vslide1down.vx  v13, v13, t1, 1
        addi    t0, t0, -1
        bne     t0, zero, 1b
        
        li a0, 0

main_end:
        ret

