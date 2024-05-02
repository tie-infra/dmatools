{ lib
, stdenv
, copyPathToStore
, fetchFromGitHub
, applyPatches
, meson
, pkgconf
, ninja
, libusb1
}:
stdenv.mkDerivation {
  pname = "leechcore-plugins";
  version = "2.16.9.60"; # TODO: update from leechcore_device_rawtcp/version.h

  srcs = [
    (copyPathToStore ./meson)
    (applyPatches {
      name = "LeechCore-plugins";
      src = fetchFromGitHub {
        owner = "ufrisk";
        repo = "LeechCore-plugins";
        rev = "4c11afc5b68cc4b5e8e493788ab48d4f27fce954";
        hash = "sha256-6tb0ftPquF5M2/tXanu1keO4XwMkjy2OToaZpR4sJh4=";
      };
      patches = [
        ./patches/0001-Fix-conflicting-P-SIZE_T-definitions.patch
      ];
    })
  ];

  sourceRoot = "meson";

  strictDeps = true;

  nativeBuildInputs = [
    meson
    pkgconf
    ninja
  ];

  buildInputs = [
    libusb1
  ];

  meta = {
    description = "Plugins related to LeechCore";
    homepage = "https://github.com/ufrisk/pcileech";
    license = lib.licenses.gpl3Only;
    maintainers = [ lib.maintainers.tie ];
    platforms = lib.platforms.linux;
  };
}
