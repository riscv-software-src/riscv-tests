import spike32  # pylint: disable=import-error

import targets
import testlib

class spike32_pb(targets.Target):
    harts = [spike32.spike32_hart(misa=0x4034112d, progbufsize=6)]
    openocd_config_path = "spike-1.cfg"
    timeout_sec = 180
    implements_custom_test = True
    support_memory_sampling = False # Needs SBA
    freertos_binary = "bin/RTOSDemo32.axf"
    support_unavailable_control = True

    def create(self):
        # 64-bit FPRs on 32-bit target
        return testlib.Spike(self, isa="RV32IMAFDCV", dmi_rti=4,
                support_abstract_csr=True, support_haltgroups=False,
                # elen must be at least 64 because D is supported.
                elen=64, progbufsize=self.harts[0].progbufsize)
