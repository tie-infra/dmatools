project('ms-compress', 'cpp')

pkg = import('pkgconfig')

mscompress_path = '..' / 'ms-compress'

mscompress_headers = []
mscompress_mscomp_headers = []
foreach file_name : [
    'lznt1.h',
    'mscomp.h',
    'xpress.h',
    'xpress_huff.h',
]
    mscompress_headers += files(mscompress_path / 'include' / file_name)
endforeach
foreach file_name : [
    'Array.h',
    'Bitstream.h',
    'CircularBuffer.h',
    'HuffmanDecoder.h',
    'HuffmanEncoder.h',
    'LZNT1Dictionary.h',
    'LZNT1Dictionary_SA.h',
    'XpressDictionary.h',
    'config.h',
    'general.h',
    'internal.h',
    'sorting.h',
]
    mscompress_mscomp_headers += files(mscompress_path / 'include' / 'mscomp' / file_name)
endforeach

mscompress_sources = []
foreach file_name : [
    'lznt1_compress.cpp',
    'lznt1_decompress.cpp',
    'mscomp.cpp',
    'xpress_compress.cpp',
    'xpress_decompress.cpp',
    'xpress_huff_compress.cpp',
    'xpress_huff_decompress.cpp',
]
    mscompress_sources += files(mscompress_path / 'src' / file_name)
endforeach

mscompress = shared_library(
    'MSCompression',
    sources : mscompress_sources,
    install : true,
    cpp_args : [
        '-DMSCOMP_API_DLL',
        '-DMSCOMP_API_EXPORT',
    ],
)

install_headers(mscompress_headers)
install_headers(mscompress_mscomp_headers, subdir : 'mscomp')

pkg.generate(
    mscompress,
    filebase : 'ms-compress',
    description : 'Open source implementations of Microsoft compression algorithms',
)
