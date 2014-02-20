
sort_c_src = \
	sort_main.c \
	sort.c \
	syscalls.c \

sort_riscv_src = \
	crt.S

sort_c_objs			= $(patsubst %.c, %.o, $(sort_c_src))
sort_riscv_objs = $(patsubst %.S, %.o, $(sort_riscv_src))

sort_host_bin = sort.host 
$(sort_host_bin): $(sort_c_src)
	$(HOST_COMP) $^ -o $(sort_host_bin)

sort_riscv_bin = sort.riscv 
$(sort_riscv_bin): $(sort_c_objs) $(sort_riscv_objs)
	$(RISCV_LINK) $(sort_c_objs) $(sort_riscv_objs) -o $(sort_riscv_bin) $(RISCV_LINK_OPTS)

junk += $(sort_c_objs) $(sort_riscv_objs) $(sort_host_bin) $(sort_riscv_bin)
