#=======================================================================
# UCB CS250 Makefile fragment for benchmarks
#-----------------------------------------------------------------------
#
# Each benchmark directory should have its own fragment which
# essentially lists what the source files are and how to link them
# into an riscv and/or host executable. All variables should include
# the benchmark name as a prefix so that they are unique.
#

vec_matmul_c_src = \
	vec_matmul_main.c \

vec_matmul_riscv_src = \
	crt.S \
	vec_matmul_asm.S

vec_matmul_c_objs     = $(patsubst %.c, %.o, $(vec_matmul_c_src))
vec_matmul_riscv_objs = $(patsubst %.S, %.o, $(vec_matmul_riscv_src))

vec_matmul_host_bin = vec-matmul.host
$(vec_matmul_host_bin) : $(vec_matmul_c_src)
	$(HOST_COMP) $^ -o $(vec_matmul_host_bin)

vec_matmul_riscv_bin = vec-matmul.riscv
$(vec_matmul_riscv_bin) : $(vec_matmul_c_objs) $(vec_matmul_riscv_objs)
	$(RISCV_LINK) $(RISCV_LINK_SYSCALL) $(vec_matmul_c_objs) $(vec_matmul_riscv_objs) -o $(vec_matmul_riscv_bin)

junk += $(vec_matmul_c_objs) $(vec_matmul_riscv_objs) \
        $(vec_matmul_host_bin) $(vec_matmul_riscv_bin)
