{ self, inputs, ... }: {
  perSystem = { system, ... }:
    let
      nixpkgsArgs = {
        localSystem = { inherit system; };
        overlays = [ self.overlays.default ];
      };

      nixpkgsFun = newArgs: import inputs.nixpkgs (nixpkgsArgs // newArgs);
    in
    {
      _module.args = {
        pkgs = nixpkgsFun { };
        pkgsCross = {
          aarch64 = nixpkgsFun {
            crossSystem.config = "aarch64-unknown-linux-gnu";
          };
          x86-64 = nixpkgsFun {
            crossSystem.config = "x86_64-unknown-linux-gnu";
          };
          x86 = nixpkgsFun {
            crossSystem.config = "i686-unknown-linux-gnu";
          };
        };
      };
    };
}
