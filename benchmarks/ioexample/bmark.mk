#=======================================================================
# UCB CS250 Makefile fragment for benchmarks
#-----------------------------------------------------------------------
#
# Each benchmark directory should have its own fragment which
# essentially lists what the source files are and how to link them
# into an riscv and/or host executable. All variables should include
# the benchmark name as a prefix so that they are unique.
#

ioexample_c_src = \
	ioexample_main.c \
	syscalls.c \

ioexample_riscv_src = \
	crt.S \

ioexample_c_objs     = $(patsubst %.c, %.o, $(ioexample_c_src))
ioexample_riscv_objs = $(patsubst %.S, %.o, $(ioexample_riscv_src))

ioexample_host_bin = ioexample.host
$(ioexample_host_bin) : $(ioexample_c_src)
	$(HOST_COMP) $^ -o $(ioexample_host_bin)

ioexample_riscv_bin = ioexample.riscv
$(ioexample_riscv_bin) : $(ioexample_c_objs) $(ioexample_riscv_objs)
	$(RISCV_LINK) $(ioexample_c_objs) $(ioexample_riscv_objs) -o $(ioexample_riscv_bin) $(RISCV_LINK_OPTS)

junk += $(ioexample_c_objs) $(ioexample_riscv_objs) \
        $(ioexample_host_bin) $(ioexample_riscv_bin)
