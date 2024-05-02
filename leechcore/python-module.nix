{ lib
, toPythonModule
, python
, pkgs
}:
lib.pipe pkgs.leechcore [
  toPythonModule
  (p: p.overrideAttrs (oldAttrs: { meta = oldAttrs.meta // { outputsToInstall = [ "py" ]; }; }))
  (p: p.override { python3 = python; })
  (lib.getOutput "py")
]
