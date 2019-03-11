RISCV_SIM ?= spike
XLEN ?= 64

src_dir ?= .
GDBSERVER_PY = $(src_dir)/gdbserver.py

default: spike$(XLEN) spike$(XLEN)-2

all-tests: spike32 spike32-2 spike32-2-rtos spike32-2-hwthread \
	spike64 spike64-2 spike64-2-rtos spike64-2-hwthread

all:	pylint all-tests

# Target to check all the multicore options.
multi-tests: spike32-2 spike64-2-rtos spike32-2-hwthread

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
