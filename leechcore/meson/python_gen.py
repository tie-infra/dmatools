import sys

inp, out = sys.argv[1], sys.argv[2]

# See https://github.com/ufrisk/LeechCore/blob/92967216d16096e95148807824e86116aca8c501/leechcorepyc/pkggen_linux.sh#L104-L107

content = """from .leechcorepyc import LeechCore

# CONSTANTS AUTO-GENERATED FROM 'leechcore.h' BELOW:
"""

with open(inp, "r") as f:
    for line in f:
        line = line.strip()
        if not line.startswith("#define LC_"):
            continue
        if "_VERSION " in line or "_FUNCTION_CALLBACK_" in line:
            continue
        content += (
            line.removeprefix("#define ").replace("0x", "= 0x", 1).replace("//", "#", 1)
            + "\n"
        )

with open(out, "w") as f:
    f.write(content)
