// Test stepping over a variety of instructions.

        .global main

main:
        la      t0, trap_entry          // 0, 4
        csrw    mtvec, t0               // 0x8

        li      t0, 5                   // 0xc
        beq     zero, zero, one         // 0x10
        nop                             // 0x14
one:
        beq     zero, t0, one           // 0x18
        jal     two                     // 0x1c

three:
        .word   0                       // 0x20
        nop                             // 0x24

two:
        ret                             // 0x28

trap_entry:
        j       trap_entry              // 0x2c
