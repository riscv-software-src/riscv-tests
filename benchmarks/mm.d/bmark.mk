#=======================================================================
# UCB CS250 Makefile fragment for benchmarks
#-----------------------------------------------------------------------
#
# Each benchmark directory should have its own fragment which
# essentially lists what the source files are and how to link them
# into an riscv and/or host executable. All variables should include
# the benchmark name as a prefix so that they are unique.
#

mm_c_src = \
	mm_main.c \
	mm.c \
	syscalls.c \

mm_riscv_src = \
	crt.S \

mm_c_objs     = $(patsubst %.c, %.o, $(mm_c_src))
mm_riscv_objs = $(patsubst %.S, %.o, $(mm_riscv_src))

mm_host_bin = mm.host
$(mm_host_bin) : $(mm_c_src)
	$(HOST_COMP) $^ -o $(mm_host_bin)

mm_riscv_bin = mm.riscv
$(mm_riscv_bin) : $(mm_c_objs) $(mm_riscv_objs)
	$(RISCV_LINK) $(mm_c_objs) $(mm_riscv_objs) -o $(mm_riscv_bin) $(RISCV_LINK_OPTS)

junk += $(mm_c_objs) $(mm_riscv_objs) \
        $(mm_host_bin) $(mm_riscv_bin)
