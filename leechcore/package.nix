{ lib
, stdenv
, copyPathToStore
, fetchFromGitHub
, applyPatches
, meson
, pkgconf
, ninja
, python3
, libusb1
, patchelf
, withPlugins ? true
, leechcore-plugins
, withMSCompress ? true
, ms-compress
}:
let
  rpath = lib.makeLibraryPath (lib.optionals withPlugins [
    leechcore-plugins
  ] ++ lib.optionals withMSCompress [
    ms-compress
  ]);
in
stdenv.mkDerivation {
  pname = "leechcore";
  version = "2.18.2.71"; # TODO: update from leechcore/version.h

  # Note that `out` ends up in Python’s withPackages/buildEnv unconditionally.
  # See https://github.com/NixOS/nixpkgs/blob/b8e911463ec39614240a5164030090e22a785c02/pkgs/development/interpreters/python/wrapper.nix#L28
  # and also https://github.com/NixOS/nixpkgs/issues/16182
  outputs = [ "out" "dev" "py" ];

  srcs = [
    (copyPathToStore ./meson)
    (applyPatches {
      name = "LeechCore";
      src = fetchFromGitHub {
        owner = "ufrisk";
        repo = "LeechCore";
        rev = "92967216d16096e95148807824e86116aca8c501";
        hash = "sha256-Kbb3g2S4pbrha5HNwPBMUGw11dG87IaTLnZho3hAtDo=";
      };
      patches = [
        ./patches/0001-Allow-loading-modules-from-default-library-search-pa.patch
        ./patches/0002-Allow-loading-libMSCompression.so-from-library-searc.patch
      ];
    })
  ];

  sourceRoot = "meson";

  strictDeps = true;

  nativeBuildInputs = [
    meson
    pkgconf
    ninja
  ] ++ lib.optionals (rpath != "") [
    patchelf
  ];

  buildInputs = [
    libusb1
    python3
  ];

  mesonFlags = [
    "-Dpython=${python3.pythonOnBuildForHost.interpreter}"
    "-Dpython.platlibdir=${placeholder "py"}/${python3.sitePackages}"
  ];

  postFixup = lib.optionalString (rpath != "") ''
    patchelf --add-rpath ${lib.escapeShellArg rpath} "$out/lib/libleechcore.so"
  '';

  meta = {
    description = "LeechCore Memory Acquisition Library";
    homepage = "http://github.com/ufrisk/LeechCore";
    license = lib.licenses.gpl3Only;
    maintainers = [ lib.maintainers.tie ];
    platforms = lib.platforms.linux;
  };
}
