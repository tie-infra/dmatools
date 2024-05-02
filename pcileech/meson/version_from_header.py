import sys

version_define_prefix = "#define VERSION_"

version_header = sys.argv[1]

major, minor, revision, build = None, None, None, None

with open(version_header, "r") as f:
    for line in f:
        line = line.strip()
        if not line.startswith(version_define_prefix):
            continue
        line = line.removeprefix(version_define_prefix)
        component_name, _, version_component = line.partition(" ")
        v = int(version_component)
        match component_name:
            case "MAJOR":
                major = v
            case "MINOR":
                minor = v
            case "REVISION":
                revision = v
            case "BUILD":
                build = v
            case _:
                sys.exit(f"unknown version component {component_name}")

assert all(x is not None for x in [major, minor, revision, build])

print(f"{major}.{minor}.{revision}.{build}")
