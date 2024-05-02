project('leechcore', 'c')

add_project_arguments(
    '-D_GNU_SOURCE',
    '-DLINUX',
    '-fvisibility=hidden',
    '-w',
    language : 'c',
)

pkg = import('pkgconfig')
py = import('python').find_installation(get_option('python'), pure : false)
prog_python = py.path()
py_install_dir = py.get_install_dir()

dl_dep = dependency('dl')
threads_dep = dependency('threads')
libusb1_dep = dependency('libusb-1.0')

version_from_header = files('version_from_header.py')

leechcore_path = '..' / 'LeechCore'

leechcore_incdir = include_directories(leechcore_path / 'leechcore')

leechcore_version = run_command([
    prog_python, '--', version_from_header,
    files(leechcore_path / 'leechcore' / 'version.h'),
], check : true).stdout().strip()

leechcore_header = files(leechcore_path / 'leechcore' / 'leechcore.h')
leechcore_headers = leechcore_header + files(
    leechcore_path / 'leechcore' / 'leechcore_device.h',
)

leechcore_sources = []
foreach file_name : [
    'device_file.c',
    'device_fpga.c',
    'device_hibr.c',
    'device_pmem.c',
    'device_tmd.c',
    'device_usb3380.c',
    'device_vmm.c',
    'device_vmware.c',
    'leechcore.c',
    'leechrpcclient.c',
    'memmap.c',
    'ob/ob_bytequeue.c',
    'ob/ob_core.c',
    'ob/ob_map.c',
    'ob/ob_set.c',
    'oscompatibility.c',
    'util.c',
]
    leechcore_sources += files(leechcore_path / 'leechcore' / file_name)
endforeach

leechcorepyc_sources = []
foreach file_name : [
    'leechcorepyc.c',
    'leechcorepyc_barrequest.c',
    'oscompatibility.c',
]
    leechcorepyc_sources += files(leechcore_path / 'leechcorepyc' / file_name)
endforeach

leechcore = shared_library(
    'leechcore',
    sources : leechcore_sources,
    dependencies : [libusb1_dep, threads_dep, dl_dep],
    install : true,
)
leechcore_dep = declare_dependency(
    link_with : leechcore,
    include_directories : leechcore_incdir,
)

pkg.generate(
    leechcore,
    version : leechcore_version,
    description : 'LeechCore Memory Acquisition Library',
)

py.extension_module(
    'leechcorepyc',
    sources : leechcorepyc_sources,
    dependencies : leechcore_dep,
    subdir : 'leechcorepyc',
    install : true,
)
custom_target(
    'leechcorepyc_init',
    input : ['python_gen.py', leechcore_header],
    output : '__init__.py',
    command : [prog_python, '@INPUT@', '@OUTPUT@'],
    install_dir : py_install_dir / 'leechcorepyc',
    install : true,
)

install_headers(leechcore_headers)
