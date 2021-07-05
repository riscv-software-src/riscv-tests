.PHONY: all run clean $(ALL)

SUPPORTED_ISA = riscv64 riscv32

RISCV = $(word 1, $(subst -, ,$(ARCH)))
ifeq ($(filter $(SUPPORTED_ISA), $(RISCV)), )
  $(error Expected $$ISA in {$(SUPPORTED_ISA)}, Got "$(RISCV)")
endif

ifeq ($(RISCV), riscv64)
  RV_DIR = isa/rv64ui
else
  RV_DIR = isa/rv32ui
endif

ALL = $(basename $(notdir $(shell find $(RV_DIR)/. -name "*.S" | grep -v fence_i.S)))

all: $(addprefix Makefile-, $(ALL))
	@echo "" $(ALL)

$(ALL): %: Makefile-%

Makefile-%: $(RV_DIR)/%.S
	@/bin/echo -e "NAME = $*\nSRCS = $<\nLIBS += klib\nINC_PATH += $(shell pwd)/env/p $(shell pwd)/isa/macros/scalar\ninclude $${AM_HOME}/Makefile" > $@
	-@make -s -f $@ ARCH=$(ARCH) $(MAKECMDGOALS)
	-@rm -f Makefile-$*

run: all

clean:
	rm -rf Makefile-* build/
