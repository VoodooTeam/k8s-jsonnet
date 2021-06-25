let                                
  stable = import (builtins.fetchTarball {                                
     name = "nixos-21.05";                                
     url = "https://github.com/NixOS/nixpkgs/archive/21.05.tar.gz";                                
     sha256 = "1ckzhh24mgz6jd1xhfgx0i9mijk6xjqxwsshnvq789xsavrmsc36";                                
  }) {};                                

  voodoo = import (builtins.fetchGit {
   url = "https://github.com/VoodooTeam/nix-pkgs.git";
   ref = "master";
  }) stable;
in                                
  stable.mkShell {                                
    buildInputs =
      [ 
         stable.go-jsonnet
         stable.bats
         stable.jq
         stable.kubeval
         voodoo.bats_1_3_0
      ];                                
    }
