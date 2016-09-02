#include "../../env/encoding.h"

#undef MCONTROL_TYPE
#undef MCONTROL_DMODE
#ifdef __riscv64
# define MCONTROL_TYPE    (0xf<<(64-4))
# define MCONTROL_DMODE   (1<<(64-5))
#else
# define MCONTROL_TYPE    (0xf<<(32-4))
# define MCONTROL_DMODE   (1<<(32-5))
#endif

        .global         main

        .section        .text
main:

        la      a0, data
        li      t0, 0
just_before_read_loop:
        li      t2, 16
read_loop:
        lw      t1, 0(a0)
        addi    t0, t0, 1
        addi    a0, a0, 4
        blt     t0, t2, read_loop

        la      a0, data
just_before_write_loop:
        li      t0, 1
write_loop:
        sw      t0, 0(a0)
        addi    t0, t0, 1
        addi    a0, a0, 4
        blt     t0, t2, write_loop

        j       main_exit

write_valid:
        li      t0, 0
        li      t2, MCONTROL_DMODE
        li      t3, MCONTROL_TYPE
write_valid_loop:
        csrw    CSR_TSELECT, t0
        csrr    t1, CSR_TSELECT
        bne     t0, t1, main_exit
        addi    t0, t0, 1
        csrr    t1, CSR_TDATA1
        and     t4, t1, t3
        beqz    t4, main_error  # type is 0
        and     t1, t1, t2
        bnez    t1, write_valid_loop
        # Found an entry with dmode=0
        csrw    CSR_TDATA1, zero        # this should succeed

write_invalid:
        li      t0, 0
        li      t2, MCONTROL_DMODE
        li      t3, MCONTROL_TYPE
write_invalid_loop:
        csrw    CSR_TSELECT, t0
        csrr    t1, CSR_TSELECT
        bne     t0, t1, main_exit
        addi    t0, t0, 1
        csrr    t1, CSR_TDATA1
        and     t4, t1, t3
        beqz    t4, main_error  # type is 0
        and     t1, t1, t2
        beqz    t1, write_invalid_loop
        # Found an entry with dmode=1
write_invalid_illegal:
        csrw    CSR_TDATA1, zero        # this should fail


main_exit:
        li      a0, 0
        j       _exit

main_error:
        li      a0, 1
        j       _exit

        .data
data:   .word   0x40
        .word   0x41
        .word   0x42
        .word   0x43
        .word   0x44
        .word   0x45
        .word   0x46
        .word   0x47
        .word   0x48
        .word   0x49
        .word   0x4a
        .word   0x4b
        .word   0x4c
        .word   0x4d
        .word   0x4e
        .word   0x4f
