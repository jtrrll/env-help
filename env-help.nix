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
      description = "Lists available scripts and their descriptions.";
      # TODO: Make it pretty
      exec = let
        scripts = builtins.removeAttrs config.scripts ["env-help"];
      in ''
        ${pkgs.gnused}/bin/sed -e 's| |••|g' -e 's|=| |' <<EOF | ${pkgs.util-linuxMinimal}/bin/column -t | ${pkgs.gnused}/bin/sed -e 's|^|> |' -e 's|••| |g'
        ${generators.toKeyValue {} (mapAttrs (_name: value: value.description) scripts)}
        EOF
      '';
    };
  };
}
