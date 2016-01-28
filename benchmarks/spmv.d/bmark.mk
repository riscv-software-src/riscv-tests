#=======================================================================
# UCB CS250 Makefile fragment for benchmarks
#-----------------------------------------------------------------------
#
# Each benchmark directory should have its own fragment which
# essentially lists what the source files are and how to link them
# into an riscv and/or host executable. All variables should include
# the benchmark name as a prefix so that they are unique.
#

spmv_c_src = \
	spmv_main.c \
	syscalls.c \

spmv_riscv_src = \
	crt.S \

spmv_c_objs     = $(patsubst %.c, %.o, $(spmv_c_src))
spmv_riscv_objs = $(patsubst %.S, %.o, $(spmv_riscv_src))

spmv_host_bin = spmv.host
$(spmv_host_bin) : $(spmv_c_src)
	$(HOST_COMP) $^ -o $(spmv_host_bin)

spmv_riscv_bin = spmv.riscv
$(spmv_riscv_bin) : $(spmv_c_objs) $(spmv_riscv_objs)
	$(RISCV_LINK) $(spmv_c_objs) $(spmv_riscv_objs) -o $(spmv_riscv_bin) $(RISCV_LINK_OPTS)

junk += $(spmv_c_objs) $(spmv_riscv_objs) \
        $(spmv_host_bin) $(spmv_riscv_bin)
