{pkgs, ...}: {
  imports = [
    (import ../../lib/package-options.nix "moonlight" [
      { id = "moonlight"; package = pkgs.moonlight-qt; }
    ])
  ];
}
