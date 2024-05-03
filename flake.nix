{
  description = "Direct Memory Access Attack Software";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";

    # Fix for https://github.com/NixOS/nixpkgs/issues/303193 is not in unstable
    # channel yet.
    # https://github.com/NixOS/nixpkgs/commit/dd8e61da4aadb1288e9db2ded077bb74628c28ac
    nixpkgs-303193.url = "nixpkgs/dd8e61da4aadb1288e9db2ded077bb74628c28ac";

    flake-parts.url = "flake-parts";
    flake-parts.inputs.nixpkgs-lib.follows = "nixpkgs";

    treefmt-nix.url = "github:numtide/treefmt-nix";
    treefmt-nix.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs: inputs.flake-parts.lib.mkFlake { inherit inputs; } {
    systems = [
      "aarch64-darwin"
      "aarch64-linux"
      "x86_64-linux"
    ];

    imports = [
      inputs.treefmt-nix.flakeModule
      ./nixpkgs.nix
      ./top-level.nix
    ];

    perSystem.treefmt = {
      projectRootFile = "flake.nix";
      programs.deadnix.enable = true;
      programs.nixpkgs-fmt.enable = true;
    };
  };
}
