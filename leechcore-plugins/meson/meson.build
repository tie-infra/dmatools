project('leechcore-plugins', 'c')

add_project_arguments(
    '-D_GNU_SOURCE',
    '-DLINUX',
    '-fvisibility=hidden',
    '-w',
    language : 'c',
)

# TODO: we do not build microvmi driver since it requires dependencies that are
# not currently packaged in Nixpkgs (i.e. libmicrovmi and libkvmi).

threads_dep = dependency('threads')
libusb1_dep = dependency('libusb-1.0')

source_root = '..' / 'LeechCore-plugins'

incdir = include_directories(source_root / 'includes')

leechcore_ft601_driver_sources = []
foreach file_name : [
    'fpga_libusb.c',
    'leechcore_ft601_driver_linux.c',
]
    leechcore_ft601_driver_sources += files(
        source_root / 'leechcore_ft601_driver_linux' / file_name,
    )
endforeach

leechcore_device_rawtcp_sources = []
foreach file_name : [
    'leechcore_device_rawtcp.c',
    'oscompatibility.c',
]
    leechcore_device_rawtcp_sources += files(
        source_root / 'leechcore_device_rawtcp' / file_name,
    )
endforeach

leechcore_device_qemu_sources = []
foreach file_name : [
    'leechcore_device_qemu.c',
]
    leechcore_device_qemu_sources += files(
        source_root / 'leechcore_device_qemu' / file_name,
    )
endforeach

shared_module(
    'leechcore_ft601_driver_linux',
    sources : leechcore_ft601_driver_sources,
    include_directories : incdir,
    dependencies : [libusb1_dep, threads_dep],
    name_prefix : '',
    install : true,
)

shared_module(
    'leechcore_device_rawtcp',
    sources : leechcore_device_rawtcp_sources,
    include_directories : incdir,
    name_prefix : '',
    install : true,
)

shared_module(
    'leechcore_device_qemu',
    sources : leechcore_device_qemu_sources,
    include_directories : incdir,
    name_prefix : '',
    install : true,
)
