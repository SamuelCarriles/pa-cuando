{
  perSystem =
    { pkgs, ... }:
    let
      node = pkgs.nodejs_24;
      scripts = import ./scripts.nix {
        inherit pkgs;
      };
    in
    {
      devShells.default = pkgs.mkShell {
        packages = [
          node
          pkgs.docker
          scripts.build
          scripts.run
          scripts.mongosh
          scripts.buildImage
          scripts.tagImage
          scripts.pushImage
        ];
      };
    };
}
