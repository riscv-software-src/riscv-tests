#=======================================================================
# UCB CS250 Makefile fragment for benchmarks
#-----------------------------------------------------------------------
#
# Each benchmark directory should have its own fragment which
# essentially lists what the source files are and how to link them
# into an riscv and/or host executable. All variables should include
# the benchmark name as a prefix so that they are unique.
#

vec_cmplxmult_c_src = \
	vec_cmplxmult_main.c \

vec_cmplxmult_riscv_src = \
	crt.S \
	vec_cmplxmult_asm.S

vec_cmplxmult_c_objs     = $(patsubst %.c, %.o, $(vec_cmplxmult_c_src))
vec_cmplxmult_riscv_objs = $(patsubst %.S, %.o, $(vec_cmplxmult_riscv_src))

vec_cmplxmult_host_bin = vec-cmplxmult.host
$(vec_cmplxmult_host_bin) : $(vec_cmplxmult_c_src)
	$(HOST_COMP) $^ -o $(vec_cmplxmult_host_bin)

vec_cmplxmult_riscv_bin = vec-cmplxmult.riscv
$(vec_cmplxmult_riscv_bin) : $(vec_cmplxmult_c_objs) $(vec_cmplxmult_riscv_objs)
	$(RISCV_LINK) $(RISCV_LINK_SYSCALL) $(vec_cmplxmult_c_objs) $(vec_cmplxmult_riscv_objs) -o $(vec_cmplxmult_riscv_bin)

junk += $(vec_cmplxmult_c_objs) $(vec_cmplxmult_riscv_objs) \
        $(vec_cmplxmult_host_bin) $(vec_cmplxmult_riscv_bin)
