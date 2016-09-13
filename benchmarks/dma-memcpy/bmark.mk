#=======================================================================
# UCB CS250 Makefile fragment for benchmarks
#-----------------------------------------------------------------------
#
# Each benchmark directory should have its own fragment which
# essentially lists what the source files are and how to link them
# into an riscv and/or host executable. All variables should include
# the benchmark name as a prefix so that they are unique.
#

dma_memcpy_c_src = \
	dma_memcpy_main.c \
	dma_memcpy.c \
	syscalls.c \

dma_memcpy_riscv_src = \
	crt.S \

dma_memcpy_c_objs     = $(patsubst %.c, %.o, $(dma_memcpy_c_src))
dma_memcpy_riscv_objs = $(patsubst %.S, %.o, $(dma_memcpy_riscv_src))

dma_memcpy_host_bin = dma-memcpy.host
$(dma_memcpy_host_bin) : $(dma_memcpy_c_src)
	$(HOST_COMP) $^ -o $(dma_memcpy_host_bin)

dma_memcpy_riscv_bin = dma-memcpy.riscv
$(dma_memcpy_riscv_bin) : $(dma_memcpy_c_objs) $(dma_memcpy_riscv_objs)
	$(RISCV_LINK) $(dma_memcpy_c_objs) $(dma_memcpy_riscv_objs) -o $(dma_memcpy_riscv_bin) $(RISCV_LINK_OPTS)

junk += $(dma_memcpy_c_objs) $(dma_memcpy_riscv_objs) \
        $(dma_memcpy_host_bin) $(dma_memcpy_riscv_bin)
