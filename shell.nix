{ system ? builtins.currentSystem }:
let
  pkgs = import
    (builtins.fetchTarball {
      name = "nixos-21.05";
      url = "https://github.com/NixOS/nixpkgs/archive/21.05.tar.gz";
      sha256 = "1ckzhh24mgz6jd1xhfgx0i9mijk6xjqxwsshnvq789xsavrmsc36";
    })
    { };

  voodoo = import
    (builtins.fetchGit {
      url = "https://github.com/VoodooTeam/devops-nix-pkgs.git";
      ref = "master";
    })
    { inherit pkgs system; };
in
pkgs.mkShell {
  buildInputs =
    [
      pkgs.go-jsonnet
      pkgs.jq
      pkgs.kubeval
      voodoo.bats_1_3_0
      voodoo.polaris_4_0_4
    ];
}
