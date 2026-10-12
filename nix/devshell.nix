{
  perSystem =
    { pkgs, ... }:
    let
      node = pkgs.nodejs_24;
      commands = import ./aliases.nix {
        inherit pkgs;
        runtime = node;
      };
    in
    {
      devShells.default = pkgs.mkShell {
        packages = [
          node
          pkgs.docker
          commands.build
          commands.start
          commands.up
        ];
      };
    };
}
