{
  perSystem = { pkgs, ... }: {
    packages = {
      app = pkgs.buildNpmPackage {
        pname = "pa-cuando";
        version = "0.1.0";
        src = ../.;
        npmDepsHash = "sha256-s1qWtf4cS8kXaz/yxy+UUYV3H2bM0/aUjpBw/BjIB84=";
      };
    };
  };
}
