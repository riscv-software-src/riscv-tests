#=======================================================================
# UCB CS250 Makefile fragment for benchmarks
#-----------------------------------------------------------------------
#
# Each benchmark directory should have its own fragment which
# essentially lists what the source files are and how to link them
# into an riscv and/or host executable. All variables should include
# the benchmark name as a prefix so that they are unique.
#

qsort_c_src = \
	qsort_main.c \
	syscalls.c \

qsort_riscv_src = \
	crt.S \

qsort_c_objs     = $(patsubst %.c, %.o, $(qsort_c_src))
qsort_riscv_objs = $(patsubst %.S, %.o, $(qsort_riscv_src))

qsort_host_bin = qsort.host
$(qsort_host_bin) : $(qsort_c_src)
	$(HOST_COMP) $^ -o $(qsort_host_bin)

qsort_riscv_bin = qsort.riscv
$(qsort_riscv_bin) : $(qsort_c_objs) $(qsort_riscv_objs)
	$(RISCV_LINK) $(qsort_c_objs) $(qsort_riscv_objs) -o $(qsort_riscv_bin) $(RISCV_LINK_OPTS)

junk += $(qsort_c_objs) $(qsort_riscv_objs) \
        $(qsort_host_bin) $(qsort_riscv_bin)
