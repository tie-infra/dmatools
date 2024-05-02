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
      leechcore-aarch64 = pkgsCross.aarch64.leechcore;
      leechcore-x86-64 = pkgsCross.x86-64.leechcore;
      leechcore-x86 = pkgsCross.x86.leechcore;

      memprocfs-aarch64 = pkgsCross.aarch64.memprocfs;
      memprocfs-x86-64 = pkgsCross.x86-64.memprocfs;
      memprocfs-x86 = pkgsCross.x86.memprocfs;
    };
  };
}
