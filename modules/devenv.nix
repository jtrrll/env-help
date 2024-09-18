{
  inputs,
  self,
  ...
}: {
  imports = [
    inputs.devenv.flakeModule
  ];
  perSystem = {pkgs, ...}: {
    devenv = {
      modules = [self.devenvModule {env-help.enable = true;}];
      shells.default = {
        enterShell = ''
          printf "                 _        _
           ___ _ ___ _____| |_  ___| |_ __
          / -_) ' \ V /___| ' \/ -_) | '_ \\
          \___|_||_\_/    |_||_\___|_| .__/
                                     |_|\n" | ${pkgs.lolcat}/bin/lolcat
          printf "\033[0;1;36mDEVSHELL ACTIVATED\033[0m\n"
        '';
        languages = {
          nix.enable = true;
        };
        packages = [
          pkgs.commitizen
        ];
        pre-commit = {
          default_stages = ["pre-push"];
          hooks = {
            actionlint.enable = true;
            alejandra.enable = true;
            check-added-large-files = {
              enable = true;
              stages = ["pre-commit"];
            };
            check-yaml.enable = true;
            commitizen.enable = true;
            deadnix.enable = true;
            detect-private-keys = {
              enable = true;
              stages = ["pre-commit"];
            };
            end-of-file-fixer.enable = true;
            flake-checker.enable = true;
            markdownlint.enable = true;
            mixed-line-endings.enable = true;
            nil.enable = true;
            no-commit-to-branch = {
              enable = true;
              stages = ["pre-commit"];
            };
            ripsecrets = {
              enable = true;
              stages = ["pre-commit"];
            };
            shellcheck.enable = true;
            shfmt.enable = true;
            statix.enable = true;
          };
        };
        scripts = {
          "lolcow" = {
            description = "Takes printf-like arguments and pipes the output through cowsay and lolcat.";
            exec = ''
              (${pkgs.uutils-coreutils-noprefix}/bin/printf "$@") | ${pkgs.cowsay}/bin/cowsay | ${pkgs.lolcat}/bin/lolcat
            '';
          };
          "no-desc-lolcow" = {
            exec = ''
              (${pkgs.uutils-coreutils-noprefix}/bin/printf "$@") | ${pkgs.cowsay}/bin/cowsay | ${pkgs.lolcat}/bin/lolcat
            '';
          };
        };
      };
    };
  };
}
