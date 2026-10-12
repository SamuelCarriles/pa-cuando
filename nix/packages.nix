{
  perSystem =
    { self, pkgs, ... }:
    let
      node = pkgs.nodejs_24;
      app = pkgs.buildNpmPackage {
        pname = "pa-cuando";
        version = "0.1.0";
        src = ../.;
        npmDepsHash = "sha256-s1qWtf4cS8kXaz/yxy+UUYV3H2bM0/aUjpBw/BjIB84=";
      };
      buildImage = pkgs.dockerTools.buildLayeredImage;
    in
    {
      packages.default = buildImage {
        name = "pa-cuando";
        tag = "latest";
        config = {
          Entrypoint = [ "${node}/bin/node" ];
          Cmd = [ "${app}/lib/node_modules/pa-cuando/dist/index.js" ];
        };
      };
    };
}
