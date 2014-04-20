#=======================================================================
# UCB CS250 Makefile fragment for benchmarks
#-----------------------------------------------------------------------
#
# Each benchmark directory should have its own fragment which 
# essentially lists what the source files are and how to link them
# into an riscv and/or host executable. All variables should include 
# the benchmark name as a prefix so that they are unique.
#

sdisorder_c_src = \
	sdisorder.c \
	syscalls.c \

sdisorder_riscv_src = \
	crt.S \

sdisorder_c_objs     = $(patsubst %.c, %.o, $(sdisorder_c_src))
sdisorder_riscv_objs = $(patsubst %.S, %.o, $(sdisorder_riscv_src))

sdisorder_host_bin = sdisorder.host
$(sdisorder_host_bin): $(sdisorder_c_src)
	$(HOST_COMP) $^ -o $(sdisorder_host_bin)

sdisorder_riscv_bin = sdisorder.riscv
$(sdisorder_riscv_bin): $(sdisorder_c_objs) $(sdisorder_riscv_objs)
	$(RISCV_LINK) $(sdisorder_c_objs) $(sdisorder_riscv_objs) -o $(sdisorder_riscv_bin) $(RISCV_LINK_OPTS)

junk += $(sdisorder_c_objs) $(sdisorder_riscv_objs) \
        $(sdisorder_host_bin) $(sdisorder_riscv_bin)
