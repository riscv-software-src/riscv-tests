import targets
import testlib

import spike32  # pylint: disable=import-error

class spike32_2(targets.Target):
    harts = [spike32.spike32_hart(), spike32.spike32_hart()]
    openocd_config_path = "spike-rtos.cfg"
    timeout_sec = 30
    implements_custom_test = True
    support_hasel = False

    def create(self):
        return testlib.Spike(self, progbufsize=0, dmi_rti=4,
                support_hasel=False, support_abstract_csr=True,
                support_haltgroups=False)
