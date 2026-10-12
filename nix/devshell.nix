{
  perSystem =
    { pkgs, ... }:
    let
      node = pkgs.nodejs_24;
      commands = import ./shell-apps.nix {
        inherit pkgs;
      };
    in
    {
      devShells.default = pkgs.mkShell {
        packages = [
          node
          pkgs.docker
          commands.build
          commands.start
          commands.serverUp
        ];
      };
    };
}
