import targets
import testlib

import spike32  # pylint: disable=import-error

class spike32_2(targets.Target):
    harts = [spike32.spike32_hart(misa=0x40341101),
            spike32.spike32_hart(misa=0x40341101)]
    openocd_config_path = "spike-2-hwthread.cfg"
    timeout_sec = 5
    implements_custom_test = True
    support_memory_sampling = False # not supported without sba

    def create(self):
        return testlib.Spike(self, isa="RV32IMAV", support_hasel=True,
                support_haltgroups=False)
