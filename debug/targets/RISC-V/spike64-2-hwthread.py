import targets
import testlib

import spike64  # pylint: disable=import-error

class spike64_2(targets.Target):
    harts = [spike64.spike64_hart(), spike64.spike64_hart()]
    openocd_config_path = "spike-2-hwthread.cfg"
    timeout_sec = 5
    implements_custom_test = True

    def create(self):
        return testlib.Spike(self)
