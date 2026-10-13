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
          scripts.compile
          scripts.run
          scripts.buildImage
          scripts.tagImage
          scripts.pushImage
        ];
      };
    };
}
