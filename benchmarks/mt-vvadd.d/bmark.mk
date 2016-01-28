#=======================================================================
# UCB CS250 Makefile fragment for benchmarks
#-----------------------------------------------------------------------
#
# Each benchmark directory should have its own fragment which
# essentially lists what the source files are and how to link them
# into an riscv and/or host executable. All variables should include
# the benchmark name as a prefix so that they are unique.
#

mt_vvadd_c_src = \
	mt-vvadd.c \
	vvadd.c \
	syscalls.c \

mt_vvadd_riscv_src = \
	crt.S \

mt_vvadd_c_objs     = $(patsubst %.c, %.o, $(mt_vvadd_c_src))
mt_vvadd_riscv_objs = $(patsubst %.S, %.o, $(mt_vvadd_riscv_src))

mt_vvadd_host_bin = mt-vvadd.host
$(mt_vvadd_host_bin) : $(mt_vvadd_c_src)
	$(HOST_COMP) $^ -o $(mt_vvadd_host_bin)

mt_vvadd_riscv_bin = mt-vvadd.riscv
$(mt_vvadd_riscv_bin) : $(mt_vvadd_c_objs) $(mt_vvadd_riscv_objs)
	$(RISCV_LINK) $(mt_vvadd_c_objs) $(mt_vvadd_riscv_objs) $(RISCV_LINK_OPTS) -o $(mt_vvadd_riscv_bin)

junk += $(mt_vvadd_c_objs) $(mt_vvadd_riscv_objs) \
        $(mt_vvadd_host_bin) $(mt_vvadd_riscv_bin)
