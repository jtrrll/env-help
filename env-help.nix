{
  config,
  lib,
  pkgs,
  ...
}: {
  options = {
    env-help = {
      enable = lib.mkEnableOption "A help message for development environments.";
    };
  };
  config = lib.mkIf config.env-help.enable {
    scripts = {
      "env-help" = {
        description = "Lists available scripts and their descriptions.";
        exec = let
          filtered = builtins.removeAttrs config.scripts ["env-help"];
          formatted = lib.mapAttrs' (name: value: let
            script = lib.trim name;
            description = lib.trim value.description;
          in
            lib.nameValuePair script
            (
              if description != ""
              then "# ${description}"
              else ""
            ))
          filtered;
          separator = "\•";
        in ''
          COLS=$(${pkgs.ncurses}/bin/tput cols)
          GREEN=$(${pkgs.ncurses}/bin/tput setaf 2)
          RESET=$(${pkgs.ncurses}/bin/tput sgr0)

          ATTR_SET=$(${pkgs.uutils-coreutils-noprefix}/bin/cat << EOF
          ${lib.generators.toKeyValue {mkKeyValue = lib.generators.mkKeyValueDefault {} separator;} formatted}
          EOF
          )

          TABLE=$( \
          ${pkgs.uutils-coreutils-noprefix}/bin/printf "$ATTR_SET" \
          | ${pkgs.uutils-coreutils-noprefix}/bin/sort \
          | ${pkgs.util-linuxMinimal}/bin/column \
            --output-separator "${separator}" \
            --output-width "$(("$COLS" - 1))" \
            --separator "${separator}" \
            --table \
            --table-columns "script,description" \
            --table-noheadings \
            --table-truncate "description" \
          )

          ${pkgs.uutils-coreutils-noprefix}/bin/printf "Available scripts:\n"
          ${pkgs.uutils-coreutils-noprefix}/bin/printf "$TABLE\n" | ${pkgs.gnused}/bin/sed -e "s|${separator}\(.*\)|  "$GREEN"\1"$RESET"|"
        '';
      };
    };
  };
}
