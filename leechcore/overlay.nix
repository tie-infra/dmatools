final: prev: {
  leechcore = final.callPackage ./package.nix { };

  pythonPackagesExtensions = prev.pythonPackagesExtensions ++ [
    (python-final: _: {
      leechcorepyc = python-final.callPackage ./python-module.nix { };
    })
  ];
}
