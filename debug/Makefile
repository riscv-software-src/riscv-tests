RISCV_SIM ?= spike
XLEN ?= 64

OPENOCD_INSTALL ?= $(abspath .)/openocd-install
OPENOCD_VERSION = d8683119c0a1aa88320c7a6d4f0d6f63a5f976c5

OPENOCD_DIR = $(OPENOCD_INSTALL)_$(OPENOCD_VERSION)/

$(OPENOCD_DIR)/bin/openocd:
	rm -rf riscv-openocd
	git clone http://github.com/riscv/riscv-openocd.git
	cd riscv-openocd ; \
	git checkout $(OPENOCD_VERSION) ; \
	./bootstrap ; \
	./configure --enable-remote_bitbang --prefix=$(OPENOCD_INSTALL)_$(OPENOCD_VERSION) --disable-werror; \
	make ; \
	make install

install_openocd: $(OPENOCD_DIR)/bin/openocd

src_dir ?= .
GDBSERVER_PY = $(src_dir)/gdbserver.py

default:	spike$(XLEN).log

all:	pylint spike32.log spike64.log

pylint:
	pylint --rcfile=pylint.rc *.py

%.log:
	$(GDBSERVER_PY) --isolate --$(subst .log,,$@) --server_cmd $(OPENOCD_DIR)/bin/openocd \
	    > $@ 2>&1 || (sed s/^/$@:\ / $@ && false)

clean:
	rm -f *.log *.pyc
