// Test stepping over a variety of instructions.

        .global main

main:
        li      t0, 5                   // 0
        beq     zero, zero, one         // 0x4
        nop                             // 0x8
one:
        beq     zero, t0, one           // 0xc
        jal     two                     // 0x10

three:
        j       three                   // 0x14

two:
        ret                             // 0x18
