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
      config = lib.mkIf config.env-help.enable (let
        separator = "•";
        toRow = values:
          lib.pipe values [
            (builtins.map (value: (lib.trim (builtins.toString value))))
            (builtins.concatStringsSep separator)
          ];
        toTable = values:
          lib.pipe values [
            (builtins.map toRow)
            (builtins.concatStringsSep "\n")
          ];
      in {
        scripts = {
          "env-help" = {
            description = "Lists available scripts and their descriptions.";
            exec = let
              formatScripts = fields: let
                formatScript = name: script:
                  lib.pipe script [
                    (lib.getAttrs fields)
                    builtins.attrValues
                    (builtins.map (
                      value:
                        if value != ""
                        then "$GREEN# ${value}$RESET"
                        else ""
                    ))
                    (values: [name] ++ values)
                  ];
                headers = ["scripts"] ++ fields;
              in
                scripts:
                  lib.pipe scripts [
                    (set: builtins.removeAttrs set ["env-help"])
                    (lib.mapAttrsToList formatScript)
                    (lines: [headers] ++ lines)
                    toTable
                  ];
            in ''
              GREEN=$(${pkgs.ncurses}/bin/tput setaf 2)
              RESET=$(${pkgs.ncurses}/bin/tput sgr0)

              ${pkgs.gum}/bin/gum table --print --separator ${separator} << EOF
              ${formatScripts ["description"] config.scripts}
              EOF
            '';
          };
        };
      });
    };
  };
}
