RISCV_SIM ?= spike
XLEN ?= 64

src_dir ?= .
GDBSERVER_PY = $(src_dir)/gdbserver.py

default: spike$(XLEN)

all:	pylint spike32 spike64

pylint:
	pylint --rcfile=pylint.rc `git ls-files '*.py'`

spike%:
	$(GDBSERVER_PY) \
		--isolate \
		--print-failures \
		$(src_dir)/targets/RISC-V/$@.py \
		--sim_cmd $(RISCV)/bin/$(RISCV_SIM) \
		--server_cmd $(RISCV)/bin/openocd

clean:
	rm -f *.pyc
