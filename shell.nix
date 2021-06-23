let                                
   stable = import (builtins.fetchTarball {                                
      name = "nixos-21.05";                                
      url = "https://github.com/NixOS/nixpkgs/archive/21.05.tar.gz";                                
      sha256 = "1wg61h4gndm3vcprdcg7rc4s1v3jkm5xd7lw8r2f67w502y94gcy";                                
   }) {};                                
in                                
  stable.mkShell {                                
    buildInputs =
      [
         stable.go-jsonnet
         stable.bats
         stable.jq
         stable.kubeval
     ];                                
  }      
