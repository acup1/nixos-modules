{pkgs, ...}: {
  imports = [
    (import ../lib/component-packages.nix "lazarus" "system")
    (import ../lib/package-options.nix "lazarus" [{
      id = "lazarus-qt6";
      package = pkgs.lazarus-qt6 or null;
    }])
  ];
}
