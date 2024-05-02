project('pcileech', 'c')

add_project_arguments(
    '-D_GNU_SOURCE',
    '-DLINUX',
    '-fvisibility=hidden',
    '-w',
    language : 'c',
)

py = import('python').find_installation('python3')
prog_python = py.path()

leechcore_dep = dependency('leechcore')
vmm_dep = dependency('vmm')
fuse_dep = dependency('fuse')

version_from_header = files('version_from_header.py')

source_root = '..' / 'pcileech'

pcileech_version = run_command([
    prog_python, '--', version_from_header,
    files(source_root / 'pcileech' / 'version.h'),
], check : true).stdout().strip()

pcileech_sources = []
foreach file_name : [
    'charutil.c',
    'device.c',
    'executor.c',
    'extra.c',
    'help.c',
    'kmd.c',
    'memdump.c',
    'mempatch.c',
    'ob/ob_cachemap.c',
    'ob/ob_core.c',
    'ob/ob_map.c',
    'ob/ob_set.c',
    'oscompatibility.c',
    'pcileech.c',
    'statistics.c',
    'umd.c',
    'util.c',
    'vfs.c',
    'vfslist.c',
    'vmmx.c',
]
    pcileech_sources += files(source_root / 'pcileech' / file_name)
endforeach

executable(
    'pcileech',
    sources : pcileech_sources,
    dependencies : [vmm_dep, leechcore_dep, fuse_dep],
    install : true,
)
