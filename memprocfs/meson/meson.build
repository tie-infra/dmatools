project('memprocfs', 'c')

add_project_arguments(
    '-D_GNU_SOURCE',
    '-DLINUX',
    '-fvisibility=hidden',
    '-w',
    language : 'c',
)

libdir = get_option('libdir')
infodb = get_option('infodb')

pkg = import('pkgconfig')
py = import('python').find_installation(get_option('python'), pure : false)
prog_python = py.path()
py_install_dir = py.get_install_dir()

cc = meson.get_compiler('c')
m_dep = cc.find_library('m', required : false)

dl_dep = dependency('dl')
threads_dep = dependency('threads')
leechcore_dep = dependency('leechcore')
lz4_dep = dependency('liblz4')
openssl_dep = dependency('openssl')
fuse_dep = dependency('fuse')

version_from_header = files('version_from_header.py')

source_root = '..' / 'MemProcFS'

files_path = source_root / 'files'
memprocfs_py_file = files(files_path / 'memprocfs.py')
vmmpyplugin_py_file = files(files_path / 'vmmpyplugin.py')

plugins_path = files_path / 'plugins'
pym_procstruct_files = files(
    plugins_path / 'pym_procstruct' / '__init__.py',
    plugins_path / 'pym_procstruct' / 'pym_procstruct.py',
)
pyp_files = files(
    plugins_path / 'pyp_reg_root_reg$net_bth$devices.py',
    plugins_path / 'pyp_reg_root_reg$net_tcpip$interfaces.py',
    plugins_path / 'pyp_reg_root_reg$usb_usb$devices.py',
    plugins_path / 'pyp_reg_root_reg$usb_usb$storage.py',
    plugins_path / 'pyp_reg_user_reg$user_wallpaper.py',
)

vmm_version = run_command([
    prog_python, '--', version_from_header,
    files(source_root / 'vmm' / 'version.h'),
], check : true).stdout().strip()

incdir = include_directories(source_root / 'includes')
vmm_incdir = include_directories(source_root / 'vmm')

vmm_headers = files(
    source_root / 'vmm' / 'vmmdll.h',
)

vmm_sources = []
foreach file_name : [
    'charutil.c',
    'ext/miniz.c',
    'ext/sha256.c',
    'ext/sqlite3.c',
    'fc.c',
    'infodb.c',
    'mm/mm_arm64.c',
    'mm/mm_pfn.c',
    'mm/mm_vad.c',
    'mm/mm_win.c',
    'mm/mm_x64.c',
    'mm/mm_x86.c',
    'mm/mm_x86pae.c',
    'modules/m_conf.c',
    'modules/m_evil_av1.c',
    'modules/m_evil_kern1.c',
    'modules/m_evil_kernproc1.c',
    'modules/m_evil_proc1.c',
    'modules/m_evil_proc2.c',
    'modules/m_evil_proc3.c',
    'modules/m_evil_thread1.c',
    'modules/m_fc_csv.c',
    'modules/m_fc_file.c',
    'modules/m_fc_findevil.c',
    'modules/m_fc_handle.c',
    'modules/m_fc_json.c',
    'modules/m_fc_module.c',
    'modules/m_fc_ntfs.c',
    'modules/m_fc_proc.c',
    'modules/m_fc_registry.c',
    'modules/m_fc_sys.c',
    'modules/m_fc_thread.c',
    'modules/m_fc_timeline.c',
    'modules/m_fc_web.c',
    'modules/m_fc_yara.c',
    'modules/m_misc_bitlocker.c',
    'modules/m_misc_eventlog.c',
    'modules/m_misc_procinfo.c',
    'modules/m_misc_view.c',
    'modules/m_phys2virt.c',
    'modules/m_proc_file_handles_vads.c',
    'modules/m_proc_file_modules.c',
    'modules/m_proc_handle.c',
    'modules/m_proc_heap.c',
    'modules/m_proc_ldrmodules.c',
    'modules/m_proc_memmap.c',
    'modules/m_proc_minidump.c',
    'modules/m_proc_thread.c',
    'modules/m_proc_token.c',
    'modules/m_proc_virt2phys.c',
    'modules/m_search.c',
    'modules/m_searchyara.c',
    'modules/m_sys.c',
    'modules/m_sys_driver.c',
    'modules/m_sys_mem.c',
    'modules/m_sys_net.c',
    'modules/m_sys_obj.c',
    'modules/m_sys_pool.c',
    'modules/m_sys_proc.c',
    'modules/m_sys_svc.c',
    'modules/m_sys_syscall.c',
    'modules/m_sys_sysinfo.c',
    'modules/m_sys_task.c',
    'modules/m_sys_user.c',
    'modules/m_vfsfc.c',
    'modules/m_vfsproc.c',
    'modules/m_vfsroot.c',
    'modules/m_vm.c',
    'modules/m_winreg.c',
    'ob/ob_bytequeue.c',
    'ob/ob_cachemap.c',
    'ob/ob_compressed.c',
    'ob/ob_container.c',
    'ob/ob_core.c',
    'ob/ob_counter.c',
    'ob/ob_map.c',
    'ob/ob_memfile.c',
    'ob/ob_set.c',
    'ob/ob_strmap.c',
    'oscompatibility.c',
    'pdb.c',
    'pe.c',
    'pluginmanager.c',
    'statistics.c',
    'sysquery.c',
    'util.c',
    'vmm.c',
    'vmmdll.c',
    'vmmdll_core.c',
    'vmmdll_remote.c',
    'vmmdll_scatter.c',
    'vmmheap.c',
    'vmmlog.c',
    'vmmnet.c',
    'vmmproc.c',
    'vmmuserconfig.c',
    'vmmvm.c',
    'vmmwin.c',
    'vmmwininit.c',
    'vmmwinobj.c',
    'vmmwinpool.c',
    'vmmwinreg.c',
    'vmmwinsvc.c',
    'vmmwork.c',
    'vmmyarautil.c',
    'vmmyarawrap.c',
]
    vmm_sources += files(source_root / 'vmm' / file_name)
endforeach

vmemd_sources = []
foreach file_name : [
    'm_vmemd.c',
    'oscompatibility.c',
]
    vmemd_sources += files(source_root / 'm_vmemd' / file_name)
endforeach

vmmpyc_sources = []
foreach file_name : [
    'oscompatibility.c',
    'vmmpyc.c',
    'vmmpyc_kernel.c',
    'vmmpyc_maps.c',
    'vmmpyc_module.c',
    'vmmpyc_modulemaps.c',
    'vmmpyc_pdb.c',
    'vmmpyc_physicalmemory.c',
    'vmmpyc_process.c',
    'vmmpyc_processmaps.c',
    'vmmpyc_reghive.c',
    'vmmpyc_regkey.c',
    'vmmpyc_regmemory.c',
    'vmmpyc_regvalue.c',
    'vmmpyc_scattermemory.c',
    'vmmpyc_search.c',
    'vmmpyc_util.c',
    'vmmpyc_vfs.c',
    'vmmpyc_virtualmachine.c',
    'vmmpyc_virtualmemory.c',
    'vmmpyc_vmm.c',
    'vmmpyc_yara.c',
    'vmmpycplugin.c',
]
    vmmpyc_sources += files(source_root / 'vmmpyc' / file_name)
endforeach

memprocfs_sources = []
foreach file_name : [
  'charutil.c',
  'memprocfs_fuse.c',
  'ob/ob_cachemap.c',
  'ob/ob_core.c',
  'ob/ob_map.c',
  'ob/ob_set.c',
  'oscompatibility.c',
  'vfslist.c',
]
    memprocfs_sources += files(source_root / 'memprocfs' / file_name)
endforeach

vmm = shared_library(
    'vmm',
    sources : vmm_sources,
    include_directories : incdir,
    dependencies : [
        leechcore_dep,
        lz4_dep,
        threads_dep,
        dl_dep,
        m_dep,
    ],
    install : true,
)
vmm_dep = declare_dependency(
    link_with : vmm,
    include_directories : vmm_incdir,
)

install_symlink(
    'vmm.so',
    install_dir : libdir,
    pointing_to : 'libvmm.so',
)

install_headers(vmm_headers)

pkg.generate(
    vmm,
    version : vmm_version,
    description : 'Virtual Memory Management Library',
)

shared_module(
    'm_vmemd',
    sources : vmemd_sources,
    dependencies : openssl_dep,
    include_directories : vmm_incdir,
    name_prefix : '',
    install_dir : libdir / 'plugins',
    install : true,
)

# Install to libdir instead and then symlink since site-packages are not moved
# to separate output. Resolves the reference cycle between out and lib outputs.
vmmpyc = py.extension_module(
    'vmmpyc',
    sources : vmmpyc_sources,
    dependencies : vmm_dep,
    install_dir : libdir,
    install : true,
)

vmmpyc_name_so = vmmpyc.name() + '.so'

install_symlink(
    vmmpyc.name() + '.so',
    install_dir : py_install_dir / 'memprocfs',
    pointing_to : libdir / vmmpyc_name_so,
)

if vmmpyc_name_so != 'vmmpyc.so'
  install_symlink(
      'vmmpyc.so',
      install_dir : libdir,
      pointing_to : vmmpyc_name_so,
  )
endif

# py.install_sources does not accept rename argument (looks like a bug since
# docs imply that it should).
install_data(
    sources : memprocfs_py_file,
    rename : '__init__.py',
    install_dir : py_install_dir / 'memprocfs',
)

install_data(
    vmmpyplugin_py_file,
    rename : '__init__.py',
    install_dir : py_install_dir / 'vmmpyplugin',
)

py.install_sources(
    pym_procstruct_files,
    subdir : 'vmmpyplugin/plugins/pym_procstruct',
)

py.install_sources(
    pyp_files,
    subdir : 'vmmpyplugin/plugins',
)

if infodb != ''
    install_symlink(
        'info.db',
        install_dir : libdir,
        pointing_to : infodb,
    )
endif

executable(
    'memprocfs',
    sources : memprocfs_sources,
    dependencies : [vmm_dep, fuse_dep],
    install : true,
)
