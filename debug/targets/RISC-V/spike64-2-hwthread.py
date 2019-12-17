import targets
import testlib

import spike64  # pylint: disable=import-error

class spike64_2(targets.Target):
    harts = [spike64.spike64_hart(misa=0x8000000000141129),
            spike64.spike64_hart(misa=0x8000000000141129)]
    openocd_config_path = "spike-2-hwthread.cfg"
    timeout_sec = 5
    implements_custom_test = True

    def create(self):
        return testlib.Spike(self)
