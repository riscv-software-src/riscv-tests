#=======================================================================
# UCB VLSI FLOW: Makefile for riscv-bmarks/mt
#-----------------------------------------------------------------------
# Henry Cook (hcook@cs.berkeley.edu)
#

default: all

bmarkdir = .
common = ../benchmarks/common

instname = riscv-bmarks-mt
instbasedir = $(UCB_VLSI_HOME)/install

#--------------------------------------------------------------------
# Sources
#--------------------------------------------------------------------

bmarks = \
ab_matmul\
ab_vvadd\
ad_matmul\
ad_vvadd\
ae_matmul\
ae_vvadd\
af_matmul\
af_vvadd\
ag_matmul\
ag_vvadd\
ai_matmul\
ai_vvadd\
aj_vvadd\
ak_matmul\
ak_vvadd\
al_matmul\
al_vvadd\
am_matmul\
am_vvadd\
an_matmul\
ap_matmul\
ap_vvadd\
aq_matmul\
aq_vvadd\
ar_matmul\
ar_vvadd\
as_matmul\
as_vvadd\
at_matmul\
at_vvadd\
av_matmul\
av_vvadd\
ay_matmul\
ay_vvadd\
az_matmul\
az_vvadd\
ba_matmul\
ba_vvadd\
bb_matmul\
bb_vvadd\
bc_matmul\
bc_vvadd\
be_matmul\
be_vvadd\
bf_matmul\
bf_vvadd\
bh_matmul\
bh_vvadd\
bj_matmul\
bj_vvadd\
bk_matmul\
bk_vvadd\
bm_matmul\
bm_vvadd\
bn_matmul\
bn_vvadd\
bo_matmul\
bo_vvadd\
bp_matmul\
bp_vvadd\
br_matmul\
br_vvadd\
bs_matmul\
bs_vvadd\
bt_matmul\
bt_vvadd\

#--------------------------------------------------------------------
# Build rules
#--------------------------------------------------------------------

RISCV_GCC = riscv-gcc
RISCV_GCC_OPTS = -std=gnu99 -T common/test.ld -O3 -nostdlib -nostartfiles -funroll-all-loops
RISCV_LINK = riscv-gcc -T $(common)/test.ld
RISCV_LINK_MT = riscv-gcc -T $(common)/test-mt.ld
RISCV_LINK_OPTS = -lc
RISCV_LINK_SYSCALL = -I$(bmarkdir)/../env $(common)/syscalls.c -lc
RISCV_OBJDUMP = riscv-objdump --disassemble-all --disassemble-zeroes --section=.text --section=.text.startup --section=.data
RISCV_SIM = spike -p2

VPATH += $(addprefix $(bmarkdir)/, $(bmarks))
VPATH += $(common)

incs  += -I. -I$(bmarkdir)/../env -I$(common) $(addprefix -I$(bmarkdir)/, $(bmarks))
objs  :=

#include $(patsubst %, $(bmarkdir)/%/bmark.mk, $(bmarks))

#------------------------------------------------------------
# Build and run benchmarks on riscv simulator
#------------------------------------------------------------

bmarks_riscv_obj  = $(addsuffix .o,  $(bmarks))
bmarks_riscv_bin  = $(addsuffix .riscv,  $(bmarks))
bmarks_riscv_dump = $(addsuffix .riscv.dump, $(bmarks))
bmarks_riscv_hex = $(addsuffix .riscv.hex, $(bmarks))
bmarks_riscv_out  = $(addsuffix .riscv.out,  $(bmarks))

bmarks_defs   = -DPREALLOCATE=1 -DHOST_DEBUG=0
bmarks_cycles = 80000

%.hex: %
	elf2hex 16 32768 $< > $@

$(bmarks_riscv_bin): %.riscv: %.o crt-mt.o
	$(RISCV_LINK_MT) crt-mt.o $< $(RISCV_LINK_SYSCALL) -o $@

$(bmarks_riscv_dump): %.riscv.dump: %.riscv
	$(RISCV_OBJDUMP) $< > $@

$(bmarks_riscv_out): %.riscv.out: %.riscv
	$(RISCV_SIM) $< > $@

%.o: %.c
	$(RISCV_GCC) $(RISCV_GCC_OPTS) $(bmarks_defs) \
	             -c $(incs) $< -o $@

%.o: %.S
	$(RISCV_GCC) $(RISCV_GCC_OPTS) $(bmarks_defs) \
	             -c $(incs) $< -o $@

riscv: $(bmarks_riscv_dump) $(bmarks_riscv_hex)
run-riscv: $(bmarks_riscv_out)
	echo; perl -ne 'print "  [$$1] $$ARGV \t$$2\n" if /\*{3}(.{8})\*{3}(.*)/' \
 
junk += $(bmarks_riscv_bin) $(bmarks_riscv_dump) $(bmarks_riscv_hex) $(bmarks_riscv_out)

 
#------------------------------------------------------------
# Default
 
all:  riscv
 
#------------------------------------------------------------
# Install

date_suffix = $(shell date +%Y-%m-%d_%H-%M)
install_dir = $(instbasedir)/$(instname)-$(date_suffix)
latest_install = $(shell ls -1 -d $(instbasedir)/$(instname)* | tail -n 1)

install:
	mkdir $(install_dir)
	cp -r $(bmarks_riscv_bin) $(bmarks_riscv_dump) $(install_dir)

install-link:
	rm -rf $(instbasedir)/$(instname)
	ln -s $(latest_install) $(instbasedir)/$(instname)

#------------------------------------------------------------
# Clean up

clean:
	rm -rf $(objs) $(junk)
