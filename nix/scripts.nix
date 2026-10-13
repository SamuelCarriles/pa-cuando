{ pkgs }:
let
  nodeRuntime = [ pkgs.nodejs_24 ];
  dockerRuntime = [ pkgs.docker ];
  mkScript = pkgs.writeShellApplication;
in
{
  build = mkScript {
    runtimeInputs = nodeRuntime;
    name = "build";
    text = "npm run build";
  };

  run = mkScript {
    runtimeInputs = nodeRuntime;
    name = "run";
    text = "npm start";
  };

  buildImage = mkScript {
    name = "build-image";
    runtimeInputs = dockerRuntime ++ [ pkgs.nix ];
    text = builtins.readFile ../scripts/build-image.sh;
  };

  tagImage = mkScript {
    name = "tag-image";
    runtimeInputs = dockerRuntime;
    text = builtins.readFile ../scripts/tag-image.sh;
  };

  pushImage = mkScript {
    name = "push-image";
    runtimeInputs = dockerRuntime;
    text = builtins.readFile ../scripts/push-image.sh;
  };
}
