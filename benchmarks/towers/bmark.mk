#=======================================================================
# UCB CS250 Makefile fragment for benchmarks
#-----------------------------------------------------------------------
#
# Each benchmark directory should have its own fragment which
# essentially lists what the source files are and how to link them
# into an riscv and/or host executable. All variables should include
# the benchmark name as a prefix so that they are unique.
#

towers_c_src = \
	towers_main.c \
	syscalls.c \

towers_riscv_src = \
	crt.S \

towers_c_objs     = $(patsubst %.c, %.o, $(towers_c_src))
towers_riscv_objs = $(patsubst %.S, %.o, $(towers_riscv_src))

towers_host_bin = towers.host
$(towers_host_bin) : $(towers_c_src)
	$(HOST_COMP) $^ -o $(towers_host_bin)

towers_riscv_bin = towers.riscv
$(towers_riscv_bin) : $(towers_c_objs) $(towers_riscv_objs)
	$(RISCV_LINK) $(towers_c_objs) $(towers_riscv_objs) -o $(towers_riscv_bin) $(RISCV_LINK_OPTS)

junk += $(towers_c_objs) $(towers_riscv_objs) \
        $(towers_host_bin) $(towers_riscv_bin)
