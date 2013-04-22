#=======================================================================
# Makefile for riscv-tests
#-----------------------------------------------------------------------

default: all

#--------------------------------------------------------------------
# Sources
#--------------------------------------------------------------------

rv64ui_sc_tests = \
	add addi addiw addw \
	amoadd_d amoand_d amomax_d amomaxu_d amomin_d amominu_d amoor_d amoswap_d \
	amoadd_w amoand_w amomax_w amomaxu_w amomin_w amominu_w amoor_w amoswap_w \
	and andi \
	auipc \
	beq bge bgeu blt bltu bne \
	div divu divuw divw \
	example simple \
	fence_i \
	j jal jalr jalr_j jalr_r \
	lb lbu lh lhu lw lwu ld \
	lui \
	mul mulh mulhsu mulhu mulw \
	or ori \
	rem remu remuw remw \
	sb sh sw sd \
	sll slli slliw sllw \
	slt slti sltiu sltu \
	sra srai sraiw sraw \
	srl srli srliw srlw \
	sub subw \
	xor xori \

rv64ui_mc_tests =\
	lrsc

rv64ui_sc_vec_tests = \
	add addi addiw addw \
	and andi \
	lui \
	mul mulh mulhsu mulhu mulw \
	or ori \
	sll slli slliw sllw \
	slt slti sltiu sltu \
	sra srai sraiw sraw \
	srl srli srliw srlw \
	sub subw \
	xor xori \

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

rv64ui_p_tests_bin = $(addprefix rv64ui-p-, $(rv64ui_sc_tests))
rv64ui_p_tests_dump = $(addsuffix .dump, $(rv64ui_p_tests_bin))
rv64ui_p_tests_hex = $(addsuffix .hex, $(rv64ui_p_tests_bin))
rv64ui_p_tests_out  = $(addsuffix .out,  $(rv64ui_p_tests_bin))

$(rv64ui_p_tests_bin): rv64ui-p-%: %.S
	$(RISCV_GCC) $(RISCV_GCC_OPTS) -I../../env/p -I../macros/scalar -T../../env/p/link.ld $< -o $@

rv64ui_pm_tests_bin = $(addprefix rv64ui-pm-, $(rv64ui_mc_tests))
rv64ui_pm_tests_dump = $(addsuffix .dump, $(rv64ui_pm_tests_bin))
rv64ui_pm_tests_hex = $(addsuffix .hex, $(rv64ui_pm_tests_bin))
rv64ui_pm_tests_out  = $(addsuffix .out,  $(rv64ui_pm_tests_bin))

$(rv64ui_pm_tests_bin): rv64ui-pm-%: %.S
	$(RISCV_GCC) $(RISCV_GCC_OPTS) -I../../env/pm -I../macros/scalar -T../../env/pm/link.ld $< -o $@

rv64ui_v_tests_bin = $(addprefix rv64ui-v-, $(rv64ui_sc_tests))
rv64ui_v_tests_dump = $(addsuffix .dump, $(rv64ui_v_tests_bin))
rv64ui_v_tests_hex = $(addsuffix .hex, $(rv64ui_v_tests_bin))
rv64ui_v_tests_out  = $(addsuffix .out,  $(rv64ui_v_tests_bin))

$(rv64ui_v_tests_bin): rv64ui-v-%: %.S
	$(RISCV_GCC) $(RISCV_GCC_OPTS) -std=gnu99 -O2 -I../../env/v -I../macros/scalar -T../../env/v/link.ld ../../env/v/entry.S ../../env/v/vm.c $< -lc -o $@

rv64ui_p_vec_tests_bin = $(addprefix rv64ui-p-vec-, $(rv64ui_sc_vec_tests))
rv64ui_p_vec_tests_dump = $(addsuffix .dump, $(rv64ui_p_vec_tests_bin))
rv64ui_p_vec_tests_hex = $(addsuffix .hex, $(rv64ui_p_vec_tests_bin))
rv64ui_p_vec_tests_out  = $(addsuffix .out,  $(rv64ui_p_vec_tests_bin))

$(rv64ui_p_vec_tests_bin): rv64ui-p-vec-%: %.S
	$(RISCV_GCC) $(RISCV_GCC_OPTS) -I../../env/p -I../macros/vector -T../../env/p/link.ld $< -o $@

rv64ui_pt_vec_tests_bin = $(addprefix rv64ui-pt-vec-, $(rv64ui_sc_vec_tests))
rv64ui_pt_vec_tests_dump = $(addsuffix .dump, $(rv64ui_pt_vec_tests_bin))
rv64ui_pt_vec_tests_hex = $(addsuffix .hex, $(rv64ui_pt_vec_tests_bin))
rv64ui_pt_vec_tests_out  = $(addsuffix .out,  $(rv64ui_pt_vec_tests_bin))

$(rv64ui_pt_vec_tests_bin): rv64ui-pt-vec-%: %.S
	$(RISCV_GCC) $(RISCV_GCC_OPTS) -I../../env/pt -I../macros/vector -T../../env/pt/link.ld $< -o $@

rv64ui_v_vec_tests_bin = $(addprefix rv64ui-v-vec-, $(rv64ui_sc_vec_tests))
rv64ui_v_vec_tests_dump = $(addsuffix .dump, $(rv64ui_v_vec_tests_bin))
rv64ui_v_vec_tests_hex = $(addsuffix .hex, $(rv64ui_v_vec_tests_bin))
rv64ui_v_vec_tests_out  = $(addsuffix .out,  $(rv64ui_v_vec_tests_bin))

$(rv64ui_v_vec_tests_bin): rv64ui-v-vec-%: %.S
	$(RISCV_GCC) $(RISCV_GCC_OPTS) -std=gnu99 -O2 -I../../env/v -I../macros/vector -T../../env/v/link.ld ../../env/v/entry.S ../../env/v/vm.c $< -lc -o $@

riscv-: \
	$(rv64ui_p_tests_dump) $(rv64ui_p_tests_hex) \
	$(rv64ui_pm_tests_dump) $(rv64ui_pm_tests_hex) \
	$(rv64ui_v_tests_dump) $(rv64ui_v_tests_hex) \
	$(rv64ui_p_vec_tests_dump) $(rv64ui_p_vec_tests_hex) \
	$(rv64ui_pt_vec_tests_dump) $(rv64ui_pt_vec_tests_hex) \
	$(rv64ui_v_vec_tests_dump) $(rv64ui_v_vec_tests_hex) \

out = $(rv64ui_p_tests_out) $(rv64ui_pm_tests_out) $(rv64ui_v_tests_out) $(rv64ui_p_vec_tests_out) $(rv64ui_v_vec_tests_out)

run: $(out)
	echo; perl -ne 'print "  [$$1] $$ARGV \t$$2\n" if /\*{3}(.{8})\*{3}(.*)/' \
	       $(out); echo;

junk += \
  $(rv64ui_p_tests_bin) $(rv64ui_p_tests_dump) $(rv64ui_p_tests_hex) $(rv64ui_p_tests_out) \
  $(rv64ui_pm_tests_bin) $(rv64ui_pm_tests_dump) $(rv64ui_pm_tests_hex) $(rv64ui_pm_tests_out) \
  $(rv64ui_v_tests_bin) $(rv64ui_v_tests_dump) $(rv64ui_v_tests_hex) $(rv64ui_v_tests_out) \
  $(rv64ui_p_vec_tests_bin) $(rv64ui_p_vec_tests_dump) $(rv64ui_p_vec_tests_hex) $(rv64ui_p_vec_tests_out) \
  $(rv64ui_pt_vec_tests_bin) $(rv64ui_pt_vec_tests_dump) $(rv64ui_pt_vec_tests_hex) $(rv64ui_pt_vec_tests_out) \
  $(rv64ui_v_vec_tests_bin) $(rv64ui_v_vec_tests_dump) $(rv64ui_v_vec_tests_hex) $(rv64ui_v_vec_tests_out) \

#------------------------------------------------------------
# Default

all: riscv-

#------------------------------------------------------------
# Clean up

clean:
	rm -rf $(junk)
