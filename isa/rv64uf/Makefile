#=======================================================================
# Makefile for riscv-tests
#-----------------------------------------------------------------------

default: all

#--------------------------------------------------------------------
# Sources
#--------------------------------------------------------------------

rv64uf_sc_tests = \
	fadd fcmp fcvt fcvt_w fmadd fmin fsgnj \
	ldst move structural \

rv64uf_mc_tests =\

rv64uf_sc_vec_tests = \
	fadd fcmp fcvt fcvt_w fmadd fmin fsgnj \

#--------------------------------------------------------------------
# Build rules
#--------------------------------------------------------------------

RISCV_GCC = riscv-gcc
RISCV_GCC_OPTS = -nostdlib -nostartfiles
RISCV_OBJDUMP = riscv-objdump --disassemble-all --disassemble-zeroes --section=.text --section=.data --section=.bss
RISCV_SIM = riscv-isa-run

#------------------------------------------------------------
# Build assembly tests

%.hex: %
	elf2hex 16 16384 $< > $@

%.dump: %
	$(RISCV_OBJDUMP) $< > $@

%.out: %
	$(RISCV_SIM) $< 2> $@

rv64uf_p_tests_bin = $(addprefix rv64uf-p-, $(rv64uf_sc_tests))
rv64uf_p_tests_dump = $(addsuffix .dump, $(rv64uf_p_tests_bin))
rv64uf_p_tests_hex = $(addsuffix .hex, $(rv64uf_p_tests_bin))
rv64uf_p_tests_out  = $(addsuffix .out,  $(rv64uf_p_tests_bin))

$(rv64uf_p_tests_bin): rv64uf-p-%: %.S
	$(RISCV_GCC) $(RISCV_GCC_OPTS) -I../../env/p -I../macros/scalar -T../../env/p/link.ld $< -o $@

rv64uf_pm_tests_bin = $(addprefix rv64uf-pm-, $(rv64uf_mc_tests))
rv64uf_pm_tests_dump = $(addsuffix .dump, $(rv64uf_pm_tests_bin))
rv64uf_pm_tests_hex = $(addsuffix .hex, $(rv64uf_pm_tests_bin))
rv64uf_pm_tests_out  = $(addsuffix .out,  $(rv64uf_pm_tests_bin))

$(rv64uf_pm_tests_bin): rv64uf-pm-%: %.S
	$(RISCV_GCC) $(RISCV_GCC_OPTS) -I../../env/pm -I../macros/scalar -T../../env/pm/link.ld $< -o $@

rv64uf_v_tests_bin = $(addprefix rv64uf-v-, $(rv64uf_sc_tests))
rv64uf_v_tests_dump = $(addsuffix .dump, $(rv64uf_v_tests_bin))
rv64uf_v_tests_hex = $(addsuffix .hex, $(rv64uf_v_tests_bin))
rv64uf_v_tests_out  = $(addsuffix .out,  $(rv64uf_v_tests_bin))

$(rv64uf_v_tests_bin): rv64uf-v-%: %.S
	$(RISCV_GCC) $(RISCV_GCC_OPTS) -std=gnu99 -O2 -I../../env/v -I../macros/scalar -T../../env/v/link.ld ../../env/v/entry.S ../../env/v/vm.c $< -lc -o $@

rv64uf_p_vec_tests_bin = $(addprefix rv64uf-p-vec-, $(rv64uf_sc_vec_tests))
rv64uf_p_vec_tests_dump = $(addsuffix .dump, $(rv64uf_p_vec_tests_bin))
rv64uf_p_vec_tests_hex = $(addsuffix .hex, $(rv64uf_p_vec_tests_bin))
rv64uf_p_vec_tests_out  = $(addsuffix .out,  $(rv64uf_p_vec_tests_bin))

$(rv64uf_p_vec_tests_bin): rv64uf-p-vec-%: %.S
	$(RISCV_GCC) $(RISCV_GCC_OPTS) -I../../env/p -I../macros/vector -T../../env/p/link.ld $< -o $@

rv64uf_pt_vec_tests_bin = $(addprefix rv64uf-pt-vec-, $(rv64uf_sc_vec_tests))
rv64uf_pt_vec_tests_dump = $(addsuffix .dump, $(rv64uf_pt_vec_tests_bin))
rv64uf_pt_vec_tests_hex = $(addsuffix .hex, $(rv64uf_pt_vec_tests_bin))
rv64uf_pt_vec_tests_out  = $(addsuffix .out,  $(rv64uf_pt_vec_tests_bin))

$(rv64uf_pt_vec_tests_bin): rv64uf-pt-vec-%: %.S
	$(RISCV_GCC) $(RISCV_GCC_OPTS) -I../../env/pt -I../macros/vector -T../../env/pt/link.ld $< -o $@

rv64uf_v_vec_tests_bin = $(addprefix rv64uf-v-vec-, $(rv64uf_sc_vec_tests))
rv64uf_v_vec_tests_dump = $(addsuffix .dump, $(rv64uf_v_vec_tests_bin))
rv64uf_v_vec_tests_hex = $(addsuffix .hex, $(rv64uf_v_vec_tests_bin))
rv64uf_v_vec_tests_out  = $(addsuffix .out,  $(rv64uf_v_vec_tests_bin))

$(rv64uf_v_vec_tests_bin): rv64uf-v-vec-%: %.S
	$(RISCV_GCC) $(RISCV_GCC_OPTS) -std=gnu99 -O2 -I../../env/v -I../macros/vector -T../../env/v/link.ld ../../env/v/entry.S ../../env/v/vm.c $< -lc -o $@

riscv-: \
	$(rv64uf_p_tests_dump) $(rv64uf_p_tests_hex) \
	$(rv64uf_pm_tests_dump) $(rv64uf_pm_tests_hex) \
	$(rv64uf_v_tests_dump) $(rv64uf_v_tests_hex) \
	$(rv64uf_p_vec_tests_dump) $(rv64uf_p_vec_tests_hex) \
	$(rv64uf_pt_vec_tests_dump) $(rv64uf_pt_vec_tests_hex) \
	$(rv64uf_v_vec_tests_dump) $(rv64uf_v_vec_tests_hex) \

out = $(rv64uf_p_tests_out) $(rv64uf_pm_tests_out) $(rv64uf_v_tests_out) $(rv64uf_p_vec_tests_out) $(rv64uf_v_vec_tests_out)

run: $(out)
	echo; perl -ne 'print "  [$$1] $$ARGV \t$$2\n" if /\*{3}(.{8})\*{3}(.*)/' \
	       $(out); echo;

junk += \
  $(rv64uf_p_tests_bin) $(rv64uf_p_tests_dump) $(rv64uf_p_tests_hex) $(rv64uf_p_tests_out) \
  $(rv64uf_pm_tests_bin) $(rv64uf_pm_tests_dump) $(rv64uf_pm_tests_hex) $(rv64uf_pm_tests_out) \
  $(rv64uf_v_tests_bin) $(rv64uf_v_tests_dump) $(rv64uf_v_tests_hex) $(rv64uf_v_tests_out) \
  $(rv64uf_p_vec_tests_bin) $(rv64uf_p_vec_tests_dump) $(rv64uf_p_vec_tests_hex) $(rv64uf_p_vec_tests_out) \
  $(rv64uf_pt_vec_tests_bin) $(rv64uf_pt_vec_tests_dump) $(rv64uf_pt_vec_tests_hex) $(rv64uf_pt_vec_tests_out) \
  $(rv64uf_v_vec_tests_bin) $(rv64uf_v_vec_tests_dump) $(rv64uf_v_vec_tests_hex) $(rv64uf_v_vec_tests_out) \

#------------------------------------------------------------
# Default

all: riscv-

#------------------------------------------------------------
# Clean up

clean:
	rm -rf $(junk)
