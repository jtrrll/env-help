{
  config,
  lib,
  pkgs,
  ...
}:
with lib; {
  options = {
    env-help = {
      enable = mkEnableOption "A help message for development environments.";
    };
  };
  config = mkIf config.env-help.enable {
    scripts."env-help" = {
      description = "A help message for development environments.";
      # TODO: Make it pretty
      # TODO: Filter out env-help from the listed scripts
      exec = ''
        ${pkgs.gnused}/bin/sed -e 's| |••|g' -e 's|=| |' <<EOF | ${pkgs.util-linuxMinimal}/bin/column -t | ${pkgs.gnused}/bin/sed -e 's|^|> |' -e 's|••| |g'
        ${generators.toKeyValue {} (mapAttrs (_name: value: value.description) config.scripts)}
        EOF
      '';
    };
  };
}
