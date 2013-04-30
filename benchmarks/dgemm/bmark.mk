#=======================================================================
# UCB CS250 Makefile fragment for benchmarks
#-----------------------------------------------------------------------
#
# Each benchmark directory should have its own fragment which
# essentially lists what the source files are and how to link them
# into an riscv and/or host executable. All variables should include
# the benchmark name as a prefix so that they are unique.
#

dgemm_c_src = \
	dgemm_main.c \

dgemm_riscv_src = \
	crt.S \

dgemm_c_objs     = $(patsubst %.c, %.o, $(dgemm_c_src))
dgemm_riscv_objs = $(patsubst %.S, %.o, $(dgemm_riscv_src))

dgemm_host_bin = dgemm.host
$(dgemm_host_bin) : $(dgemm_c_src)
	$(HOST_COMP) $^ -o $(dgemm_host_bin)

dgemm_riscv_bin = dgemm.riscv
$(dgemm_riscv_bin) : $(dgemm_c_objs) $(dgemm_riscv_objs)
	$(RISCV_LINK) $(dgemm_c_objs) $(dgemm_riscv_objs) -o $(dgemm_riscv_bin)

junk += $(dgemm_c_objs) $(dgemm_riscv_objs) \
        $(dgemm_host_bin) $(dgemm_riscv_bin)
