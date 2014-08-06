riscv-tests
================

About
-----------

Unit tests for RISC-V processors

Building from repository
-----------------------------

We assume that the RISCV environment variable is set to the RISC-V tools
install path, and that the riscv-gcc package is installed.

    $ git clone https://github.com/ucb-bar/riscv-tests
    $ cd riscv-tests
    $ git submodule update --init --recursive
    $ autoconf
    $ ./configure --prefix=$RISCV/target
    $ make
    $ make install

