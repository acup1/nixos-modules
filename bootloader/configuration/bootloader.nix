{config, lib, pkgs, ...}: let
  enabled = config.components.bootloader.enabledPackages;
in {
  imports = [(import ../../lib/package-options.nix "bootloader" [
    {
      id = "grub";
      definitions.boot.loader = {
        grub = {
          enable = true;
          device = "nodev";
          efiSupport = true;
          gfxmodeEfi = "1920x1080";
        };
        timeout = 2;
        efi.canTouchEfiVariables = true;
      };
    }
    {
      id = "intervals-grub-theme";
      available = enabled.grub;
      definitions.boot.loader.grub.theme = pkgs.callPackage ../grub_themes/intervals-grub-theme {};
    }
    {
      id = "qemu-aarch64";
      available = pkgs.stdenv.hostPlatform.system != "aarch64-linux";
      definitions.boot.binfmt.emulatedSystems = ["aarch64-linux"];
    }
  ])];

  # NixOS enables GRUB by default. An explicit host setting still takes precedence.
  config.boot.loader.grub.enable = lib.mkIf (!enabled.grub) (lib.mkDefault false);
}
