{ lib
, stdenv
, copyPathToStore
, fetchFromGitHub
, meson
, ninja
}:
stdenv.mkDerivation {
  pname = "ms-compress";
  version = "unstable-2020-01-05";

  outputs = [ "out" "dev" ];

  srcs = [
    (copyPathToStore ./meson)
    (fetchFromGitHub {
      name = "ms-compress";
      owner = "coderforlife";
      repo = "ms-compress";
      rev = "a0fcab84a7918fa205d5f29bf03b71bd4abb19b4";
      hash = "sha256-Ixhl1wWhSfNPY0J+rzXSUWGceguJp/9YDFC2XKbHd1g=";
    })
  ];

  sourceRoot = "meson";

  strictDeps = true;

  nativeBuildInputs = [
    meson
    ninja
  ];

  meta = {
    description = "Open source implementations of Microsoft compression algorithms";
    homepage = "https://github.com/coderforlife/ms-compress";
    license = lib.licenses.gpl3Only; # gpl.txt in repo
    maintainers = [ lib.maintainers.tie ];
    platforms = lib.platforms.linux;
  };
}
