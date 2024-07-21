project(
  'basu',
  'c',
  version : '0.2.1',
  license : 'LGPLv2+',
  default_options : [
    'c_std=gnu99',
    'prefix=/usr',
    'sysconfdir=/etc',
    'localstatedir=/var',
    'warning_level=2',
  ],
  meson_version : '>= 0.54'
)

soversion = 0

# We need the same data in two different formats, ugh!
# Also, for hysterical reasons, we use different variable
# names, sometimes. Not all variables are included in every
# set. Ugh, ugh, ugh!
conf = configuration_data()
conf.set_quoted('PACKAGE_STRING',  meson.project_name() + ' ' + meson.project_version())

#####################################################################

cc = meson.get_compiler('c')
cxx_cmd = ''

possible_cc_flags = [
        '-Werror=undef',
        '-Wlogical-op',
        '-Wmissing-include-dirs',
        '-Wold-style-definition',
        '-Wpointer-arith',
        '-Winit-self',
        '-Wfloat-equal',
        '-Wsuggest-attribute=noreturn',
        '-Werror=missing-prototypes',
        '-Werror=implicit-function-declaration',
        '-Werror=missing-declarations',
        '-Werror=return-type',
        '-Werror=incompatible-pointer-types',
        '-Werror=format=2',
        '-Wstrict-prototypes',
        '-Wredundant-decls',
        '-Wmissing-noreturn',
        '-Wimplicit-fallthrough=5',
        '-Wshadow',
        '-Wendif-labels',
        '-Wstrict-aliasing=2',
        '-Wwrite-strings',
        '-Werror=overflow',
        '-Werror=shift-count-overflow',
        '-Werror=shift-overflow=2',
        '-Wdate-time',
        '-Wnested-externs',

        # negative arguments are correctly detected starting with meson 0.46.
        '-Wno-unused-parameter',
        '-Wno-missing-field-initializers',
        '-Wno-unused-result',
        '-Wno-format-signedness',
        '-Wno-format-nonliteral',

        # work-around for gcc 7.1 turning this on on its own.
        '-Wno-error=nonnull',

        # Disable -Wmaybe-uninitialized, since it's noisy on gcc 8 with
        # optimizations enabled, producing essentially false positives.
        '-Wno-maybe-uninitialized',

        '-ffast-math',
        '-fno-common',
        '-fdiagnostics-show-option',
        '-fno-strict-aliasing',
        '-fvisibility=hidden',
        '-fstack-protector',
        '-fstack-protector-strong',
        '--param=ssp-buffer-size=4',
]

# --as-needed and --no-undefined are provided by meson by default,
# run mesonconf to see what is enabled
possible_link_flags = [
        '-Wl,-z,relro',
        '-Wl,-z,now',
]

possible_cc_flags += '-fPIE'
possible_link_flags += '-pie'

if cc.get_id() == 'clang'
        possible_cc_flags += [
                '-Wno-typedef-redefinition',
                '-Wno-gnu-variable-sized-type-not-at-end',
        ]
endif

if get_option('buildtype') != 'debug'
        possible_cc_flags += [
                '-ffunction-sections',
                '-fdata-sections',
        ]

        possible_link_flags += '-Wl,--gc-sections'
endif

add_project_arguments(cc.get_supported_arguments(possible_cc_flags), language : 'c')
add_project_link_arguments(cc.get_supported_link_arguments(possible_link_flags), language : 'c')

if cc.compiles('''
   #include <time.h>
   #include <inttypes.h>
   typedef uint64_t usec_t;
   usec_t now(clockid_t clock);
   int main(void) {
           struct timespec now;
           return 0;
   }
''', name : '-Werror=shadow with local shadowing')
        add_project_arguments('-Werror=shadow', language : 'c')
endif

#####################################################################
# compilation result tests

conf.set('_GNU_SOURCE', true)
conf.set('__SANE_USERSPACE_TYPES__', true)

conf.set('SIZEOF_PID_T', cc.sizeof('pid_t', prefix : '#include <sys/types.h>'))
conf.set('SIZEOF_UID_T', cc.sizeof('uid_t', prefix : '#include <sys/types.h>'))
conf.set('SIZEOF_GID_T', cc.sizeof('gid_t', prefix : '#include <sys/types.h>'))
conf.set('SIZEOF_DEV_T', cc.sizeof('dev_t', prefix : '#include <sys/types.h>'))

decl_headers = '''
#include <uchar.h>
#include <sys/stat.h>
'''

foreach decl : ['char16_t',
                'char32_t',
               ]

        # We get -1 if the size cannot be determined
        have = cc.sizeof(decl, prefix : decl_headers, args : '-D_GNU_SOURCE') > 0

        conf.set10('HAVE_' + decl.underscorify().to_upper(), have)
endforeach

foreach ident : [
        ['explicit_bzero' ,   '''#include <string.h>'''],
        ['reallocarray',      '''#include <stdlib.h>'''],
        ['secure_getenv',     '''#include <stdlib.h>'''],
]

        have = cc.has_function(ident[0], prefix : ident[1], args : '-D_GNU_SOURCE')
        conf.set10('HAVE_' + ident[0].to_upper(), have)
endforeach

#####################################################################

sed = find_program('sed')
awk = find_program('awk')

############################################################

gperf = find_program('gperf')

gperf_test_format = '''
#include <string.h>
const char * in_word_set(const char *, @0@);
@1@
'''
gperf_snippet_format = 'echo foo,bar | @0@ -L ANSI-C'
gperf_snippet = run_command('sh', '-c', gperf_snippet_format.format(gperf.path()))
gperf_test = gperf_test_format.format('size_t', gperf_snippet.stdout())
if cc.compiles(gperf_test)
        gperf_len_type = 'size_t'
else
        gperf_test = gperf_test_format.format('unsigned', gperf_snippet.stdout())
        if cc.compiles(gperf_test)
                gperf_len_type = 'unsigned'
        else
                error('unable to determine gperf len type')
        endif
endif
message('gperf len type is @0@'.format(gperf_len_type))
conf.set('GPERF_LEN_TYPE', gperf_len_type,
         description : 'The type of gperf "len" parameter')

############################################################

nobody_user = get_option('nobody-user')

if not meson.is_cross_build()
        getent_result = run_command('getent', 'passwd', '65534')
        if getent_result.returncode() == 0
                name = getent_result.stdout().split(':')[0]
                if name != nobody_user
                        warning('\n' +
                                'The local user with the UID 65534 does not match the configured user name "@0@" of the nobody user (its name is @1@).\n'.format(nobody_user, name) +
                                'Your build will result in an user table setup that is incompatible with the local system.')
                endif
        endif
        id_result = run_command('id', '-u', nobody_user)
        if id_result.returncode() == 0
                id = id_result.stdout().to_int()
                if id != 65534
                        warning('\n' +
                                'The local user with the configured user name "@0@" of the nobody user does not have UID 65534 (it has @1@).\n'.format(nobody_user, id) +
                                'Your build will result in an user table setup that is incompatible with the local system.')
                endif
        endif
endif
conf.set_quoted('NOBODY_USER_NAME', nobody_user)

system_bus_address = get_option('system-bus-address')
conf.set_quoted('DEFAULT_SYSTEM_BUS_ADDRESS', system_bus_address)

conf.set_quoted('GETTEXT_PACKAGE', meson.project_name())

enable_debug_hashmap = false
foreach name : get_option('debug-extra')
        if name == 'hashmap'
                enable_debug_hashmap = true
        else
                message('unknown debug option "@0@", ignoring'.format(name))
        endif
endforeach
conf.set10('ENABLE_DEBUG_HASHMAP', enable_debug_hashmap)

#####################################################################

threads = dependency('threads')
librt = cc.find_library('rt')
libm = cc.find_library('m')

libcap = dependency('libcap', required: get_option('libcap'))
have_libcap = libcap.found()
conf.set10('HAVE_LIBCAP', have_libcap)

libaudit = dependency('audit', required : get_option('audit'))
conf.set10('HAVE_AUDIT', libaudit.found())

tests = []

config_h = configure_file(
  output : 'config.h',
  configuration : conf,
)

cpp = ' '.join(cc.cmd_array()) + ' -E'

includes = include_directories(
  'src/basic',
  'src/systemd',
  'src/test',
  'src/libsystemd/sd-bus',
  'src/libsystemd/sd-daemon',
  'src/libsystemd/sd-id128',
)

add_project_arguments('-include', meson.current_build_dir() / 'config.h', language : 'c')

subdir('src/basic')
subdir('src/libsystemd')
subdir('src/systemd')
subdir('src/test')

foreach tuple : tests
        sources = tuple[0]
        link_with = tuple[1]
        dependencies = tuple[2]
        condition = tuple.length() >= 4 ? tuple[3] : ''
        type = tuple.length() >= 5 ? tuple[4] : ''
        defs = tuple.length() >= 6 ? tuple[5] : []
        incs = tuple.length() >= 7 ? tuple[6] : includes
        timeout = 30

        name = sources[0].split('/')[-1].split('.')[0]
        if type.startswith('timeout=')
                timeout = type.split('=')[1].to_int()
                type = ''
        endif

        if condition == '' or conf.get(condition) == 1
                exe = executable(
                        name,
                        sources,
                        include_directories : incs,
                        link_with : link_with,
                        dependencies : [dependencies],
                        c_args : defs,
                        install : false)
                if type != 'manual'
                        test(name, exe, timeout : timeout)
                endif
        else
                message('Not compiling @0@ because @1@ is not true'.format(name, condition))
        endif
endforeach

libsystemd_sym_path = '@0@/@1@'.format(meson.current_source_dir(), libsystemd_sym)
libsystemd = library(
        'basu',
        soversion : soversion,
        include_directories : includes,
        link_args : ['-shared',
                     '-Wl,--version-script=' + libsystemd_sym_path],
        link_with : libbasic,
        link_whole : libsystemd_static,
        dependencies : [threads,
                        librt],
        link_depends : libsystemd_sym,
        install : true)

pkgconfig = import('pkgconfig')
pkgconfig.generate(libsystemd,
        version: meson.project_version(),
        filebase: meson.project_name(),
        name: meson.project_name(),
        description: 'basu library')

exe = executable('basuctl',
                 'src/busctl/busctl.c',
                 'src/busctl/busctl-introspect.c',
                 'src/busctl/busctl-introspect.h',
                 include_directories : includes,
                 link_with : [libbasic,
                              libsystemd],
                 install : true)

meson.override_dependency('basu', declare_dependency(
  link_with : libsystemd,
  include_directories : includes,
))
