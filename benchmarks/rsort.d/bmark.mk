#=======================================================================
# UCB CS250 Makefile fragment for benchmarks
#-----------------------------------------------------------------------
#
# Each benchmark directory should have its own fragment which
# essentially lists what the source files are and how to link them
# into an riscv and/or host executable. All variables should include
# the benchmark name as a prefix so that they are unique.
#

rsort_c_src = \
	rsort.c \
	syscalls.c \

rsort_riscv_src = \
	crt.S \

rsort_c_objs     = $(patsubst %.c, %.o, $(rsort_c_src))
rsort_riscv_objs = $(patsubst %.S, %.o, $(rsort_riscv_src))

rsort_host_bin = rsort.host
$(rsort_host_bin) : $(rsort_c_src)
	$(HOST_COMP) $^ -o $(rsort_host_bin)

rsort_riscv_bin = rsort.riscv
$(rsort_riscv_bin) : $(rsort_c_objs) $(rsort_riscv_objs)
	$(RISCV_LINK) $(rsort_c_objs) $(rsort_riscv_objs) -o $(rsort_riscv_bin) $(RISCV_LINK_OPTS)

junk += $(rsort_c_objs) $(rsort_riscv_objs) \
        $(rsort_host_bin) $(rsort_riscv_bin)
