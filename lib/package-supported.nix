pkgs: package:
  package != null
  && pkgs.lib.meta.availableOn pkgs.stdenv.hostPlatform package
  && !(package.meta.broken or false)
