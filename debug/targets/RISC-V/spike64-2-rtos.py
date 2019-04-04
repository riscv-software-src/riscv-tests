import targets
import testlib

import spike64  # pylint: disable=import-error

class spike64_2_rtos(targets.Target):
    harts = [spike64.spike64_hart(), spike64.spike64_hart()]
    openocd_config_path = "spike-rtos.cfg"
    timeout_sec = 60
    implements_custom_test = True
    support_hasel = False

    def create(self):
        return testlib.Spike(self, abstract_rti=30, support_hasel=False,
                support_abstract_csr=False)
