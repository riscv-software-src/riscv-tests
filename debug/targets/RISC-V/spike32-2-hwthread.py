import targets
import testlib

import spike32  # pylint: disable=import-error

class spike32_2(targets.Target):
    harts = [spike32.spike32_hart(), spike32.spike32_hart()]
    openocd_config_path = "spike-2-hwthread.cfg"
    timeout_sec = 5
    implements_custom_test = True

    def create(self):
        return testlib.Spike(self, support_hasel=True,
                support_haltgroups=False)
