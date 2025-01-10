{
  pkgs,
  name,
  version,
  server,
  dockerImage,
}: let
  _name = "${name}-start-${version}";
  dockerContainer = pkgs.callPackage ../utils/mk-container.nix {
    inherit name version;
    image = dockerImage;
    podmanArgs = [
      "--publish"
      "8080:8080"
    ];
  };
in pkgs.writeShellApplication {
  name = _name;
  runtimeEnv = {
    SCRIPT_NAME = _name;
    START_SERVER = pkgs.lib.getExe server;
    START_SERVER_IN_CONTAINER = pkgs.lib.getExe dockerContainer;
  };
  text = builtins.readFile ./start.sh;
}
