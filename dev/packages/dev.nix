{pkgs, ...}: {
  imports = [(import ../../lib/package-options.nix "dev" (with pkgs; [
    {id = "nodejs"; package = nodejs;}
    {id = "scdoc"; package = scdoc;}
    {id = "gcc"; package = gcc;}
    {id = "libgccjit"; package = libgccjit;}
    {id = "cling"; package = cling;}
    {id = "clang"; package = clang;}
    {id = "rustc"; package = rustc;}
    {id = "rustup"; package = rustup;}
    {id = "cargo"; package = cargo;}
    {id = "arduino-ide"; package = arduino-ide;}
    {id = "go"; package = go;}
    {id = "gnumake"; package = gnumake;}
    {id = "python3"; package = python3;}
  ]))];
}
