#=======================================================================
# UCB CS250 Makefile fragment for benchmarks
#-----------------------------------------------------------------------
#
# Each benchmark directory should have its own fragment which
# essentially lists what the source files are and how to link them
# into an riscv and/or host executable. All variables should include
# the benchmark name as a prefix so that they are unique.
#

median_c_src = \
	median_main.c \
	median.c \
	syscalls.c \

median_riscv_src = \
	crt.S \

median_c_objs     = $(patsubst %.c, %.o, $(median_c_src))
median_riscv_objs = $(patsubst %.S, %.o, $(median_riscv_src))

median_host_bin = median.host
$(median_host_bin): $(median_c_src)
	$(HOST_COMP) $^ -o $(median_host_bin)

median_riscv_bin = median.riscv
$(median_riscv_bin): $(median_c_objs) $(median_riscv_objs)
	$(RISCV_LINK) $(median_c_objs) $(median_riscv_objs) -o $(median_riscv_bin) $(RISCV_LINK_OPTS)

junk += $(median_c_objs) $(median_riscv_objs) \
        $(median_host_bin) $(median_riscv_bin)
