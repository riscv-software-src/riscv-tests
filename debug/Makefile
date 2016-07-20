RISCV_SIM ?= spike
XLEN ?= 64

src_dir ?= .
GDBSERVER_PY = $(src_dir)/gdbserver.py

default:	spike$(XLEN).log

all:	spike32.log spike64.log

spike32.log:
	$(GDBSERVER_PY) --isolate --spike32 --cmd $(RISCV_SIM) -- -v > $@ 2>&1

spike64.log:
	$(GDBSERVER_PY) --isolate --spike --cmd $(RISCV_SIM) -- -v > $@ 2>&1

clean:
	rm -f *.log
