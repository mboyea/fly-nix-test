{
  pkgs,
  name,
  version,
}: pkgs.writeShellApplication {
  name = "${name}-server-${version}";
  text = ''
    echo "Hello, World!"
    sleep infinity
  '';
}
