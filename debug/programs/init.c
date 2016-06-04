int main(void);

void handle_trap(unsigned int mcause, unsigned int mepc, unsigned int sp)
{
    while (1)
        ;
}

void _init()
{
    main();
    while (1)
        ;
}
