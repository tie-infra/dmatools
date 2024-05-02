{ lib
, stdenv
, copyPathToStore
, fetchFromGitHub
, meson
, pkg-config # NB pkgconf cannot find yara dependencies
, ninja
, python3
, yara
}:
stdenv.mkDerivation {
  pname = "pcileech";
  version = "4.5.0.4"; # TODO: update from vmmyara/version.h

  outputs = [ "out" "dev" ];

  srcs = [
    (copyPathToStore ./meson)
    (fetchFromGitHub {
      name = "vmmyara";
      owner = "ufrisk";
      repo = "vmmyara";
      rev = "6ee785a80070591f83fe304040979b076b405ca5";
      hash = "sha256-5qkL0FpDLY4sR6A0lRNwW54b7z59QYmGj3TxqtJ5gCg=";
    })
  ];

  sourceRoot = "meson";

  strictDeps = true;

  nativeBuildInputs = [
    meson
    pkg-config
    ninja
    python3
  ];

  buildInputs = [
    yara
  ];

  meta = {
    description = "YARA wrapper API for MemProcFS";
    homepage = "https://github.com/ufrisk/vmmyara";
    license = lib.licenses.bsd3;
    maintainers = [ lib.maintainers.tie ];
    platforms = lib.platforms.linux;
  };
}
