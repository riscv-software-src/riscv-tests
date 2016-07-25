RISCV_SIM ?= spike
XLEN ?= 64

src_dir ?= .
GDBSERVER_PY = $(src_dir)/gdbserver.py

default:	spike$(XLEN).log

all:	spike32.log spike64.log

%.log:
	$(GDBSERVER_PY) --isolate --$(subst .log,,$@) --cmd $(RISCV_SIM) -- -v \
	    > $@ 2>&1 || sed s/^/$@:\ / $@

clean:
	rm -f *.log
