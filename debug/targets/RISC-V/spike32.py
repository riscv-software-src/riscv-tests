import targets
import testlib

class spike32_hart(targets.Hart):
    xlen = 32
    ram = 0x10000000
    ram_size = 0x10000000
    instruction_hardware_breakpoint_count = 4
    reset_vectors = [0x1000]
    link_script_path = "spike32.lds"

    def __init__(self, misa):
        self.misa = misa

class spike32(targets.Target):
    harts = [spike32_hart(misa=0x4034112d)]
    openocd_config_path = "spike-1.cfg"
    timeout_sec = 30
    implements_custom_test = True

    def create(self):
        # 64-bit FPRs on 32-bit target
        return testlib.Spike(self, isa="RV32IMAFDCV", dmi_rti=4,
                support_abstract_csr=True, support_haltgroups=False,
                # elen must be at least 64 because D is supported.
                elen=64)
