import targets
import testlib

import spike64  # pylint: disable=import-error

class spike64_2(targets.Target):
    harts = [spike64.spike64_hart(), spike64.spike64_hart()]
    openocd_config_path = "spike-2.cfg"
    # Increased timeout because we use abstract_rti to artificially slow things
    # down.
    timeout_sec = 20
    implements_custom_test = True
    support_hasel = False

    def create(self):
        return testlib.Spike(self, isa="RV64IMAFD", abstract_rti=30,
                support_hasel=False, support_abstract_csr=False)
