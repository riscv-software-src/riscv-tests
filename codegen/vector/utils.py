"""
Util functions
"""
import os
import struct


def save_to_file(filename, content):
    """
    When the content changes, save new :content to :filename.
    """
    os.makedirs(os.path.dirname(filename), exist_ok=True)
    try:
        file = open(filename, "r+", encoding="UTF-8")
    except FileNotFoundError as _:
        file = open(filename, "a+", encoding="UTF-8")
    if file.read() == content:
        return False
    file.seek(0)
    file.write(content)
    file.truncate()
    file.close()
    return True


def generate_test_data(nbytes, width=0):
    """Generate test data according to element width."""
    nquads = ceil_div(nbytes, 8)
    if width == 8:
        base_list = [
            0x000103F8FFEFEFFF,
            0x0001070001000100,
        ]
    elif width == 16:
        base_list = [
            0x000000010003FFF8,
            0x0000000100070000,
            0xFFFFEFFFEFFFFFFF,
            0x0001000000010000,
        ]
    elif width == 32:
        base_list = [
            0x0000000000000001,
            0x0000000000000001,
            0x00000003FFFFFFF8,
            0x0000000700000000,
            0xFFFFFFFFEFFFFFFF,
            0x0000000100000000,
            0xEFFFFFFFFFFFFFFF,
            0x0000000100000000,
        ]
    elif width == 64:
        base_list = [
            0x0000000000000000,
            0x0000000000000000,
            0x0000000000000001,
            0x0000000000000001,
            0x0000000000000003,
            0x0000000000000007,
            0xFFFFFFFFFFFFFFF8,
            0x0000000000000000,
            0xFFFFFFFFFFFFFFFF,
            0x0000000000000001,
            0xEFFFFFFFFFFFFFFF,
            0x0000000000000000,
            0xEFFFFFFFFFFFFFFF,
            0x0000000000000001,
            0xFFFFFFFFFFFFFFFF,
            0x0000000000000000,
        ]
    else:
        base_list = [
            0xBF80000040000000,
            0x40400000C0800000,
            0xDEADBEEFCAFEBABE,
            0xABAD1DEA1337D00D,
        ]

    return [e for _ in range(ceil_div(nquads, len(base_list))) for e in base_list][
        :nquads
    ]


def ceil_div(a, b):
    """Round up division."""
    return -1 * (-a // b)


def align_to(n, align):
    """Align :n by :align"""
    return (n + align - 1) // align * align


def inc(n):
    """Simple interger generator starts from :n"""
    while True:
        n += 1
        yield n


def get_element(n, index, width):
    """Get quad element by index and element width from a 64 bit interger."""
    return (n >> (width * index)) & (2**width - 1)


def byte_masked(index, width):
    """Test if the nth byte is masked under mask quad 0x55..5 by :index."""
    width = width // 8
    return (index % (2 * width) - index % width) == 0


def elem_mask(mask, index):
    """Get :mask's nth value by :index."""
    return (mask >> index) & 1


def merge_quads(q1, q2, mask, width):
    """Merge two quads based on mask and element width."""
    result = 0
    for i in range(64 // width):
        result += get_element(q1 if elem_mask(mask, i) else q2, i, width) << (width * i)

    return result


def rshift(val, n, bits):
    """Shift right."""
    mask = 2**bits - 1
    if val > 0:
        return (val >> n) & mask
    return (val // -(2 ^ n)) & mask


def lshift(val, n, bits):
    """Shift left."""
    mask = 2**bits - 1
    return (val << n) & mask


def floathex(f, width):
    """Get floating point hex representation as integer"""
    if width == 32:
        return int(hex(struct.unpack("<I", struct.pack("<f", f))[0]), 0)
    elif width == 64:
        return int(hex(struct.unpack("<Q", struct.pack("<d", f))[0]), 0)
    return 0

def cast_insts(reg, width, signed=True):
    """Generates instructions to convert :reg to :width wide, :signed or unsigned."""
    if width >= 64 or width < 0:
        return []
    sr = "srai" if signed else "srli"
    return [
        f"  slli {reg}, {reg}, {64-width}",
        f"  {sr} {reg}, {reg}, {64-width}",
    ]
