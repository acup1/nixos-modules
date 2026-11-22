{config, lib, options, pkgs, specialArgs, ...}: let
  inputs = specialArgs.inputs or (config._module.args.inputs or {});
  cliIds = [
    "wget" "curl" "watch" "unzip" "fzf" "git" "sshfs" "bat"
    "zellij" "fastfetch" "cmatrix" "pipes-rs" "comma" "yq" "p7zip"
  ];
  migrated = {
    browsers = import ../browsers/darwin-packages.nix {inherit inputs pkgs;};
    cli-tools = lib.filter (entry: builtins.elem entry.id cliIds)
      (import ../cli-tools/darwin-packages.nix {inherit pkgs;});
    dev = import ../dev/darwin-packages.nix {inherit lib pkgs;};
    doc-redactors = import ../doc-redactors/darwin-packages.nix {inherit pkgs;};
    fonts = import ../fonts/font-packages.nix {inherit pkgs;};
    printing = import ../printing/darwin-packages.nix {inherit pkgs;};
    shell = import ../shell/darwin-packages.nix {inherit pkgs;};
  };
  legacyEntries = lib.concatLists (lib.mapAttrsToList (component: map (entry: entry // {
    id = entry.legacyId or entry.id;
    # When both bundles are selected, the topic owns the install and uses
    # the legacy switch as its default. An explicit topic setting can override it.
    available =
      pkgs.stdenv.hostPlatform.isDarwin
      && !(lib.hasAttrByPath ["components" component "enabledPackages" entry.id] options)
      && (entry.available or true);
  })) migrated);
in {
  imports = [
    (import ../lib/component-packages.nix "macos-packages" "system")
    (import ../lib/package-options.nix "macos-packages" legacyEntries)
  ];
}
