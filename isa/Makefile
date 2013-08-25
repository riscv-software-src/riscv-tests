#=======================================================================
# Makefile for riscv-tests/isa
#-----------------------------------------------------------------------

isa_src_dir := .

include $(isa_src_dir)/rv64ui/Makefrag
include $(isa_src_dir)/rv64uf/Makefrag
#include $(isa_src_dir)/rv64uv/Makefrag
include $(isa_src_dir)/rv64si/Makefrag
#include $(isa_src_dir)/rv64sv/Makefrag
include $(isa_src_dir)/rv32ui/Makefrag

default: all

#--------------------------------------------------------------------
# Build rules
#--------------------------------------------------------------------

RISCV_GCC = riscv-gcc
RISCV_GCC_OPTS = -nostdlib -nostartfiles -Wa,-march=RVIMAFDXhwacha
RISCV_OBJDUMP = riscv-objdump --disassemble-all --section=.text --section=.data --section=.bss
RISCV_SIM = spike

vpath %.S $(isa_src_dir)

#------------------------------------------------------------
# Build assembly tests

%.hex: %
	elf2hex 16 16384 $< > $@

%.dump: %
	$(RISCV_OBJDUMP) $< > $@

%.out: %
	$(RISCV_SIM) $< 2> $@

define compile_template

$$($(1)_p_tests): $(1)-p-%: $(1)/%.S
	$$(RISCV_GCC) $(2) $$(RISCV_GCC_OPTS) -I$(isa_src_dir)/../env/p -I$(isa_src_dir)/macros/scalar -T$(isa_src_dir)/../env/p/link.ld $$< -o $$@
tests += $$($(1)_p_tests)

$$($(1)_pt_tests): $(1)-pt-%: $(1)/%.S
	$$(RISCV_GCC) $(2) $$(RISCV_GCC_OPTS) -I$(isa_src_dir)/../env/pt -I$(isa_src_dir)/macros/scalar -T$(isa_src_dir)/../env/p/link.ld $$< -o $$@
tests += $$($(1)_pt_tests)

$$($(1)_pm_tests): $(1)-pm-%: $(1)/%.S
	$$(RISCV_GCC) $(2) $$(RISCV_GCC_OPTS) -I$(isa_src_dir)/../env/pm -I$(isa_src_dir)/macros/scalar -T$(isa_src_dir)/../env/pm/link.ld $$< -o $$@
tests += $$($(1)_pm_tests)

$$($(1)_v_tests): $(1)-v-%: $(1)/%.S
	$$(RISCV_GCC) $(2) $$(RISCV_GCC_OPTS) -std=gnu99 -O2 -I$(isa_src_dir)/../env/v -I$(isa_src_dir)/macros/scalar -T$(isa_src_dir)/../env/v/link.ld $(isa_src_dir)/../env/v/entry.S $(isa_src_dir)/../env/v/vm.c $$< -lc -o $$@
tests += $$($(1)_v_tests)

#$$($(1)_p_vec_tests): $(1)-p-vec-%: $(1)/%.S
#	$$(RISCV_GCC) $(2) $$(RISCV_GCC_OPTS) -I$(isa_src_dir)/../env/p -I$(isa_src_dir)/macros/vector -T$(isa_src_dir)/../env/p/link.ld $$< -o $$@
#tests += $$($(1)_p_vec_tests)
#
#$$($(1)_pt_vec_tests): $(1)-pt-vec-%: $(1)/%.S
#	$$(RISCV_GCC) $(2) $$(RISCV_GCC_OPTS) -I$(isa_src_dir)/../env/pt -I$(isa_src_dir)/macros/vector -T$(isa_src_dir)/../env/pt/link.ld $$< -o $$@
#tests += $$($(1)_pt_vec_tests)
#
#$$($(1)_v_vec_tests): $(1)-v-vec-%: $(1)/%.S
#	$$(RISCV_GCC) $(2) $$(RISCV_GCC_OPTS) -std=gnu99 -O2 -I$(isa_src_dir)/../env/v -I$(isa_src_dir)/macros/vector -T$(isa_src_dir)/../env/v/link.ld $(isa_src_dir)/../env/v/entry.S $(isa_src_dir)/../env/v/vm.c $$< -lc -o $$@
#tests += $$($(1)_v_vec_tests)

endef

$(eval $(call compile_template,rv32ui,-m32))
$(eval $(call compile_template,rv64ui))
$(eval $(call compile_template,rv64uf))
$(eval $(call compile_template,rv64uv))
$(eval $(call compile_template,rv64si))
$(eval $(call compile_template,rv64sv))

tests_dump = $(addsuffix .dump, $(tests))
tests_hex = $(addsuffix .hex, $(tests))
tests_out = $(addsuffix .out, $(spike_tests))

run: $(tests_out)
	echo; perl -ne 'print "  [$$1] $$ARGV \t$$2\n" if /\*{3}(.{8})\*{3}(.*)/' \
	       $(tests_out); echo;

junk += $(tests) $(tests_dump) $(tests_hex) $(tests_out)

#------------------------------------------------------------
# Default

all: $(tests_dump) $(tests_hex)

#------------------------------------------------------------
# Clean up

clean:
	rm -rf $(junk)
