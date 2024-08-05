project('musl', 'c', version : '1.2.2', license : 'MIT')

cc = meson.get_compiler('c')
cmd = cc.cmd_array()
cmd += '--print-libgcc-file-name'
libgcc = run_command(cmd)
libgcc = libgcc.stdout().strip()

arch = target_machine.cpu()


message('libgcc: ', libgcc)

globbed_sources = run_command(meson.project_source_root() + '/glob.sh', target_machine.cpu_family())
newline= '''
'''
globbed_sources = globbed_sources.stdout().strip().split(newline)


globbed_headers = run_command(meson.project_source_root() + '/globbits.sh', target_machine.cpu_family())

globbed_headers = globbed_headers.stdout().strip().split(newline)

install_headers(globbed_headers, subdir: 'bits')
install_headers(
  run_command('find', meson.project_source_root() + '/include/', '-name', '*.h').stdout().strip().split(newline)
)
install_headers(
  run_command('find', meson.project_source_root() + '/include/net', '-name', '*.h').stdout().strip().split(newline),
  subdir: 'net' 
)
install_headers(
  run_command('find', meson.project_source_root() + '/include/netpacket', '-name', '*.h').stdout().strip().split(newline),
  subdir: 'netpacket' 
)
install_headers(
  run_command('find', meson.project_source_root() + '/include/sys', '-name', '*.h').stdout().strip().split(newline),
  subdir: 'sys' 
)
install_headers(
  run_command('find', meson.project_source_root() + '/include/scsi', '-name', '*.h').stdout().strip().split(newline),
  subdir: 'scsi'
)
install_headers(
  run_command('find', meson.project_source_root() + '/include/arpa', '-name', '*.h').stdout().strip().split(newline),
  subdir: 'arpa'
)
install_headers(
  run_command('find', meson.project_source_root() + '/include/netinet', '-name', '*.h').stdout().strip().split(newline),
  subdir: 'netinet'
)

subdir('bits/')

message(globbed_headers)

c_args = [
  '-pipe',
  '-fomit-frame-pointer',
  '-fno-unwind-tables',
  '-fno-asynchronous-unwind-tables',
  '-ffunction-sections',
  '-fdata-sections',
  '-std=c99', '-ffreestanding', '-nostdinc',
  '-D_XOPEN_SOURCE=700',
  '-fno-stack-protector',
  '-fPIC'
]

ld_args = [
  '-nostdlib',
  '-Wl,--dynamic-list='+meson.project_source_root()+'/dynamic.list',
  '-Wl,-e,_dlstart',
  libgcc
]


inc_dir_flags = [
  '-I'+meson.project_source_root()+'/arch/' + arch,
  '-I'+meson.project_source_root()+'/arch/generic',
  '-I'+meson.project_source_root()+'/src/internal',
  '-I'+meson.project_source_root()+'/src/include',
  '-I'+meson.project_source_root()+'/include',
  '-I'+meson.project_build_root()
]

inc_dirs = include_directories(
  'arch/' + arch,
  'arch/generic',
  'src/internal',
  'src/include',
  'include'
)


ldso_sources = [
  'ldso/dlstart.c',
  'ldso/dynlink.c',
]

version_h = custom_target(
  'version.h',
  output : 'version.h',
  command : [ meson.project_source_root()+'/version_h.sh' ],
  capture : true 
)

shared_library('c',
  ldso_sources,
  globbed_sources,
  alltypes_h,
  syscall_h,
  version_h,
  c_args: c_args, link_args: ld_args,
  include_directories: inc_dirs,
  install: true
)

static_library('c',
  ldso_sources,
  globbed_sources,
  alltypes_h,
  syscall_h,
  version_h,
  c_args: c_args, link_args: ld_args,
  include_directories: inc_dirs,
  install: true
)

static_library('crypt', install: true)
static_library('dl', install: true)
static_library('m', install: true)
static_library('rt', install: true)
static_library('pthread', install: true)
static_library('util', install: true)
static_library('xnet', install: true)

subdir('crt')

