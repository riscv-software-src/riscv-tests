import targets
import testlib

import spike64  # pylint: disable=import-error

class spike64_2(targets.Target):
    harts = [spike64.spike64_hart(), spike64.spike64_hart()]
    openocd_config_path = "spike-rtos.cfg"
    timeout_sec = 30

    def create(self):
        return testlib.Spike(self)
