#=======================================================================
# UCB CS250 Makefile fragment for benchmarks
#-----------------------------------------------------------------------
#
# Each benchmark directory should have its own fragment which
# essentially lists what the source files are and how to link them
# into an riscv and/or host executable. All variables should include
# the benchmark name as a prefix so that they are unique.
#

mt_matmul_c_src = \
	mt-matmul.c \
	matmul.c \
	syscalls.c \

mt_matmul_riscv_src = \
	crt.S \

mt_matmul_c_objs     = $(patsubst %.c, %.o, $(mt_matmul_c_src))
mt_matmul_riscv_objs = $(patsubst %.S, %.o, $(mt_matmul_riscv_src))

mt_matmul_host_bin = mt-matmul.host
$(mt_matmul_host_bin) : $(mt_matmul_c_src)
	$(HOST_COMP) $^ -o $(mt_matmul_host_bin)

mt_matmul_riscv_bin = mt-matmul.riscv
$(mt_matmul_riscv_bin) : $(mt_matmul_c_objs) $(mt_matmul_riscv_objs)
	$(RISCV_LINK) $(mt_matmul_c_objs) $(mt_matmul_riscv_objs) $(RISCV_LINK_OPTS) -o $(mt_matmul_riscv_bin)

junk += $(mt_matmul_c_objs) $(mt_matmul_riscv_objs) \
        $(mt_matmul_host_bin) $(mt_matmul_riscv_bin)
