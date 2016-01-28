#=======================================================================
# UCB CS250 Makefile fragment for benchmarks
#-----------------------------------------------------------------------
#
# Each benchmark directory should have its own fragment which
# essentially lists what the source files are and how to link them
# into an riscv and/or host executable. All variables should include
# the benchmark name as a prefix so that they are unique.
#

dhrystone_c_src = \
	dhrystone_main.c \
	dhrystone.c \
	syscalls.c \

dhrystone_riscv_src = \
	crt.S \

dhrystone_c_objs     = $(patsubst %.c, %.o, $(dhrystone_c_src))
dhrystone_riscv_objs = $(patsubst %.S, %.o, $(dhrystone_riscv_src))

dhrystone_host_bin = dhrystone.host
$(dhrystone_host_bin): $(dhrystone_c_src)
	$(HOST_COMP) $^ -o $(dhrystone_host_bin)

dhrystone_riscv_bin = dhrystone.riscv
$(dhrystone_riscv_bin): $(dhrystone_c_objs) $(dhrystone_riscv_objs)
	$(RISCV_LINK) $(dhrystone_c_objs) $(dhrystone_riscv_objs) \
    -o $(dhrystone_riscv_bin) $(RISCV_LINK_OPTS)

junk += $(dhrystone_c_objs) $(dhrystone_riscv_objs) \
        $(dhrystone_host_bin) $(dhrystone_riscv_bin)
