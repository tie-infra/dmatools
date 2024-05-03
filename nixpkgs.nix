{ self, inputs, lib, ... }: {
  perSystem = { system, ... }:
    let
      # See https://github.com/NixOS/nixpkgs/issues/303193
      fixNixpkgsIssue303193 = _: prev:
        let
          patchPath = "/pkgs/development/libraries/glibc/2.39-master.patch";
          overridePatch = p: p.overrideAttrs (oldAttrs: {
            oldAttrs = lib.remove (prev.path + patchPath) oldAttrs.patches ++ [
              (inputs.nixpkgs-staging + patchPath)
            ];
          });
        in
        lib.optionalAttrs
          prev.stdenv.buildPlatform.isDarwin # NB final causes infinite recursion
          (lib.genAttrs [ "glibc" "glibcCross" ] (attr: overridePatch prev.${attr}));

      nixpkgsArgs = {
        localSystem = { inherit system; };
        overlays = [
          self.overlays.default
          fixNixpkgsIssue303193
        ];
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
