{ lib
, stdenvNoCC
, fetchurl
}:
stdenvNoCC.mkDerivation {
  pname = "memprocfs-infodb";
  version = "5.9.10"; # TODO: fetch latest release and look for the same file name in the archive.

  src = fetchurl {
    url = "https://github.com/ufrisk/MemProcFS/releases/download/v5_archive/MemProcFS_files_and_binaries_v5.9.10-linux_aarch64-20240427.tar.gz";
    hash = "sha256-3nivDjIwrmXy5TzPGuE+W9hntoK5FCuNn5KPAFvJHuo=";
  };

  unpackPhase = ''
    runHook postUnpack
    tar -x -z -f "$src"
    runHook preUnpack
  '';

  dontBuild = true;

  installPhase = ''
    runHook preInstall
    install -m 644 -D -- info.db "$out"/share/memprocfs/info.db
    runHook postInstall
  '';

  meta = {
    description = "MemProcFS information read-only sqlite database";
    homepage = "https://github.com/ufrisk/MemProcFS/releases";
    # FIXME: what is the actual license of the info.db file?
    # At least yara_rules table is under elastic license and uses rules from
    # https://github.com/elastic/protections-artifacts
    # For a safe measure, also slap unfreeRedistributable since info.db is
    # supposed to be redistributable (or at least it seems so).
    license = with lib.licenses; [ unfreeRedistributable /* and */ elastic20 ];
    maintainers = [ lib.maintainers.tie ];
    platforms = lib.platforms.all;
  };
}
