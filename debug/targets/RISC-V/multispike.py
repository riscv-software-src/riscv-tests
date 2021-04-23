import targets
import testlib

import spike32  # pylint: disable=import-error
import spike64  # pylint: disable=import-error

class multispike(targets.Target):
    harts = [
        spike32.spike32_hart(misa=0x4034112d),
        spike32.spike32_hart(misa=0x4034112d),
        spike64.spike64_hart(misa=0x8000000000341129),
        spike64.spike64_hart(misa=0x8000000000341129)]
    openocd_config_path = "multispike.cfg"
    # Increased timeout because we use abstract_rti to artificially slow things
    # down.
    timeout_sec = 20
    implements_custom_test = True
    support_hasel = False
    support_memory_sampling = False # Needs SBA

    def create(self):
        # TODO: It would be nice to test with slen=128, but spike currently
        # requires vlen==slen.
        return testlib.MultiSpike(
            [testlib.Spike(self, isa="RV64IMAFDV", abstract_rti=30,
                           support_hasel=False, support_abstract_csr=False,
                           vlen=512, elen=64, slen=512, harts=self.harts[:2]),
             testlib.Spike(self, isa="RV32IMAFDCV", dmi_rti=4,
                           support_abstract_csr=True, support_haltgroups=False,
                           # elen must be at least 64 because D is supported.
                           elen=64, harts=self.harts[2:])
             ])
