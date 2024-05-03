{ self, lib, ... }: {
  imports = [
    ./ms-compress
    ./leechcore-plugins
    ./leechcore
    ./vmmyara
    ./pdbcrust
    ./memprocfs-infodb
    ./memprocfs
    ./pcileech
  ];

  flake.overlays.default = lib.composeManyExtensions (with self.overlays; [
    ms-compress
    leechcore-plugins
    leechcore
    vmmyara
    pdbcrust
    memprocfs-infodb
    memprocfs
    pcileech
  ]);

  perSystem = { pkgsCross, ... }: {
    legacyPackages = pkgsCross.x86;

    checks = {
      pcileech-aarch64 = pkgsCross.aarch64.pcileech;
      pcileech-x86-64 = pkgsCross.x86-64.pcileech;
      pcileech-x86 = pkgsCross.x86.pcileech;

      memprocfs-aarch64 = pkgsCross.aarch64.memprocfs;
      memprocfs-x86-64 = pkgsCross.x86-64.memprocfs;
      memprocfs-x86 = pkgsCross.x86.memprocfs;
    };
  };
}
