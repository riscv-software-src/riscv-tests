RISCV_SIM ?= spike
XLEN ?= 64

src_dir ?= .
GDBSERVER_PY = $(src_dir)/gdbserver.py

default:	spike$(XLEN).log

all:	pylint spike32.log spike64.log

pylint:
	pylint --rcfile=pylint.rc *.py

%.log:
	$(GDBSERVER_PY) --isolate --$(subst .log,,$@) --cmd $(RISCV_SIM) \
	    > $@ 2>&1 || (sed s/^/$@:\ / $@ && false)

clean:
	rm -f *.log *.pyc
