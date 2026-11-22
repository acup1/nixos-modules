{pkgs, ...}: {
  imports = [
    (import ../../lib/package-options.nix "macos-packages" [
      { id = "cups"; package = pkgs.cups; }
      { id = "p7zip"; package = pkgs.p7zip; }
      { id = "nodejs"; package = pkgs.nodejs; }
    ])
  ];
}
