project('vmmyara', 'c')

add_project_arguments(
    '-D_GNU_SOURCE',
    '-DLINUX',
    '-fvisibility=hidden',
    '-w',
    language : 'c',
)

pkg = import('pkgconfig')
py = import('python').find_installation('python3')
prog_python = py.path()

yara_dep = dependency('yara')

version_from_header = files('version_from_header.py')

vmmyara_path = '..' / 'vmmyara'

vmmyara_version = run_command([
    prog_python, '--', version_from_header,
    files(vmmyara_path / 'vmmyara' / 'version.h'),
], check : true).stdout().strip()

vmmyara_headers = files(
    vmmyara_path / 'vmmyara' / 'vmmyara.h',
)
vmmyara_sources = files(
    vmmyara_path / 'vmmyara' / 'vmmyara.c',
)

vmmyara = shared_library(
    'vmmyara',
    sources : vmmyara_sources,
    dependencies : [yara_dep],
    install : true,
)

pkg.generate(
    vmmyara,
    version : vmmyara_version,
    description : 'YARA wrapper API for MemProcFS',
)

install_symlink(
    'vmmyara.so',
    install_dir : get_option('libdir'),
    pointing_to : 'libvmmyara.so',
)

install_headers(vmmyara_headers)
