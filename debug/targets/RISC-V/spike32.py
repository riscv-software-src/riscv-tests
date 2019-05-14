import targets
import testlib

class spike32_hart(targets.Hart):
    xlen = 32
    ram = 0x10000000
    ram_size = 0x10000000
    instruction_hardware_breakpoint_count = 4
    reset_vectors = [0x1000]
    link_script_path = "spike32.lds"

class spike32(targets.Target):
    harts = [spike32_hart()]
    openocd_config_path = "spike-1.cfg"
    timeout_sec = 30
    implements_custom_test = True

    def create(self):
        # 64-bit FPRs on 32-bit target
        return testlib.Spike(self, isa="RV32IMAFDC", dmi_rti=4,
                support_abstract_csr=True, support_haltgroups=False)
