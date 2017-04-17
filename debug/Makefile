RISCV_SIM ?= spike
XLEN ?= 64

OPENOCD_INSTALL ?= $(abspath .)/openocd-install
OPENOCD_VERSION = 860b42a3c4f6aa37d8d4fe50a71000b7cff66b85

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
