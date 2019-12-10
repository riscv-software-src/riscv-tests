#include "init.h"
#include "encoding.h"

static char table_data[4096 * 3];

// Set up 1-to-1 megapages for the entire address space.
void setup_page_table(char *table)
{
    uint32_t *entry = table;
    for (unsigned i = 0; i < 1024; i++) {
    }
}

int main()
{
    char *aligned_table_data = (table_data + 4095) & ~0xfff;
    unsigned long satp = set_field(0, SATP_MODE, SATP_MODE_SV32);
    satp = set_field(satp, SATP_PPN, aligned_table_data >> 12);
    csr_write(CSR_SATP, satp);
}
