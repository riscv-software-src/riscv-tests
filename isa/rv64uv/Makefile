#=======================================================================
# Makefile for riscv-tests
#-----------------------------------------------------------------------

default: all

#--------------------------------------------------------------------
# Sources
#--------------------------------------------------------------------

rv64uv_sc_tests = \
	wakeup fence \
	vvcfgivl vvcfg vsetvl \
	vfmvv vmsv vmvv \
	utidx \
	lb lbu lh lhu lw lwu ld \
	sb sh sw sd \
	fld flw \
	fsd fsw \
	amoadd_d amoand_d amomax_d amomaxu_d amomin_d amominu_d amoor_d amoswap_d \
	amoadd_w amoand_w amomax_w amomaxu_w amomin_w amominu_w amoor_w amoswap_w \
	imul \
	movn movz \
	fcvt fma \
	fmovn fmovz \
	vvadd_d vvadd_w vvadd_fd vvadd_fw \
	vvmul_d \
	vvadd_branch \

rv64uv_mc_tests = \

rv64uv_sc_vec_tests = \
	beq bge bgeu blt bltu bne \

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

rv64uv_p_tests_bin = $(addprefix rv64uv-p-, $(rv64uv_sc_tests))
rv64uv_p_tests_dump = $(addsuffix .dump, $(rv64uv_p_tests_bin))
rv64uv_p_tests_hex = $(addsuffix .hex, $(rv64uv_p_tests_bin))
rv64uv_p_tests_out  = $(addsuffix .out,  $(rv64uv_p_tests_bin))

$(rv64uv_p_tests_bin): rv64uv-p-%: %.S
	$(RISCV_GCC) $(RISCV_GCC_OPTS) -I../../env/p -I../macros/scalar -T../../env/p/link.ld $< -o $@

rv64uv_pm_tests_bin = $(addprefix rv64uv-pm-, $(rv64uv_mc_tests))
rv64uv_pm_tests_dump = $(addsuffix .dump, $(rv64uv_pm_tests_bin))
rv64uv_pm_tests_hex = $(addsuffix .hex, $(rv64uv_pm_tests_bin))
rv64uv_pm_tests_out  = $(addsuffix .out,  $(rv64uv_pm_tests_bin))

$(rv64uv_pm_tests_bin): rv64uv-pm-%: %.S
	$(RISCV_GCC) $(RISCV_GCC_OPTS) -I../../env/pm -I../macros/scalar -T../../env/pm/link.ld $< -o $@

rv64uv_v_tests_bin = $(addprefix rv64uv-v-, $(rv64uv_sc_tests))
rv64uv_v_tests_dump = $(addsuffix .dump, $(rv64uv_v_tests_bin))
rv64uv_v_tests_hex = $(addsuffix .hex, $(rv64uv_v_tests_bin))
rv64uv_v_tests_out  = $(addsuffix .out,  $(rv64uv_v_tests_bin))

$(rv64uv_v_tests_bin): rv64uv-v-%: %.S
	$(RISCV_GCC) $(RISCV_GCC_OPTS) -std=gnu99 -O2 -I../../env/v -I../macros/scalar -T../../env/v/link.ld ../../env/v/entry.S ../../env/v/vm.c $< -lc -o $@

rv64uv_p_vec_tests_bin = $(addprefix rv64uv-p-vec-, $(rv64uv_sc_vec_tests))
rv64uv_p_vec_tests_dump = $(addsuffix .dump, $(rv64uv_p_vec_tests_bin))
rv64uv_p_vec_tests_hex = $(addsuffix .hex, $(rv64uv_p_vec_tests_bin))
rv64uv_p_vec_tests_out  = $(addsuffix .out,  $(rv64uv_p_vec_tests_bin))

$(rv64uv_p_vec_tests_bin): rv64uv-p-vec-%: %.S
	$(RISCV_GCC) $(RISCV_GCC_OPTS) -I../../env/p -I../macros/vector -T../../env/p/link.ld $< -o $@

rv64uv_pt_vec_tests_bin = $(addprefix rv64uv-pt-vec-, $(rv64uv_sc_vec_tests))
rv64uv_pt_vec_tests_dump = $(addsuffix .dump, $(rv64uv_pt_vec_tests_bin))
rv64uv_pt_vec_tests_hex = $(addsuffix .hex, $(rv64uv_pt_vec_tests_bin))
rv64uv_pt_vec_tests_out  = $(addsuffix .out,  $(rv64uv_pt_vec_tests_bin))

$(rv64uv_pt_vec_tests_bin): rv64uv-pt-vec-%: %.S
	$(RISCV_GCC) $(RISCV_GCC_OPTS) -I../../env/pt -I../macros/vector -T../../env/pt/link.ld $< -o $@

rv64uv_v_vec_tests_bin = $(addprefix rv64uv-v-vec-, $(rv64uv_sc_vec_tests))
rv64uv_v_vec_tests_dump = $(addsuffix .dump, $(rv64uv_v_vec_tests_bin))
rv64uv_v_vec_tests_hex = $(addsuffix .hex, $(rv64uv_v_vec_tests_bin))
rv64uv_v_vec_tests_out  = $(addsuffix .out,  $(rv64uv_v_vec_tests_bin))

$(rv64uv_v_vec_tests_bin): rv64uv-v-vec-%: %.S
	$(RISCV_GCC) $(RISCV_GCC_OPTS) -std=gnu99 -O2 -I../../env/v -I../macros/vector -T../../env/v/link.ld ../../env/v/entry.S ../../env/v/vm.c $< -lc -o $@

riscv-: \
	$(rv64uv_p_tests_dump) $(rv64uv_p_tests_hex) \
	$(rv64uv_pm_tests_dump) $(rv64uv_pm_tests_hex) \
	$(rv64uv_v_tests_dump) $(rv64uv_v_tests_hex) \
	$(rv64uv_p_vec_tests_dump) $(rv64uv_p_vec_tests_hex) \
	$(rv64uv_pt_vec_tests_dump) $(rv64uv_pt_vec_tests_hex) \
	$(rv64uv_v_vec_tests_dump) $(rv64uv_v_vec_tests_hex) \

out = $(rv64uv_p_tests_out) $(rv64uv_pm_tests_out)

run: $(out)
	echo; perl -ne 'print "  [$$1] $$ARGV \t$$2\n" if /\*{3}(.{8})\*{3}(.*)/' \
	       $(out); echo;

junk += \
  $(rv64uv_p_tests_bin) $(rv64uv_p_tests_dump) $(rv64uv_p_tests_hex) $(rv64uv_p_tests_out) \
  $(rv64uv_pm_tests_bin) $(rv64uv_pm_tests_dump) $(rv64uv_pm_tests_hex) $(rv64uv_pm_tests_out) \
  $(rv64uv_v_tests_bin) $(rv64uv_v_tests_dump) $(rv64uv_v_tests_hex) $(rv64uv_v_tests_out) \
  $(rv64uv_p_vec_tests_bin) $(rv64uv_p_vec_tests_dump) $(rv64uv_p_vec_tests_hex) $(rv64uv_p_vec_tests_out) \
  $(rv64uv_pt_vec_tests_bin) $(rv64uv_pt_vec_tests_dump) $(rv64uv_pt_vec_tests_hex) $(rv64uv_pt_vec_tests_out) \
  $(rv64uv_v_vec_tests_bin) $(rv64uv_v_vec_tests_dump) $(rv64uv_v_vec_tests_hex) $(rv64uv_v_vec_tests_out) \

#------------------------------------------------------------
# Default

all: riscv-

#------------------------------------------------------------
# Clean up

clean:
	rm -rf $(junk)
