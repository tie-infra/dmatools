{ lib
, rustPlatform
, fetchFromGitHub
, pkgconf
, openssl
}:
rustPlatform.buildRustPackage {
  pname = "pdbcrust";
  version = "1.0.0"; # TODO: update from Cargo.toml

  src = fetchFromGitHub {
    owner = "ufrisk";
    repo = "pdbcrust";
    rev = "1963a228944288b3857091ed0b4d91e01335064d";
    hash = "sha256-sX0a/DIRhEO4UnPEH7H1rpQ3rEM0vcCNuDLUZ3mNEks=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
  };

  postPatch = ''
    ln -s ${./Cargo.lock} Cargo.lock
  '';

  nativeBuildInputs = [
    pkgconf
  ];

  buildInputs = [
    openssl
  ];

  doCheck = false; # requires network

  meta = {
    description = "C library wrapper around the Rust pdb crate";
    homepage = "https://github.com/ufrisk/pdbcrust";
    license = with lib.licenses; [ asl20 /* or */ mit ];
    maintainers = [ lib.maintainers.tie ];
    platforms = lib.platforms.linux;
  };
}
