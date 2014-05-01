#=======================================================================
# UCB CS250 Makefile fragment for benchmarks
#-----------------------------------------------------------------------
#
# Each benchmark directory should have its own fragment which 
# essentially lists what the source files are and how to link them
# into an riscv and/or host executable. All variables should include 
# the benchmark name as a prefix so that they are unique.
#

stream_c_src = \
	stream_d.c \
	syscalls.c \

stream_riscv_src = \
	crt.S \

stream_c_objs     = $(patsubst %.c, %.o, $(stream_c_src))
stream_riscv_objs = $(patsubst %.S, %.o, $(stream_riscv_src))

stream_host_bin = stream.host
$(stream_host_bin): $(stream_c_src)
	$(HOST_COMP) $^ -o $(stream_host_bin)

stream_riscv_bin = stream.riscv
$(stream_riscv_bin): $(stream_c_objs) $(stream_riscv_objs)
	$(RISCV_LINK) $(stream_c_objs) $(stream_riscv_objs) -o $(stream_riscv_bin) $(RISCV_LINK_OPTS)

junk += $(stream_c_objs) $(stream_riscv_objs) \
        $(stream_host_bin) $(stream_riscv_bin)
