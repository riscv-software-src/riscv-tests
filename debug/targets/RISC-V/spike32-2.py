import targets
import testlib

import spike32

class spike32_2(targets.Target):
    harts = [spike32.spike32_hart(), spike32.spike32_hart()]
    openocd_config_path = "spike.cfg"

    def create(self):
        return testlib.Spike(self)