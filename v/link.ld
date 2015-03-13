/*======================================================================*/
/* Proxy kernel linker script                                           */
/*======================================================================*/
/* This is the linker script used when building the proxy kernel. */

/*----------------------------------------------------------------------*/
/* Setup                                                                */
/*----------------------------------------------------------------------*/

/* The OUTPUT_ARCH command specifies the machine architecture where the
   argument is one of the names used in the BFD library. More
   specifically one of the entires in bfd/cpu-mips.c */

OUTPUT_ARCH( "riscv" )

/*----------------------------------------------------------------------*/
/* Sections                                                             */
/*----------------------------------------------------------------------*/

SECTIONS
{

  /* text: test code section */
  . = 0;
  .text :
  {
    *(.text)
  }

  /* data: Initialized data segment */
  .data ALIGN(0x2000):
  {
    *(.data)
  }

  /* bss: Initialized bss segment */
  .bss ALIGN(0x2000):
  {
    *(.bss)
  }

  /* End of uninitalized bss segement */
  _end = .;
}

