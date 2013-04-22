#=======================================================================
# Makefile for riscv-tests
#-----------------------------------------------------------------------

default: all

#--------------------------------------------------------------------
# Sources
#--------------------------------------------------------------------

rv64sv_sc_tests = \
	illegal_tvec_cmd illegal_tvec_regid \
	illegal_vt_inst illegal_vt_regid \
	ma_utld ma_utsd ma_vld ma_vsd \
	ma_vt_inst \

rv64sv_mc_tests = \

rv64sv_sc_vec_tests = \

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

rv64sv_p_tests_bin = $(addprefix rv64sv-p-, $(rv64sv_sc_tests))
rv64sv_p_tests_dump = $(addsuffix .dump, $(rv64sv_p_tests_bin))
rv64sv_p_tests_hex = $(addsuffix .hex, $(rv64sv_p_tests_bin))
rv64sv_p_tests_out  = $(addsuffix .out,  $(rv64sv_p_tests_bin))

$(rv64sv_p_tests_bin): rv64sv-p-%: %.S
	$(RISCV_GCC) $(RISCV_GCC_OPTS) -I../../env/p -I../macros/scalar -T../../env/p/link.ld $< -o $@

rv64sv_pm_tests_bin = $(addprefix rv64sv-pm-, $(rv64sv_mc_tests))
rv64sv_pm_tests_dump = $(addsuffix .dump, $(rv64sv_pm_tests_bin))
rv64sv_pm_tests_hex = $(addsuffix .hex, $(rv64sv_pm_tests_bin))
rv64sv_pm_tests_out  = $(addsuffix .out,  $(rv64sv_pm_tests_bin))

$(rv64sv_pm_tests_bin): rv64sv-pm-%: %.S
	$(RISCV_GCC) $(RISCV_GCC_OPTS) -I../../env/pm -I../macros/scalar -T../../env/pm/link.ld $< -o $@

rv64sv_p_vec_tests_bin = $(addprefix rv64sv-p-vec-, $(rv64sv_sc_vec_tests))
rv64sv_p_vec_tests_dump = $(addsuffix .dump, $(rv64sv_p_vec_tests_bin))
rv64sv_p_vec_tests_hex = $(addsuffix .hex, $(rv64sv_p_vec_tests_bin))
rv64sv_p_vec_tests_out  = $(addsuffix .out,  $(rv64sv_p_vec_tests_bin))

$(rv64sv_p_vec_tests_bin): rv64sv-p-vec-%: %.S
	$(RISCV_GCC) $(RISCV_GCC_OPTS) -I../../env/p -I../macros/vector -T../../env/p/link.ld $< -o $@

rv64sv_pt_vec_tests_bin = $(addprefix rv64sv-pt-vec-, $(rv64sv_sc_vec_tests))
rv64sv_pt_vec_tests_dump = $(addsuffix .dump, $(rv64sv_pt_vec_tests_bin))
rv64sv_pt_vec_tests_hex = $(addsuffix .hex, $(rv64sv_pt_vec_tests_bin))
rv64sv_pt_vec_tests_out  = $(addsuffix .out,  $(rv64sv_pt_vec_tests_bin))

$(rv64sv_pt_vec_tests_bin): rv64sv-pt-vec-%: %.S
	$(RISCV_GCC) $(RISCV_GCC_OPTS) -I../../env/pt -I../macros/vector -T../../env/pt/link.ld $< -o $@

riscv-: \
	$(rv64sv_p_tests_dump) $(rv64sv_p_tests_hex) \
	$(rv64sv_pm_tests_dump) $(rv64sv_pm_tests_hex) \
	$(rv64sv_p_vec_tests_dump) $(rv64sv_p_vec_tests_hex) \
	$(rv64sv_pt_vec_tests_dump) $(rv64sv_pt_vec_tests_hex) \

out =

run: $(out)
	echo; perl -ne 'print "  [$$1] $$ARGV \t$$2\n" if /\*{3}(.{8})\*{3}(.*)/' \
	       $(out); echo;

junk += \
  $(rv64sv_p_tests_bin) $(rv64sv_p_tests_dump) $(rv64sv_p_tests_hex) $(rv64sv_p_tests_out) \
  $(rv64sv_pm_tests_bin) $(rv64sv_pm_tests_dump) $(rv64sv_pm_tests_hex) $(rv64sv_pm_tests_out) \
  $(rv64sv_p_vec_tests_bin) $(rv64sv_p_vec_tests_dump) $(rv64sv_p_vec_tests_hex) $(rv64sv_p_vec_tests_out) \
  $(rv64sv_pt_vec_tests_bin) $(rv64sv_pt_vec_tests_dump) $(rv64sv_pt_vec_tests_hex) $(rv64sv_pt_vec_tests_out) \

#------------------------------------------------------------
# Default

all: riscv-

#------------------------------------------------------------
# Clean up

clean:
	rm -rf $(junk)
