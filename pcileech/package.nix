{ lib
, stdenv
, copyPathToStore
, fetchFromGitHub
, meson
, pkgconf
, ninja
, python3
, leechcore
, fuse
, memprocfs
, makeBinaryWrapper
}:
let
  # Passed via LD_LIBRARY_PATH for LeechCore.
  vmmLib = "${lib.getLib memprocfs}/lib";
  # Passed via PYTHONPATH for MemProcFS/VMM.
  vmmPy = lib.getOutput "py" memprocfs;
in
stdenv.mkDerivation {
  pname = "memprocfs";
  version = "4.17.7.48"; # TODO: update from pcileech/version.h

  srcs = [
    (copyPathToStore ./meson)
    (fetchFromGitHub {
      name = "pcileech";
      owner = "ufrisk";
      repo = "pcileech";
      rev = "f0c3b7330bcf091fdc45a92392d0541893168ea5";
      hash = "sha256-FAm3z4GMCI++WfeAJddDP/eF8R7KLoi9Mixz8ZlEONk=";
    })
  ];

  sourceRoot = "meson";

  strictDeps = true;

  nativeBuildInputs = [
    meson
    pkgconf
    ninja
    makeBinaryWrapper
    python3
  ];

  buildInputs = [
    leechcore
    memprocfs
    fuse
  ];

  postFixup = ''
    wrapProgram "$out/bin/pcileech" \
      --suffix PYTHONPATH : "$(toPythonPath ${lib.escapeShellArg vmmPy})" \
      --suffix LD_LIBRARY_PATH : ${lib.escapeShellArg vmmLib}
  '';

  meta = {
    description = "Direct Memory Access (DMA) Attack Software";
    homepage = "https://github.com/ufrisk/pcileech";
    license = lib.licenses.agpl3Only;
    maintainers = [ lib.maintainers.tie ];
    platforms = lib.platforms.linux;
    mainProgram = "pcileech";
  };
}
