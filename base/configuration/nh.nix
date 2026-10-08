{ flakeDir, lib, pkgs, ... }:

let
  # Hardware configuration and selected local modules live outside the flake.
  # Allow filesystem imports when building NixOS or Home Manager configurations.
  nhWrapper = pkgs.writeShellApplication {
    name = "nh";
    text = ''
      args=("$@")

      case "''${args[0]-}:''${args[1]-}" in
        os:switch|os:boot|os:test|os:build|os:build-vm|os:build-image|home:switch|home:build)
          hasImpure=false

          for arg in "''${args[@]}"; do
            if [[ "$arg" == "--impure" ]]; then
              hasImpure=true
              break
            fi
          done

          if [[ "$hasImpure" == false ]]; then
            args+=(--impure)
          fi
          ;;
      esac

      exec ${lib.getExe pkgs.nh} "''${args[@]}"
    '';
  };

  nhWithLocalModules = pkgs.symlinkJoin {
    name = "nh-${pkgs.nh.version}-with-local-modules";
    paths = [ pkgs.nh ];
    meta.mainProgram = "nh";
    postBuild = ''
      rm "$out/bin/nh"
      ln -s ${lib.getExe nhWrapper} "$out/bin/nh"
    '';
  };
in
{
  programs.nh = {
    enable = true;
    flake = flakeDir;
    package = nhWithLocalModules;
  };
}
