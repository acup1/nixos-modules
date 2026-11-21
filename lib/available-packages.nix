pkgs: builtins.filter (pkgs.lib.meta.availableOn pkgs.stdenv.hostPlatform)
