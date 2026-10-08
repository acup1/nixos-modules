# Component Modules

This directory is next to `../nixos/`, outside that Git repository. Its path
is defined by `modulesRoot` directly in `~/.config/nix/modules.nix`, along
with component selection. One import selects both OS and Home parts. The
host reads the selector through its non-flake `localConfig` input; component
files are imported directly from the local filesystem and require `--impure`.

## Structure

- Each component has `default.nix`, exporting `nixos` and/or `home` modules.
- `nixos.nix` recursively imports the relevant `configuration/` and `packages/` directories with `lib.filesystem.listFilesRecursive`. Keep these directories limited to Nix modules.
- `configuration/` contains system services and settings.
- `packages/` contains system package lists.
- `bootloader/grub_themes/` contains the GRUB theme package and its source assets. It is referenced with `pkgs.callPackage`, outside the automatic NixOS module imports.
- `home.nix` discovers `default.nix` files under `home_packages/` with `lib.fileset.fileFilter` and `lib.fileset.toList`, so application assets are not imported as modules.
- `home_packages/<app>/default.nix` contains Home Manager settings, with assets
  under that application's `.config/` directory when appropriate.
- Omit unused parts instead of creating empty directories or Home modules.

`base/` contains basic system packages in `packages/base.nix` and system
infrastructure in `configuration/`: Nix, cache clients, NH, SSH, NetworkManager,
locale, documentation and Zsh. Keep optional applications and graphical
additions separate. The NetworkManager applet is in `WM-DE/common`, qBittorrent
is in `qbittorrent`, and the existing binary cache server is in `nix-serve`.
Preserve service settings, ports and cache trust when relocating them.

`WM-DE/` groups the independent `hypr`, `niri`, `drift`, and `gnome`
bundles and their shared `common` bundle. Each WM imports `../common/nixos.nix`
and `../common/home.nix` by path so Nix deduplicates shared settings. These
explicit dependency imports are separate from automatic discovery within
`configuration/`, `packages/`, and `home_packages/`. GDM stays in `common`
so selecting a WM also provides a display manager. WLR portal routing belongs
to `drift`; GTK portal defaults belong to `common`. Keep the upstream DriftWM
and DMS module imports in their corresponding component files.

Keep Sunshine, sunshine-frp, and Moonlight independent. Shared module arguments, including
`inputs` and `username`, are supplied by the host flake. Preserve existing
services, network settings and credentials references when moving code.
Do not store tokens or private keys in these components.

## Validation

Do not build configurations, run `nix flake check`, or activate services unless
explicitly requested. Use static inspection, `nix-instantiate --parse`, and
syntax checks. Update only `localConfig` in the host's lock file when the
selector changes; editing local component files requires no lock update.
Do not update unrelated inputs.
