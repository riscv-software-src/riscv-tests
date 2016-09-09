#=======================================================================
# UCB CS250 Makefile fragment for benchmarks
#-----------------------------------------------------------------------
#
# Each benchmark directory should have its own fragment which
# essentially lists what the source files are and how to link them
# into an riscv and/or host executable. All variables should include
# the benchmark name as a prefix so that they are unique.
#

memcpy_c_src = \
	memcpy_main.c \
	memcpy.c \
	syscalls.c \

memcpy_riscv_src = \
	crt.S \

memcpy_c_objs     = $(patsubst %.c, %.o, $(memcpy_c_src))
memcpy_riscv_objs = $(patsubst %.S, %.o, $(memcpy_riscv_src))

memcpy_host_bin = memcpy.host
$(memcpy_host_bin) : $(memcpy_c_src)
	$(HOST_COMP) $^ -o $(memcpy_host_bin)

memcpy_riscv_bin = memcpy.riscv
$(memcpy_riscv_bin) : $(memcpy_c_objs) $(memcpy_riscv_objs)
	$(RISCV_LINK) $(memcpy_c_objs) $(memcpy_riscv_objs) -o $(memcpy_riscv_bin) $(RISCV_LINK_OPTS)

junk += $(memcpy_c_objs) $(memcpy_riscv_objs) \
        $(memcpy_host_bin) $(memcpy_riscv_bin)
