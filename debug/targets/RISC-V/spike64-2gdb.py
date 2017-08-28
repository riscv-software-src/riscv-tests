import targets
import testlib

import spike64

class spike64_2gdb(targets.Target):
    harts = [spike64.spike64_hart(), spike64.spike64_hart()]
    openocd_config_path = "spike-2gdb.cfg"

    def create(self):
        return testlib.Spike(self)
