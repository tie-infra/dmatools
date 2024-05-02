final: prev: {
  memprocfs = final.callPackage ./package.nix { };

  pythonPackagesExtensions = prev.pythonPackagesExtensions ++ [
    (python-final: _: {
      memprocfs = python-final.callPackage ./python-module.nix { };
    })
  ];
}
