#!/usr/bin/python3

"""
Generate RV64 tests.
"""

import os
import sys
import math
from constants import VLEN
from templates import (
    TEMPLATE_HEADER,
    VLRE_TEMPLATE,
    MAKEFRAG_TEMPLATE,
    VLE_CODE_TEMPLATE,
    VLSE_TEMPLATE,
    VSE_CODE_TEMPLATE,
    MASK_CODE,
    ARITH_VF_CODE_TEMPLATE,
    ARITH_VI_CODE_TEMPLATE,
    ARITH_VV_CODE_TEMPLATE,
    ARITH_VX_CODE_TEMPLATE,
    ARITH_TEMPLATE,
)
from utils import (
    byte_masked,
    generate_test_data,
    inc,
    get_element,
    merge_quads,
    save_to_file,
    lshift,
    rshift,
    floathex,
    cast_insts,
)


class CodegenBase:
    """Codegen base class."""

    class Option:
        """Codegen base option."""

        def __init__(self, filename):
            self.filename = filename

        def nbytes(self):
            """Number of bytes for data needs to process."""
            return 0

    def __str__(self):
        return "Not implemented."


class Vlre(CodegenBase):
    """Generate vl<NF>re<EEW>.v tests."""

    class Option(CodegenBase.Option):
        """Vlre option."""

        def __init__(self, filename, nf, eew):
            super().__init__(filename)
            self.nf = nf
            self.eew = eew

        def nbytes(self):
            return (VLEN // 8) * self.nf

    def __init__(self, option):
        self.option = option

    def __str__(self):
        nbytes = self.option.nbytes()
        test_data = generate_test_data(nbytes)
        test_cases = "\n".join(
            [
                f"  TEST_CASE({i+2}, t0, 0x{test_data[i]:x}, ld t0, 0(a1); addi a1, a1, 8)"
                for i in range(nbytes // 8)
            ]
        )
        test_data_str = "\n".join([f"  .quad 0x{e:x}" for e in test_data])
        return (TEMPLATE_HEADER + VLRE_TEMPLATE).format(
            filename=self.option.filename,
            inst_name=f"vl{self.option.nf}re{self.option.eew}.v",
            extras="",
            nf=self.option.nf,
            nbytes=nbytes,
            eew=self.option.eew,
            test_cases=test_cases,
            test_data_str=test_data_str,
        )


class Vlse(CodegenBase):
    """Generate vle<EEW>.v, vse<EEW>.v tests."""

    class Option(CodegenBase.Option):
        """Vlse option."""

        def __init__(self, filename, inst, lmul, eew, vl):
            super().__init__(filename)
            self.inst = inst
            self.lmul = lmul
            self.eew = eew
            self.vl = vl

        def nbytes(self):
            return (self.vl * self.eew) // 8

    def __init__(self, option):
        self.option = option

    def __str__(self):
        nbytes = self.option.nbytes()
        nquads = nbytes // 8
        remaining_bytes = nbytes % 8
        test_data_bytes = (VLEN * self.option.lmul) // 8 + 8
        test_data = generate_test_data(test_data_bytes)
        test_data_str = "\n".join([f"  .quad 0x{e:x}" for e in test_data])

        start = inc(2)
        code_template = (
            VSE_CODE_TEMPLATE if self.option.inst == "vse" else VLE_CODE_TEMPLATE
        )
        code_vm0_ta_ma = code_template.format(
            lmul=self.option.lmul,
            eew=self.option.eew,
            vl=self.option.vl,
            mask_code="",
            v0t="",
            vma="ma",
            vta="ta",
        )
        test_cases_vm0_ta_ma = [
            f"  TEST_CASE({next(start)}, t0, 0x{test_data[i]:x}, ld t0, 0(a1); addi a1, a1, 8)"
            for i in range(nquads)
        ]
        test_cases_vm0_ta_ma += [
            f"  TEST_CASE({next(start)}, t0, 0x{get_element(test_data[nquads], i, 8):x}, lbu t0, 0(a1); addi a1, a1, 1)"
            for i in range(remaining_bytes)
        ]

        code_vm1_ta_ma = code_template.format(
            lmul=self.option.lmul,
            eew=self.option.eew,
            vl=self.option.vl,
            mask_code=MASK_CODE,
            v0t=", v0.t",
            vma="ma",
            vta="ta",
        )
        test_cases_vm1_ta_ma = []
        for i in range(nbytes):
            if byte_masked(i, self.option.eew):
                elem = get_element(test_data[i // 8], i % 8, 8)
                test_cases_vm1_ta_ma.append(
                    f"  TEST_CASE({next(start)}, t0, 0x{elem:x}, lbu t0, 0(a1); addi a1, a1, 1)"
                )
            else:
                test_cases_vm1_ta_ma.append("  addi a1, a1, 1")

        code_vm0_tu_ma = code_template.format(
            lmul=self.option.lmul,
            eew=self.option.eew,
            vl=self.option.vl,
            mask_code="",
            v0t="",
            vma="ma",
            vta="tu",
        )
        test_cases_vm0_tu_ma = [
            f"  TEST_CASE({next(start)}, t0, 0x{test_data[i]:x}, ld t0, 0(a1); addi a1, a1, 8)"
            for i in range(nquads)
        ]
        if remaining_bytes != 0:
            remaining_bits = remaining_bytes * 8
            tail_bits = 64 - remaining_bits
            data = rshift(
                lshift(test_data[nquads], tail_bits, 64), tail_bits, 64
            ) + lshift(
                rshift(test_data[nquads + 1], remaining_bits, 64), remaining_bits, 64
            )
            test_cases_vm0_tu_ma.append(
                f"  TEST_CASE({next(start)}, t0, 0x{data:x}, ld t0, 0(a1); addi a1, a1, 8)"
            )

        code_vm1_ta_mu = code_template.format(
            lmul=self.option.lmul,
            eew=self.option.eew,
            vl=self.option.vl,
            mask_code=MASK_CODE,
            v0t=", v0.t",
            vma="mu",
            vta="ta",
        )
        test_cases_vm1_ta_mu = []
        for i in range(nquads):
            mask = int(i % 2 == 0) if self.option.eew == 64 else 0x55
            elem = merge_quads(test_data[i], test_data[i + 1], mask, self.option.eew)
            test_cases_vm1_ta_mu.append(
                f"  TEST_CASE({next(start)}, t0, 0x{elem:x}, ld t0, 0(a1); addi a1, a1, 8)"
            )
        for i in range(remaining_bytes):
            if byte_masked(i, self.option.eew):
                elem = get_element(test_data[nquads], i, 8)
            else:
                elem = get_element(test_data[nquads + 1], i, 8)
            test_cases_vm1_ta_mu.append(
                f"  TEST_CASE({next(start)}, t0, 0x{elem:x}, lbu t0, 0(a1); addi a1, a1, 1)"
            )

        return (TEMPLATE_HEADER + VLSE_TEMPLATE).format(
            filename=self.option.filename,
            inst_name=f"{self.option.inst}{self.option.eew}.v",
            extras=f"With LMUL={self.option.lmul}, VL={self.option.vl}",
            nbytes=test_data_bytes,
            test_data_str=test_data_str,
            code_vm0_ta_ma=code_vm0_ta_ma,
            code_vm1_ta_ma=code_vm1_ta_ma,
            code_vm0_tu_ma=code_vm0_tu_ma,
            code_vm1_ta_mu=code_vm1_ta_mu,
            test_cases_vm0_ta_ma="\n".join(test_cases_vm0_ta_ma),
            test_cases_vm1_ta_ma="\n".join(test_cases_vm1_ta_ma),
            test_cases_vm0_tu_ma="\n".join(test_cases_vm0_tu_ma),
            test_cases_vm1_ta_mu="\n".join(test_cases_vm1_ta_mu),
        )


class Arith(CodegenBase):
    """Generate arith instruction tests."""

    class Option(CodegenBase.Option):
        """Arith option."""

        def __init__(self, filename, inst, lmul, sew, vl, suffix):
            super().__init__(filename)
            self.inst = inst
            self.lmul = lmul
            self.sew = sew
            self.vl = vl
            self.suffix = suffix

        def nbytes(self):
            return (self.vl * self.sew) // 8

    def __init__(self, option):
        self.option = option

    def __str__(self):
        nbytes = self.option.nbytes()
        nquads = nbytes // 8
        test_data_bytes = (VLEN * self.option.lmul) // 8 + 8
        test_data = generate_test_data(test_data_bytes, width=self.option.sew)
        test_data_str = "\n".join([f"  .quad 0x{e:x}" for e in test_data])
        scalar_code = "\n".join(self.generate_scalar_code())
        start = inc(2)
        if self.option.suffix in ["vv", "vvm"]:
            code_template = ARITH_VV_CODE_TEMPLATE
        elif self.option.suffix in ["vi", "vim"]:
            code_template = ARITH_VI_CODE_TEMPLATE
        elif self.option.suffix in ["vx", "vxm"]:
            code_template = ARITH_VX_CODE_TEMPLATE
        elif self.option.suffix in ["vf"]:
            code_template = ARITH_VF_CODE_TEMPLATE
        else:
            raise Exception("Unknown suffix.")

        code_vm0_ta_ma = code_template.format(
            sew=self.option.sew,
            lmul=self.option.lmul,
            vl=self.option.vl,
            mask_code=MASK_CODE if self.option.suffix.endswith("m") else "",
            vta="ta",
            vma="ma",
            v0t=", v0" if self.option.suffix.endswith("m") else "",
            op=f"v{self.option.inst}.{self.option.suffix}",
            imm=floathex(1.0, self.option.sew)
            if self.option.inst.startswith("f")
            else 1,
            fmv_unit="w" if self.option.sew == 32 else "d",
            vd=self.option.lmul,
            vs1=self.option.lmul * 2,
            vs2=self.option.lmul * 3,
        )
        test_cases_vm0_ta_ma = [
            f"  TEST_CASE_REG({next(start)}, t0, t1, ld t0, 0(a1); ld t1, 0(a2); addi a1, a1, 8; addi a2, a2, 8)"
            for i in range(nquads)
        ]

        code_vm1_ta_ma = ""
        test_cases_vm1_ta_ma = []
        if not self.option.suffix.endswith("m"):
            code_vm1_ta_ma = code_template.format(
                sew=self.option.sew,
                lmul=self.option.lmul,
                vl=self.option.vl,
                mask_code=MASK_CODE,
                vta="ta",
                vma="ma",
                v0t=", v0.t",
                op=f"v{self.option.inst}.{self.option.suffix}",
                imm=floathex(1, self.option.sew)
                if self.option.inst.startswith("f")
                else 1,
                fmv_unit="w" if self.option.sew == 32 else "d",
                vd=self.option.lmul,
                vs1=self.option.lmul * 2,
                vs2=self.option.lmul * 3,
            )
            for i in range(nbytes):
                if byte_masked(i, self.option.sew):
                    test_cases_vm1_ta_ma.append(
                        f"  TEST_CASE_REG({next(start)}, t0, t1, lbu t0, 0(a1); lbu t1, 0(a2); addi a1, a1, 1; addi a2, a2, 1)"
                    )
                else:
                    test_cases_vm1_ta_ma.append("  addi a1, a1, 1; addi a2, a2, 1;")

        code_vm0_tu_ma = code_template.format(
            sew=self.option.sew,
            lmul=self.option.lmul,
            vl=self.option.vl,
            mask_code=MASK_CODE if self.option.suffix.endswith("m") else "",
            vta="tu",
            vma="ma",
            v0t=", v0" if self.option.suffix.endswith("m") else "",
            op=f"v{self.option.inst}.{self.option.suffix}",
            imm=floathex(1, self.option.sew) if self.option.inst.startswith("f") else 1,
            fmv_unit="w" if self.option.sew == 32 else "d",
            vd=self.option.lmul,
            vs1=self.option.lmul * 2,
            vs2=self.option.lmul * 3,
        )
        test_cases_vm0_tu_ma = [
            f"  TEST_CASE_REG({next(start)}, t0, t1, ld t0, 0(a1); ld t1, 0(a2); addi a1, a1, 8; addi a2, a2, 8)"
            for i in range(nquads)
        ]

        code_vm1_ta_mu = ""
        test_cases_vm1_ta_mu = []
        if not self.option.suffix.endswith("m"):
            code_vm1_ta_mu = code_template.format(
                sew=self.option.sew,
                lmul=self.option.lmul,
                vl=self.option.vl,
                mask_code=MASK_CODE,
                vta="ta",
                vma="ma",
                v0t=", v0" if self.option.suffix.endswith("m") else ", v0.t",
                op=f"v{self.option.inst}.{self.option.suffix}",
                imm=floathex(1, self.option.sew)
                if self.option.inst.startswith("f")
                else 1,
                fmv_unit="w" if self.option.sew == 32 else "d",
                vd=self.option.lmul,
                vs1=self.option.lmul * 2,
                vs2=self.option.lmul * 3,
            )
            for i in range(nbytes):
                if byte_masked(i, self.option.sew):
                    test_cases_vm1_ta_mu.append(
                        f"  TEST_CASE_REG({next(start)}, t0, t1, lbu t0, 0(a1); lbu t1, 0(a2); addi a1, a1, 1; addi a2, a2, 1)"
                    )
                else:
                    elem = get_element(test_data[i // 8], i % 8, 8)
                    test_cases_vm1_ta_mu.append(
                        f"  TEST_CASE({next(start)}, t0, 0x{elem:x}, lbu t0, 0(a1); addi a1, a1, 1; addi a2, a2, 1)"
                    )

        return (TEMPLATE_HEADER + ARITH_TEMPLATE).format(
            filename=self.option.filename,
            inst_name=f"v{self.option.inst}.{self.option.suffix}",
            extras=f"With LMUL={self.option.lmul}, SEW={self.option.sew}, VL={self.option.vl}",
            nbytes=test_data_bytes,
            scalar_code=scalar_code,
            test_data=test_data_str,
            code_vm0_ta_ma=code_vm0_ta_ma,
            code_vm1_ta_ma=code_vm1_ta_ma,
            code_vm0_tu_ma=code_vm0_tu_ma,
            code_vm1_ta_mu=code_vm1_ta_mu,
            test_cases_vm0_ta_ma="\n".join(test_cases_vm0_ta_ma),
            test_cases_vm1_ta_ma="\n".join(test_cases_vm1_ta_ma),
            test_cases_vm0_tu_ma="\n".join(test_cases_vm0_tu_ma),
            test_cases_vm1_ta_mu="\n".join(test_cases_vm1_ta_mu),
        )

    def generate_scalar_code(self, imm=1):
        """Generate scalar code."""
        inst = self.option.inst
        sew = self.option.sew
        lmul = self.option.lmul
        vl = self.option.vl
        if inst in ["div", "mulh", "mulhsu", "mulhu", "rem"]:
            ld_t = {8: "b", 16: "h", 32: "w", 64: "d"}[sew]
        else:
            ld_t = {8: "bu", 16: "hu", 32: "wu", 64: "d"}[sew]
        st_t = {8: "b", 16: "h", 32: "w", 64: "d"}[sew]
        label_gen = inc(0)

        elems = int(min(lmul * (VLEN // sew), vl))
        result = ["  la a1, tdat", "  la a3, sres"]
        if self.option.suffix in ["vv", "vvm"]:
            result.append("  la a2, tdat+8")

        for i in range(elems):
            label = next(label_gen)
            if inst in [
                "add",
                "sub",
                "and",
                "or",
                "xor",
                "divu",
                "div",
                "rem",
                "remu",
                "mulhu",
                "mul",
                "mulhsu",
                "mulh",
            ]:
                code = f"  {inst} a5, a4, a5"
            elif inst == "rsub":
                code = "  sub a5, a5, a4"
            elif inst in ["minu", "maxu"]:
                op = "bltu" if inst == "minu" else "bgtu"
                code = "\n".join(
                    [
                        f"  {op} a5, a4, .ASL{label}",
                        "  mv a5, a4",
                        f".ASL{label}:",
                    ]
                )
            elif inst in ["min", "max"]:
                op = "blt" if inst == "min" else "bgt"
                code = "\n".join(
                    cast_insts("a4", sew)
                    + cast_insts("a5", sew)
                    + [
                        f"  {op} a5, a4, .ASL{label}",
                        "  mv a5, a4",
                        f".ASL{label}:",
                    ]
                )
            elif inst == "rgather":
                vlmax = (VLEN // sew) * lmul
                code = "\n".join(
                    [
                        "  li a4, 0",
                        f"  li a6, {vlmax}",
                        f"  bgtu a5, a6, .ASL{label}",
                        f"  li a4, {sew // 8}",
                        "  mul a5, a5, a4",
                        "  add a4, a1, a5",
                        f"  l{ld_t} a4, 0(a4)",
                        f".ASL{label}:",
                        "  mv a5, a4",
                    ]
                )
            elif inst == "slideup":
                if i < imm:
                    nbytes = i * (sew // 8)
                else:
                    nbytes = (i - imm) * (sew // 8)
                code = f"  l{ld_t} a5, {nbytes}(a1)"
            elif inst == "slidedown":
                vlmax = (VLEN // sew) * lmul
                if i + imm < vlmax:
                    nbytes = (i + imm) * (sew // 8)
                    code = f"  l{ld_t} a5, {nbytes}(a1)"
                else:
                    code = "  li a5, 0"
            elif inst == "adc":
                insts = ["  add a5, a4, a5"]
                if i % 2 == 0:
                    insts.append("  addi a5, a5, 1")
                code = "\n".join(insts)
            elif inst == "sbc":
                insts = ["  sub a5, a4, a5"]
                if i % 2 == 0:
                    insts.append("  addi a5, a5, -1")
                code = "\n".join(insts)
            elif inst == "merge":
                code = ""
                if i % 2 == 1:
                    nbytes = i * (sew // 8)
                    code = f"  l{ld_t} a5, {nbytes}(a1)"
            elif inst == "saddu":
                code = "\n".join(
                    ["  add a5, a4, a5"]
                    + cast_insts("a5", sew, signed=False)
                    + [
                        f"  bgeu a5, a4, .ASL{label}",
                        "  li a5, -1",
                        f".ASL{label}:",
                    ]
                )
            elif inst in ["sll", "srl", "sra"]:
                code = "\n".join(
                    (cast_insts("a4", sew) if inst == "sra" else [])
                    + cast_insts("a5", int(math.log2(sew)), signed=False)
                    + [f"  {inst} a5, a4, a5"]
                )
            elif inst in ["fadd", "fsub", "fmin", "fmax", "fsgnj", "fsgnjn", "fsgnjx"]:
                unit = "s" if sew == 32 else "d"
                mv_unit = "w" if sew == 32 else "d"
                code = "\n".join(
                    [
                        f"  fmv.{mv_unit}.x f1, a4",
                        f"  fmv.{mv_unit}.x f2, a5",
                        f"  {inst}.{unit} f2, f1, f2",
                        f"  fmv.x.{mv_unit} a5, f2",
                    ]
                )
            else:
                raise Exception("Unknown inst.")

            nbytes = i * (sew // 8)
            if self.option.suffix in ["vv", "vvm"]:
                result += [
                    f"  l{ld_t} a4, {nbytes}(a1)",
                    f"  l{ld_t} a5, {nbytes}(a2)",
                    code,
                    f"  s{st_t} a5, {nbytes}(a3)",
                ]
            elif self.option.suffix in ["vi", "vx", "vim", "vxm"]:
                result += [
                    f"  l{ld_t} a4, {nbytes}(a1)",
                    f"  li a5, {imm}",
                    code,
                    f"  s{st_t} a5, {nbytes}(a3)",
                ]
            elif self.option.suffix in ["vf"]:
                result += [
                    f"  l{ld_t} a4, {nbytes}(a1)",
                    f"  li a5, {floathex(imm, sew)}",
                    code,
                    f"  s{st_t} a5, {nbytes}(a3)",
                ]
            else:
                raise Exception("Unknown suffix.")

        return result


def main():
    """Main function."""
    for nf in [1, 2, 4, 8]:
        for eew in [8, 16, 32, 64]:
            filename = f"isa/rv64uv/vl{nf}re{eew}_v.S"
            save_to_file(filename, str(Vlre(Vlre.Option(filename, nf, eew))))

    for lmul in [1, 2, 4, 8]:
        for eew in [8, 16, 32, 64]:
            vlmax = (VLEN // eew) * lmul
            for vl in [vlmax // 2, vlmax - 1, vlmax]:
                for inst in ["vle", "vse"]:
                    filename = f"isa/rv64uv/{inst}{eew}_v_LMUL{lmul}VL{vl}.S"
                    vlse = Vlse(Vlse.Option(filename, inst, lmul, eew, vl))
                    save_to_file(filename, str(vlse))

    for lmul in [1, 2, 4, 8]:
        for sew in [8, 16, 32, 64]:
            vlmax = (VLEN // sew) * lmul
            for vl in [vlmax // 2, vlmax - 1, vlmax]:
                for inst in [
                    "add",
                    "sub",
                    "minu",
                    "min",
                    "maxu",
                    "max",
                    "and",
                    "or",
                    "xor",
                    "divu",
                    "div",
                    "rem",
                    "remu",
                    "mulhu",
                    "mul",
                    "mulhsu",
                    "mulh",
                    "rgather",
                    "saddu",
                    "sll",
                    "srl",
                    "sra",
                ]:
                    filename = f"isa/rv64uv/v{inst}_vv_LMUL{lmul}SEW{sew}VL{vl}.S"
                    arith = Arith(Arith.Option(filename, inst, lmul, sew, vl, "vv"))
                    save_to_file(filename, str(arith))

                for inst in [
                    "add",
                    "rsub",
                    "and",
                    "or",
                    "xor",
                    "rgather",
                    "slideup",
                    "slidedown",
                    "saddu",
                    "sll",
                    "srl",
                    "sra",
                ]:
                    filename = f"isa/rv64uv/v{inst}_vi_LMUL{lmul}SEW{sew}VL{vl}.S"
                    arith = Arith(Arith.Option(filename, inst, lmul, sew, vl, "vi"))
                    save_to_file(filename, str(arith))
                for inst in [
                    "add",
                    "sub",
                    "rsub",
                    "minu",
                    "min",
                    "maxu",
                    "max",
                    "and",
                    "or",
                    "xor",
                    "divu",
                    "div",
                    "rem",
                    "remu",
                    "mulhu",
                    "mul",
                    "mulhsu",
                    "mulh",
                    "rgather",
                    "slideup",
                    "slidedown",
                    "saddu",
                    "sll",
                    "srl",
                    "sra",
                ]:
                    filename = f"isa/rv64uv/v{inst}_vx_LMUL{lmul}SEW{sew}VL{vl}.S"
                    arith = Arith(Arith.Option(filename, inst, lmul, sew, vl, "vx"))
                    save_to_file(filename, str(arith))
                for inst in ["adc", "sbc", "merge"]:
                    filename = f"isa/rv64uv/v{inst}_vvm_LMUL{lmul}SEW{sew}VL{vl}.S"
                    arith = Arith(Arith.Option(filename, inst, lmul, sew, vl, "vvm"))
                    save_to_file(filename, str(arith))
                for inst in ["adc", "merge"]:
                    filename = f"isa/rv64uv/v{inst}_vim_LMUL{lmul}SEW{sew}VL{vl}.S"
                    arith = Arith(Arith.Option(filename, inst, lmul, sew, vl, "vim"))
                    save_to_file(filename, str(arith))
                for inst in ["adc", "sbc", "merge"]:
                    filename = f"isa/rv64uv/v{inst}_vxm_LMUL{lmul}SEW{sew}VL{vl}.S"
                    arith = Arith(Arith.Option(filename, inst, lmul, sew, vl, "vxm"))
                    save_to_file(filename, str(arith))

        for sew in [32, 64]:
            vlmax = (VLEN // sew) * lmul
            for vl in [vlmax // 2, vlmax - 1, vlmax]:
                for inst in [
                    "fadd",
                    "fsub",
                    "fmin",
                    "fmax",
                    "fsgnj",
                    "fsgnjn",
                    "fsgnjx",
                ]:
                    filename = f"isa/rv64uv/v{inst}_vv_LMUL{lmul}SEW{sew}VL{vl}.S"
                    arith = Arith(Arith.Option(filename, inst, lmul, sew, vl, "vv"))
                    save_to_file(filename, str(arith))
                for inst in [
                    "fadd",
                    "fsub",
                    "fmin",
                    "fmax",
                    "fsgnj",
                    "fsgnjn",
                    "fsgnjx",
                ]:
                    filename = f"isa/rv64uv/v{inst}_vf_LMUL{lmul}SEW{sew}VL{vl}.S"
                    arith = Arith(Arith.Option(filename, inst, lmul, sew, vl, "vf"))
                    save_to_file(filename, str(arith))

    files = []
    for file in sorted(os.listdir("isa/rv64uv")):
        if file.startswith("v"):
            filename = file.rstrip(".S")
            files.append(f"  {filename} \\")
    with open("isa/rv64uv/Makefrag", "w", encoding="UTF-8") as f:
        f.write(MAKEFRAG_TEMPLATE.format(data="\n".join(files)))


if __name__ == "__main__":
    sys.exit(main())
