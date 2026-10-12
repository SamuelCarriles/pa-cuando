{ pkgs, runtime }:
let
  runtimeInputs = [ runtime ];
in
{
  build = pkgs.writeShellApplication {
    inherit runtimeInputs;
    name = "build";
    text = "npm run build";
  };
  start = pkgs.writeShellApplication {
    inherit runtimeInputs;
    name = "start";
    text = "npm start";
  };
  up = pkgs.writeShellApplication {
    inherit runtimeInputs;
    name = "up";
    text = ''
      npm run build
      npm start
    '';
  };
}
