import spike64  # pylint: disable=import-error

import targets
import testlib

class spike64(targets.Target):
    harts = [spike64.spike64_hart(progbufsize=6)]
    openocd_config_path = "spike-1.cfg"
    timeout_sec = 180
    implements_custom_test = True
    freertos_binary = "bin/RTOSDemo64.axf"
    support_unavailable_control = True

    def create(self):
        # 32-bit FPRs only
        return testlib.Spike(self, isa="RV64IMAFC", 
                progbufsize=self.harts[0].progbufsize,
                abstract_rti=30, support_abstract_csr=True,
                support_abstract_fpr=True)

