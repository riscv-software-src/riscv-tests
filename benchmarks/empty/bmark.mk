#=======================================================================
# UCB CS250 Makefile fragment for benchmarks
#-----------------------------------------------------------------------
#
# Each benchmark directory should have its own fragment which
# essentially lists what the source files are and how to link them
# into an riscv and/or host executable. All variables should include
# the benchmark name as a prefix so that they are unique.
#

empty_c_src = \
	empty_main.c \
	syscalls.c \

empty_riscv_src = \
	crt.S \

empty_c_objs     = $(patsubst %.c, %.o, $(empty_c_src))
empty_riscv_objs = $(patsubst %.S, %.o, $(empty_riscv_src))

empty_host_bin = empty.host
$(empty_host_bin): $(empty_c_src)
	$(HOST_COMP) $^ -o $(empty_host_bin)

empty_riscv_bin = empty.riscv
$(empty_riscv_bin): $(empty_c_objs) $(empty_riscv_objs)
	$(RISCV_LINK) $(empty_c_objs) $(empty_riscv_objs) -o $(empty_riscv_bin) $(RISCV_LINK_OPTS)

junk += $(empty_c_objs) $(empty_riscv_objs) \
        $(empty_host_bin) $(empty_riscv_bin)
