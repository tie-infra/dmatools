{ self, inputs, lib, ... }: {
  perSystem = { system, ... }:
    let
      # See https://github.com/NixOS/nixpkgs/issues/303193
      fixNixpkgsIssue303193 = _: prev:
        let
          patchPath = "/pkgs/development/libraries/glibc/2.39-master.patch";
          overridePatch = p: p.overrideAttrs (oldAttrs: {
            patches = lib.remove (prev.path + patchPath) oldAttrs.patches ++ [
              (inputs.nixpkgs-303193 + patchPath)
            ];
          });
        in
        lib.genAttrs [ "glibc" "glibcCross" ] (attr: overridePatch prev.${attr});

      # See https://github.com/NixOS/nixpkgs/pull/308830
      fixSystemdSandbox = _: prev: {
        systemd = prev.systemd.overrideAttrs (oldAttrs: {
          mesonFlags = oldAttrs.mesonFlags ++ [
            (lib.mesonOption "split-bin" "true")
          ];
        });
      };

      nixpkgsArgs = {
        localSystem = { inherit system; };
        overlays = [
          self.overlays.default
        ] ++ lib.optionals (lib.hasSuffix "-darwin" system) [
          fixNixpkgsIssue303193
          fixSystemdSandbox
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
