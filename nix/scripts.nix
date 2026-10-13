{ pkgs }:
let
  nodeRuntime = [ pkgs.nodejs_24 ];
  dockerRuntime = [ pkgs.docker ];
in
{
  build = pkgs.writeShellApplication {
    runtimeInputs = nodeRuntime;
    name = "build";
    text = "npm run build";
  };
  start = pkgs.writeShellApplication {
    runtimeInputs = nodeRuntime;
    name = "start";
    text = "npm start";
  };
  serverUp = pkgs.writeShellApplication {
    runtimeInputs = nodeRuntime;
    name = "server-up";
    text = ''
      npm run build
      npm start
    '';
  };

  release = pkgs.writeShellApplication {
    name = "release";
    runtimeInputs = dockerRuntime ++ [ pkgs.nix ];
    text = builtins.readFile ../scripts/release.sh;
  };

}
