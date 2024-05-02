{ lib
, stdenv
, copyPathToStore
, fetchFromGitHub
, applyPatches
, meson
, pkgconf
, ninja
, python3
, leechcore
, lz4
, openssl
, fuse
, makeBinaryWrapper
, patchelf
  # Add Python library to the RUNPATH.
, withPython ? true
  # Enable YARA support.
, withVmmYara ? true
, vmmyara
  # Enable Microsoft compression algorithms support.
, withMSCompress ? true
, ms-compress
  # Install info.db file (requires unfree).
, withInfodb ? false
, memprocfs-infodb
  # Enable PDB support.
, withPdb ? true
, pdbcrust
}:
let
  rpath = lib.makeLibraryPath (lib.optionals withPython [
    python3
  ] ++ lib.optionals withVmmYara [
    vmmyara
  ] ++ lib.optionals withMSCompress [
    ms-compress
  ] ++ lib.optionals withPdb [
    pdbcrust
  ]);
in
stdenv.mkDerivation {
  pname = "memprocfs";
  version = "5.9.10.157"; # TODO: update from memprocfs/version.h

  outputs = [ "out" "lib" "dev" "py" ];

  srcs = [
    (copyPathToStore ./meson)
    (applyPatches {
      name = "MemProcFS";
      src = fetchFromGitHub {
        owner = "ufrisk";
        repo = "MemProcFS";
        rev = "1344407157fc6d62790b8d519aa2707ded322c57";
        hash = "sha256-5DbSVX/3DEYzfP7+sNMt7Ip6Y2OcN/QkMe3+5Y/EPlk=";
      };
      patches = [
        ./patches/0001-Allow-loading-libraries-from-dlopen-search-path.patch
      ];
    })
  ];

  sourceRoot = "meson";

  strictDeps = true;

  nativeBuildInputs = [
    meson
    pkgconf
    ninja
    makeBinaryWrapper
  ] ++ lib.optionals (rpath != "") [
    patchelf
  ];

  buildInputs = [
    leechcore
    lz4
    fuse
    openssl
    python3
  ];

  mesonFlags = [
    "-Dpython=${python3.pythonOnBuildForHost.interpreter}"
    "-Dpython.platlibdir=${placeholder "py"}/${python3.sitePackages}"
  ] ++ lib.optionals withInfodb [
    "-Dinfodb=${memprocfs-infodb}/share/memprocfs/info.db"
  ];

  # Set PYTHONPATH for MemProcFS’s Python plugin system.
  # Add lib output to the LD_LIBRARY_PATH so that vmm.so is on the dlopen search
  # path for LeechCore (that we depend on).
  postFixup = ''
    wrapProgram "$out/bin/memprocfs" \
      --suffix PYTHONPATH : "$(toPythonPath "$py")" \
      --suffix LD_LIBRARY_PATH : "$lib/lib"
  '' + lib.optionalString (rpath != "") ''
    patchelf --add-rpath ${lib.escapeShellArg rpath} "$lib/lib/libvmm.so"
  '';

  meta = {
    description = "Virtual filesystem for viewing physical memory as files";
    homepage = "https://github.com/ufrisk/MemProcFS";
    license = lib.licenses.agpl3Only;
    maintainers = [ lib.maintainers.tie ];
    platforms = lib.platforms.linux;
    mainProgram = "memprocfs";
  };
}
