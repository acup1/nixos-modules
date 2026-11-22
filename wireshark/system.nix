{lib, pkgs, specialArgs, ...}: {
  imports = [
    (import ../lib/component-packages.nix "wireshark" "system")
    (import ../lib/package-options.nix "wireshark" [{
      id = "wireshark";
      # On NixOS the system Wireshark module installs this package.
      package = if pkgs.stdenv.hostPlatform.isDarwin then pkgs.wireshark else null;
    }])
  ];

  options.components.wireshark.capture = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Grant the selected users access to packet capture devices.";
    };
    users = lib.mkOption {
      type = lib.types.listOf (lib.types.strMatching "[a-zA-Z_][a-zA-Z0-9._-]*");
      default = lib.optional (specialArgs ? username) specialArgs.username;
      description = "Local users allowed to capture traffic. Defaults to the host selector's username.";
    };
  };
}
