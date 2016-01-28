#=======================================================================
# UCB CS250 Makefile fragment for benchmarks
#-----------------------------------------------------------------------
#
# Each benchmark directory should have its own fragment which 
# essentially lists what the source files are and how to link them
# into an riscv and/or host executable. All variables should include 
# the benchmark name as a prefix so that they are unique.
#

multiply_c_src = \
	multiply_main.c \
	multiply.c \
	syscalls.c \

multiply_riscv_src = \
	crt.S \

multiply_c_objs     = $(patsubst %.c, %.o, $(multiply_c_src))
multiply_riscv_objs = $(patsubst %.S, %.o, $(multiply_riscv_src))

multiply_host_bin = multiply.host
$(multiply_host_bin): $(multiply_c_src)
	$(HOST_COMP) $^ -o $(multiply_host_bin)

multiply_riscv_bin = multiply.riscv
$(multiply_riscv_bin): $(multiply_c_objs) $(multiply_riscv_objs)
	$(RISCV_LINK) $(multiply_c_objs) $(multiply_riscv_objs) -o $(multiply_riscv_bin) $(RISCV_LINK_OPTS)

junk += $(multiply_c_objs) $(multiply_riscv_objs) \
        $(multiply_host_bin) $(multiply_riscv_bin)
