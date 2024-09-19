{
  flake = {
    devenvModule = {
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
                  then "$GREEN# ${description}$RESET"
                  else ""
                ))
              filtered;
              separator = "•";
            in ''
              GREEN=$(${pkgs.ncurses}/bin/tput setaf 2)
              RESET=$(${pkgs.ncurses}/bin/tput sgr0)

              ATTR_SET=$(${pkgs.uutils-coreutils-noprefix}/bin/cat << EOF
              ${lib.generators.toKeyValue {mkKeyValue = k: v: k + separator + v;} formatted}
              EOF
              )

              ${pkgs.uutils-coreutils-noprefix}/bin/printf "Script${separator}Description\n%s" "$ATTR_SET" \
              | ${pkgs.gum}/bin/gum table --print --separator ${separator}
            '';
          };
        };
      };
    };
  };
}
