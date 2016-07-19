RISCV_SIM ?= spike

all:	spike32.log spike64.log

spike32.log:
	./gdbserver.py --isolate --spike32 --cmd $(RISCV_SIM) -- -v > $@ 2>&1

spike64.log:
	./gdbserver.py --isolate --spike --cmd $(RISCV_SIM) -- -v > $@ 2>&1

clean:
	rm -f *.log
