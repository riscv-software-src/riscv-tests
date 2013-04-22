#=======================================================================
# Makefile for riscv-tests
#-----------------------------------------------------------------------

default: all

#--------------------------------------------------------------------
# Sources
#--------------------------------------------------------------------

rv64si_sc_tests = \
	coreid \

rv64si_mc_tests = \
	ipi \

rv64si_sc_vec_tests = \

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

rv64si_p_tests_bin = $(addprefix rv64si-p-, $(rv64si_sc_tests))
rv64si_p_tests_dump = $(addsuffix .dump, $(rv64si_p_tests_bin))
rv64si_p_tests_hex = $(addsuffix .hex, $(rv64si_p_tests_bin))
rv64si_p_tests_out  = $(addsuffix .out,  $(rv64si_p_tests_bin))

$(rv64si_p_tests_bin): rv64si-p-%: %.S
	$(RISCV_GCC) $(RISCV_GCC_OPTS) -I../../env/p -I../macros/scalar -T../../env/p/link.ld $< -o $@

rv64si_pm_tests_bin = $(addprefix rv64si-pm-, $(rv64si_mc_tests))
rv64si_pm_tests_dump = $(addsuffix .dump, $(rv64si_pm_tests_bin))
rv64si_pm_tests_hex = $(addsuffix .hex, $(rv64si_pm_tests_bin))
rv64si_pm_tests_out  = $(addsuffix .out,  $(rv64si_pm_tests_bin))

$(rv64si_pm_tests_bin): rv64si-pm-%: %.S
	$(RISCV_GCC) $(RISCV_GCC_OPTS) -I../../env/pm -I../macros/scalar -T../../env/pm/link.ld $< -o $@

rv64si_p_vec_tests_bin = $(addprefix rv64si-p-vec-, $(rv64si_sc_vec_tests))
rv64si_p_vec_tests_dump = $(addsuffix .dump, $(rv64si_p_vec_tests_bin))
rv64si_p_vec_tests_hex = $(addsuffix .hex, $(rv64si_p_vec_tests_bin))
rv64si_p_vec_tests_out  = $(addsuffix .out,  $(rv64si_p_vec_tests_bin))

$(rv64si_p_vec_tests_bin): rv64si-p-vec-%: %.S
	$(RISCV_GCC) $(RISCV_GCC_OPTS) -I../../env/p -I../macros/vector -T../../env/p/link.ld $< -o $@

rv64si_pt_vec_tests_bin = $(addprefix rv64si-pt-vec-, $(rv64si_sc_vec_tests))
rv64si_pt_vec_tests_dump = $(addsuffix .dump, $(rv64si_pt_vec_tests_bin))
rv64si_pt_vec_tests_hex = $(addsuffix .hex, $(rv64si_pt_vec_tests_bin))
rv64si_pt_vec_tests_out  = $(addsuffix .out,  $(rv64si_pt_vec_tests_bin))

$(rv64si_pt_vec_tests_bin): rv64si-pt-vec-%: %.S
	$(RISCV_GCC) $(RISCV_GCC_OPTS) -I../../env/pt -I../macros/vector -T../../env/pt/link.ld $< -o $@

riscv-: \
	$(rv64si_p_tests_dump) $(rv64si_p_tests_hex) \
	$(rv64si_pm_tests_dump) $(rv64si_pm_tests_hex) \
	$(rv64si_p_vec_tests_dump) $(rv64si_p_vec_tests_hex) \
	$(rv64si_pt_vec_tests_dump) $(rv64si_pt_vec_tests_hex) \

out = $(rv64si_p_tests_out) $(rv64si_pm_tests_out) $(rv64si_p_vec_tests_out)

run: $(out)
	echo; perl -ne 'print "  [$$1] $$ARGV \t$$2\n" if /\*{3}(.{8})\*{3}(.*)/' \
	       $(out); echo;

junk += \
  $(rv64si_p_tests_bin) $(rv64si_p_tests_dump) $(rv64si_p_tests_hex) $(rv64si_p_tests_out) \
  $(rv64si_pm_tests_bin) $(rv64si_pm_tests_dump) $(rv64si_pm_tests_hex) $(rv64si_pm_tests_out) \
  $(rv64si_p_vec_tests_bin) $(rv64si_p_vec_tests_dump) $(rv64si_p_vec_tests_hex) $(rv64si_p_vec_tests_out) \
  $(rv64si_pt_vec_tests_bin) $(rv64si_pt_vec_tests_dump) $(rv64si_pt_vec_tests_hex) $(rv64si_pt_vec_tests_out) \

#------------------------------------------------------------
# Default

all: riscv-

#------------------------------------------------------------
# Clean up

clean:
	rm -rf $(junk)
