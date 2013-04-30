#=======================================================================
# UCB CS250 Makefile fragment for benchmarks
#-----------------------------------------------------------------------
#
# Each benchmark directory should have its own fragment which
# essentially lists what the source files are and how to link them
# into an riscv and/or host executable. All variables should include
# the benchmark name as a prefix so that they are unique.
#

vec_vvadd_c_src = \
	vec_vvadd_main.c \

vec_vvadd_riscv_src = \
	crt.S \
	vec_vvadd_asm.S

vec_vvadd_c_objs     = $(patsubst %.c, %.o, $(vec_vvadd_c_src))
vec_vvadd_riscv_objs = $(patsubst %.S, %.o, $(vec_vvadd_riscv_src))

vec_vvadd_host_bin = vec-vvadd.host
$(vec_vvadd_host_bin) : $(vec_vvadd_c_src)
	$(HOST_COMP) $^ -o $(vec_vvadd_host_bin)

vec_vvadd_riscv_bin = vec-vvadd.riscv
$(vec_vvadd_riscv_bin) : $(vec_vvadd_c_objs) $(vec_vvadd_riscv_objs)
	$(RISCV_LINK) $(RISCV_LINK_SYSCALL) $(vec_vvadd_c_objs) $(vec_vvadd_riscv_objs) -o $(vec_vvadd_riscv_bin)

junk += $(vec_vvadd_c_objs) $(vec_vvadd_riscv_objs) \
        $(vec_vvadd_host_bin) $(vec_vvadd_riscv_bin)
