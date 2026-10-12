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
    text = ''
      version="''${1:? Use: release <version>}"
      img_file="$(nix build .#default --no-link --print-out-paths)"

      sudo docker load --input "$img_file"

      local_image="pa-cuando:latest"
      remote_image="ghcr.io/SamuelCarriles/pa-cuando:$version"

      sudo docker tag "$local_image" "$remote_image"
      sudo docker push "$remote_image"
    '';
  };

}
