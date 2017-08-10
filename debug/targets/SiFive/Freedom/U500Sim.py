import targets
import testlib

class U500Sim(targets.Target):
    xlen = 64
    timeout_sec = 6000
    ram = 0x80000000
    ram_size = 256 * 1024 * 1024
    instruction_hardware_breakpoint_count = 2
    openocd_config_path = "Freedom.cfg"
    link_script_path = "Freedom.lds"

    def create(self):
        return testlib.VcsSim(sim_cmd=self.sim_cmd, debug=False)
