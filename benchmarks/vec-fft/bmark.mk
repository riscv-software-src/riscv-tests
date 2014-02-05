#=======================================================================
# UCB CS250 Makefile fragment for benchmarks
#-----------------------------------------------------------------------
#
# Each benchmark directory should have its own fragment which 
# essentially lists what the source files are and how to link them
# into an riscv and/or host executable. All variables should include 
# the benchmark name as a prefix so that they are unique.
#

vec-fft_data_src = fft-data.c

vec-fft_c_src = \
	vec-fft_main.c \
	vec-fft.c \
	$(vec-fft_data_src)

vec-fft_riscv_src = \
	crt.S \
	vec-vfft.S

vec-fft_c_objs     = $(patsubst %.c, %.o, $(vec-fft_c_src))
vec-fft_riscv_objs = $(patsubst %.S, %.o, $(vec-fft_riscv_src))

vec-fft_data_bin = fft-data-gen
$(vec-fft_data_src): $(vec-fft_data_bin)
	./$< $(FFT_FLOATING_PREC) $(FFT_SIZE) > $@

vec-fft_host_bin = vec-fft.host
$(vec-fft_host_bin): $(vec-fft_c_src)
#	$(HOST_COMP) $^ -o $(vec-fft_host_bin)

RISCV_LINK_SYSCALL = $(bmarkdir)/common/syscalls.c -lc

vec-fft_riscv_bin = vec-fft.riscv
$(vec-fft_riscv_bin): $(vec-fft_c_objs) $(vec-fft_riscv_objs)
	$(RISCV_LINK) $(RISCV_LINK_SYSCALL) $(vec-fft_c_objs) $(vec-fft_riscv_objs) -o $(vec-fft_riscv_bin)

junk += \
	$(vec-fft_data_src) $(vec-fft_c_objs) $(vec-fft_riscv_objs) \
	$(vec-fft_host_bin) $(vec-fft_riscv_bin)
