{lib, pkgs, ...}: {
  imports = [
    (import ../../lib/package-options.nix "nix-serve" [{
      id = "nix-serve";
      available = lib.meta.availableOn pkgs.stdenv.hostPlatform pkgs.nix-serve;
      definitions = {
        services.nix-serve = {
          enable = true;
          bindAddress = "0.0.0.0";
          port = 5000;
          openFirewall = true;
          #secretKeyFile = "/var/cache-priv-key.pem";
        };
      };
    }])
  ];
}
